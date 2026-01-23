data "aws_caller_identity" "current" {}

output "my_user_id" {
  value = data.aws_caller_identity.current.arn
}