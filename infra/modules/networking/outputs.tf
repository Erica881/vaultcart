output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.vaultcart_tg.arn
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.vaultcart_lb.dns_name
}