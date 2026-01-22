# This tells the Root module to include the VPC module
module "vpc" {
  source = "./modules/vpc"
  
  # If your VPC module has variables, pass them here
  # e.g., vpc_cidr = "10.0.0.0/16"
}