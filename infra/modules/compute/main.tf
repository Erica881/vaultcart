resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP/HTTPS/SSH for IPv4 and IPv6"
  vpc_id      = var.vpc_id

  # ingress {
  #   from_port = 80
  #   to_port   = 80
  #   protocol  = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # ingress {
  #   from_port = 443
  #   to_port   = 443
  #   protocol  = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # ingress {
  #   from_port = 22
  #   to_port   = 22
  #   protocol  = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # ingress {
  #   from_port   = 3000
  #   to_port     = 3000
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]      # Allow IPv4
  #   ipv6_cidr_blocks = ["::/0"]     # REQUIREMENT: Allow IPv6
  # }

  # HTTP
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] # Added IPv6
  }

  # HTTPS
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] # Added IPv6
  }

  # SSH (Optional: Usually kept to IPv4 for security, but added for completeness)
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] 
  }

  # Next.js Port
  ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] # Added IPv6 Outbound
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = var.target_subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # REQUIREMENT: Boot as root/user data
user_data = <<-EOF
    #!/bin/bash
    # 1. Install basics
    dnf update -y
    dnf install -y git
    curl -sL https://rpm.nodesource.com/setup_20.x | bash -
    dnf install -y nodejs
    npm install -g pm2

    # 2. Setup the folder and Env variables (Terraform knows the DB endpoint)
    mkdir -p /home/ec2-user/vaultcart
    cat <<EOT > /home/ec2-user/vaultcart/.env.local
    DATABASE_URL="mysql://admin:rdsPassword123!@${var.db_endpoint}:3306/vaultcart"
    NEXT_PUBLIC_API_URL="http://localhost:3000"
    EOT

    # 3. Fix permissions so ec2-user owns the folder created by root
    chown -R ec2-user:ec2-user /home/ec2-user/vaultcart
  EOF

  # Ensure you allow Port 3000 or Port 80 in your Security Group
  tags = {
    Name = "${var.project_name}-web-server" 
  }
}