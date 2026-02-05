# resource "aws_s3_bucket" "vaultcart_s3" {
#   bucket = "vaultcart-s3-a3a6dc2411123"
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
#   bucket = "vaultcart-s3-a3a6dc2411123"

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }

#   # ADD THIS: Forces TF to skip the "Reading" phase for this resource
#   lifecycle {
#     ignore_changes = all
#   }
# }

# resource "aws_s3_bucket_public_access_block" "block_public" {
#   bucket = "vaultcart-s3-a3a6dc2411123"

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true

#   # ADD THIS: Forces TF to skip the "Reading" phase for this resource
#   lifecycle {
#     ignore_changes = all
#   }
# }

# check the s3 name in aws console, it must done upload the cloudformation first, to run this
data "aws_s3_bucket" "existing_bucket" {
  bucket = "vaultcart-s3-unique-cloudformation-12322"
}

# Now you can still use the bucket ID for your EC2 permissions
output "s3_bucket_id" {
  value = data.aws_s3_bucket.existing_bucket.id
}