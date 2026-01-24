variable "region" { default = "us-east-1" }
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "ami_id" { default = "ami-0532be01f26a3de55" }
variable "instance_type" { default = "t2.micro" }
variable "key_name" { default = "vockey" }
variable "iam_instance_profile" { default = "LabInstanceProfile" }