resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP/HTTPS/SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    dnf update -y
    dnf install -y httpd php docker git
    systemctl enable --now httpd
    systemctl enable --now docker
    usermod -a -G docker ec2-user
    echo "<h1>Welcome to vaultCart - Deployed in AZ 1b</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "${var.project_name}-web-server"
  }
}