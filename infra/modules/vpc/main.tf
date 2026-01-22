# 1. Security Group for Web Server (Public)
resource "aws_security_group" "web_sg" {
  name   = "vaultcart-web-sg"
  vpc_id = "vpc-067857a8b876c7a25" # Your Lab VPC ID

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Security Group for Database (Private)
resource "aws_security_group" "db_sg" {
  name   = "vaultcart-db-sg"
  vpc_id = "vpc-067857a8b876c7a25"

  ingress {
    from_port       = 1433 # Port for MSSQL
    to_port         = 1433
    protocol        = "tcp"
    # CRITICAL: Only allow traffic from the Web SG, not the internet
    security_groups = [aws_security_group.web_sg.id]
  }

  tags = { Name = "VaultCart-Private-DB-SG" }
}

resource "aws_db_subnet_group" "vaultcart_db_group" {
  name       = "vaultcart-db-subnet-group"
  # Use two subnet IDs from your vpc-0678... list for redundancy
  subnet_ids = ["subnet-095ba73355a62eaea", "subnet-0de969acdedef142b"]

  tags = { Name = "VaultCart DB Subnet Group" }
}