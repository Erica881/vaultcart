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