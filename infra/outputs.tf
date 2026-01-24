# output "vpc_id" {
#   value = module.networking.vpc_id
# }

# output "web_server_public_ip" {
#   description = "Public IP of the vaultCart Web Server"
#   value       = module.compute.public_ip
# }

output "vaultcart_url" {
  value = "http://${module.compute.public_ip}"
}

output "rds_endpoint" {
  description = "The endpoint for the RDS database (Paste this into the Web App)"
  value       = module.database.db_endpoint
}