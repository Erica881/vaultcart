variable "project_name" {}
variable "vpc_id" {}
variable "target_subnet_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "iam_instance_profile" {}
variable "db_endpoint" {}
variable "db_password" {
  description = "RDS password passed from root"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT Secret for Next.js"
  type        = string
  sensitive   = true
}

variable "db_user" {}

variable "db_name" {
  type    = string
  default = "vaultcart"
}