# storage_encrypted = true
variable "db_subnet_group_name" {
  type        = string
  description = "Name of the subnet group from the root"
}
variable "db_security_group_id" {
  type        = string
  description = "ID of the security group from the root"
}

variable "db_password" {
  type      = string
  sensitive = true
}