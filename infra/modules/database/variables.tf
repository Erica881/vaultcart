variable "project_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "web_sg_id" {
  description = "The Security Group ID of the Web Server"
  type        = string
}
variable "db_username" { default = "admin" }
variable "db_password" { default = "rdsPassword123!" }