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

module "compute" {
  source               = "./modules/compute"
  project_name         = var.project_name
  vpc_id               = module.networking.vpc_id
  target_subnet_id     = module.networking.public_subnet_ids[1] # AZ 1b
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
  db_endpoint          = module.database.db_endpoint
  # Link secrets from Root variables
  db_password          = var.db_password 
  jwt_secret           = var.jwt_secret
  db_user              = var.db_user
  lb_target_group_arn = module.networking.target_group_arn
}

# --- NEW: Database Module Block ---
module "database" {
  source             = "./modules/database"
  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  
  # Pass Private Subnets from Networking Module
  private_subnet_ids = module.networking.private_subnet_ids
  
  # Pass Security Group ID from Compute Module
  web_sg_id          = module.compute.web_sg_id
  
  # Credentials
  db_username        = var.db_user
  db_password        = var.db_password
}

# module "storage" {
#   source             = "./modules/storage"
# }


