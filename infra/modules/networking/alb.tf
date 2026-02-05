# modules/networking/alb.tf

resource "aws_lb" "vaultcart_lb" {
  name               = "vaultcart-lb"
  internal           = false
  load_balancer_type = "application"
  # Reference the security group you defined in networking/main.tf
  security_groups    = [aws_security_group.web_sg.id] 
  
  # IMPORTANT: Check your subnet names in networking/main.tf and update these references!
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] 

  tags = {
    Name = "vaultcart-lb"
  }
}

resource "aws_lb_target_group" "vaultcart_tg" {
  name     = "vaultcart-targets"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id   # Check if your VPC resource is named 'main' or something else
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.vaultcart_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vaultcart_tg.arn
  }
}