# # 1. Configure the Provider
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

# # 2. Networking (VPC, Subnet, IGW)
# resource "aws_vpc" "vaultcart_vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true

#   tags = {
#     Name    = "vaultcart-vpc"
#     Project = "vaultCart"
#   }
# }

# resource "aws_internet_gateway" "vaultcart_igw" {
#   vpc_id = aws_vpc.vaultcart_vpc.id

#   tags = {
#     Name    = "vaultcart-igw"
#     Project = "vaultCart"
#   }
# }

# resource "aws_subnet" "vaultcart_public_subnet" {
#   vpc_id                  = aws_vpc.vaultcart_vpc.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name    = "vaultcart-public-subnet"
#     Project = "vaultCart"
#   }
# }

# # 3. Routing
# resource "aws_route_table" "vaultcart_public_rt" {
#   vpc_id = aws_vpc.vaultcart_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.vaultcart_igw.id
#   }

#   tags = {
#     Name    = "vaultcart-public-rt"
#     Project = "vaultCart"
#   }
# }

# resource "aws_route_table_association" "vaultcart_assoc" {
#   subnet_id      = aws_subnet.vaultcart_public_subnet.id
#   route_table_id = aws_route_table.vaultcart_public_rt.id
# }

# # 4. Security Group
# resource "aws_security_group" "vaultcart_web_sg" {
#   name        = "vaultcart-web-sg"
#   description = "Allow HTTP and SSH for vaultCart"
#   vpc_id      = aws_vpc.vaultcart_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name    = "vaultcart-web-sg"
#     Project = "vaultCart"
#   }
# }

# # 5. vaultCart Web Server
# resource "aws_instance" "vaultcart_web" {
#   ami                    = "ami-0532be01f26a3de55"
#   instance_type          = "t2.micro"
#   key_name               = "vockey"
#   subnet_id              = aws_subnet.vaultcart_public_subnet.id
#   vpc_security_group_ids = [aws_security_group.vaultcart_web_sg.id]
#   iam_instance_profile   = "LabInstanceProfile"

#   user_data = <<-EOF
#     #!/bin/bash
#     # Update and Install vaultCart dependencies
#     dnf update -y
#     dnf install -y httpd wget php mariadb105-server docker git
    
#     # Start Services
#     systemctl enable --now httpd
#     systemctl enable --now docker
#     usermod -a -G docker ec2-user

#     # Setup vaultCart App Directory
#     mkdir -p /var/www/html/vaultcart
#     # (Optional: Replace with your actual git clone command)
#     echo "<h1>Welcome to vaultCart</h1>" > /var/www/html/index.html
#   EOF

#   tags = {
#     Name    = "vaultcart-web-server"
#     Project = "vaultCart"
#   }
# }
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# 1. Call the Networking Module
module "networking" {
  source             = "./modules/networking"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}

# 2. Call the Compute Module
module "compute" {
  source               = "./modules/compute"
  project_name         = var.project_name
  vpc_id               = module.networking.vpc_id
  # REQUIREMENT: Attach to Public Subnet 2 (which is index 1)
  target_subnet_id     = module.networking.public_subnet_ids[1] 
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
}