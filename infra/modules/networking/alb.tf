# 1. Create a Security Group specifically for the ALB
resource "aws_security_group" "lb_sg" {
  name        = "vaultcart-lb-sg"
  description = "Allow HTTP to Load Balancer"
  vpc_id      = aws_vpc.this.id  # <--- FIXED: Matches 'resource "aws_vpc" "this"'

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. The Load Balancer
resource "aws_lb" "vaultcart_lb" {
  name               = "vaultcart-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id 

  tags = {
    Name = "vaultcart-lb"
  }
}

# 3. The Target Group
resource "aws_lb_target_group" "vaultcart_tg" {
  name     = "vaultcart-targets"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id   
}

# 4. The Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.vaultcart_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vaultcart_tg.arn
  }
}