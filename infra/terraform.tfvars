project_name       = "vaultCart"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# REQUIREMENT: 4 Subnets Total
public_subnets     = ["10.0.0.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.1.0/24", "10.0.3.0/24"]

db_user            = "admin"
db_password        = "rdsPassword123!"
jwt_secret         = "YourUltraSecureRandomString123!"