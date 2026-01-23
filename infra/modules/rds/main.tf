# THE RDS INSTANCE (Updated for Lab Compatibility)
resource "aws_db_instance" "vaultcart_db" {
  identifier           = "vaultcart-db"
  engine               = "mysql"            # CHANGED: MSSQL is not allowed
  engine_version       = "8.0"              # Standard MySQL version
  instance_class       = "db.t3.micro"      # Burstable class (supported)
  allocated_storage    = 20
  storage_type         = "gp2"              # CHANGED: gp3 is not allowed
  
  username             = "admin"
  password             = "rdsPassword123!"
  port                 = 3306               # Standard MySQL port

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.db_security_group_id]
  
  publicly_accessible    = false
  storage_encrypted      = false           # Labs often block encryption
  skip_final_snapshot    = true 
  multi_az               = false           # CRITICAL: Standby instances are blocked

  # Ensure Enhanced Monitoring is DISABLED
  monitoring_interval = 0 
}