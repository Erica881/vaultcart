# provider "aws" {
#     region = "us-east-1"
# }

# resource "aws_instance" "app_server" {
#   ami                  = var.ami_id
#   instance_type        = "t3.micro"
#   subnet_id            = var.private_subnet_id
#   vpc_security_group_ids = [var.app_sg_id]
#   iam_instance_profile = aws_iam_instance_profile.app_profile.name

#   # The automation script to fulfill "Optimized deployment"
#   user_data = file("${path.module}/scripts/deploy.sh")

#   tags = {
#     Name = "Secure-NextJS-App"
#   }
# }