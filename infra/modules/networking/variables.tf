variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "lb_target_group_arn" {
  description = "ARN of the target group to attach to"
  type        = string
}