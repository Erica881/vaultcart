output "public_ip" {
  value = aws_instance.web.public_ip
}

# ADD THIS: Export the Security Group ID so the DB module can use it
output "web_sg_id" {
  value = aws_security_group.web_sg.id
}