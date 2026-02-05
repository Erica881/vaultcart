resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP/HTTPS/SSH for IPv4 and IPv6"
  vpc_id      = var.vpc_id

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

# This links your .tftpl file and injects the variables
  user_data = templatefile("${path.module}/userdata.tftpl", {
    jwt_secret  = var.jwt_secret
    db_host     = var.db_endpoint
    db_user     = var.db_user
    db_password = var.db_password
    db_name     = var.db_name
  })

  tags = {
    Name = "${var.project_name}-web-server" 
  }
}

resource "aws_lb_target_group_attachment" "web_attachment" {
  target_group_arn = var.lb_target_group_arn
  target_id        = aws_instance.web.id
  port             = 3000
}