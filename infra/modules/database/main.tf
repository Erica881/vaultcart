# 1. DB Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow MySQL access from Web Server"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.web_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }

  tags = { Name = "${var.project_name}-db-sg" }
}

# 2. DB Subnet Group (FIXED: Added lower())
resource "aws_db_subnet_group" "default" {
  # The 'name' must be lowercase
  name       = "${lower(var.project_name)}-db-subnet-group" 
  subnet_ids = var.private_subnet_ids

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

# 3. RDS Instance (FIXED: Added lower() to identifier)
resource "aws_db_instance" "default" {
  # RDS Identifiers must also be lowercase
  identifier             = "${lower(var.project_name)}-db"
  db_name                = "vaultcart"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  
  username               = var.db_username
  password               = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true
  
  tags = { Name = "${var.project_name}-db" }
}