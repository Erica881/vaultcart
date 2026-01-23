# # 1. Security Group for Web Server (Public)
# resource "aws_security_group" "web_sg" {
#   name   = "vaultcart-web-sg"
#   vpc_id = "vpc-052ddc1c5eea487d3" # Your Lab VPC ID

#   ingress {
#     from_port   = 3000
#     to_port     = 3000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Open to the world
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # 2. Security Group for Database (Private)
# resource "aws_security_group" "db_sg" {
#   name   = "vaultcart-db-sg"
#   vpc_id = "vpc-067857a8b876c7a25"

#   ingress {
#     from_port       = 1433 # Port for MSSQL
#     to_port         = 1433
#     protocol        = "tcp"
#     # CRITICAL: Only allow traffic from the Web SG, not the internet
#     security_groups = [aws_security_group.web_sg.id]
#   }

#   tags = { Name = "VaultCart-Private-DB-SG" }
# }

# resource "aws_db_subnet_group" "vaultcart_db_group" {
#   name       = "vaultcart-db-subnet-group"
#   # Use two subnet IDs from your vpc-0678... list for redundancy
#   subnet_ids = ["subnet-095ba73355a62eaea", "subnet-0de969acdedef142b"]

#   tags = { Name = "VaultCart DB Subnet Group" }
# }
# 1. Dynamically find the existing Lab VPC
# Note: In AWS Academy, the VPC often has the Name "lab-vpc" or "vpc". 
# Based on your previous error, let's use the most reliable filter.
data "aws_vpc" "lab_vpc" {
  id = var.target_vpc_id
}

# 2. Dynamically find ALL subnets within that VPC
# This grabs the list you saw in your terminal (us-east-1a, 1b, 1c, etc.)
data "aws_subnets" "lab_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab_vpc.id]
  }
}

# 3. Security Group for Web Server
resource "aws_security_group" "web_sg" {
  name   = "vaultcart-web-sg"
  vpc_id = data.aws_vpc.lab_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# 4. Security Group for Database
resource "aws_security_group" "db_sg" {
  name   = "vaultcart-db-sg"
  vpc_id = data.aws_vpc.lab_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  tags = { Name = "VaultCart-Private-DB-SG" }
}

# 5. DB Subnet Group using dynamic Subnet IDs
resource "aws_db_subnet_group" "vaultcart_db_group" {
  name       = "vaultcart-db-subnet-group"
  
  # data.aws_subnets.lab_subnets.ids contains all the subnets from your table
  # This ensures you have coverage in us-east-1a, 1b, 1c, 1d, and 1e.
  subnet_ids = data.aws_subnets.lab_subnets.ids 

  tags = { Name = "VaultCart DB Subnet Group" }
}