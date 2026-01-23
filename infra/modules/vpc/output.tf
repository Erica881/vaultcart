output "db_subnet_group_name" {
  value = aws_db_subnet_group.vaultcart_db_group.name
}

output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}