# 1. Initialize the VPC module
module "vpc" {
  source = "./modules/vpc"
}

# 2. Call the RDS module using OUTPUTS from the VPC module
module "rds" {
  source = "./modules/rds"

  # We pull the values from the 'vpc' module outputs
  db_subnet_group_name = module.vpc.db_subnet_group_name
  db_security_group_id = module.vpc.db_security_group_id
  
  db_password          = "StrongPassword_App1!"
}