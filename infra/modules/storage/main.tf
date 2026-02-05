resource "aws_s3_bucket" "vaultcart_s3" {
  bucket = "vaultcart-s3-a3a6dc2411123"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = "vaultcart-s3-a3a6dc2411123"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = "vaultcart-s3-a3a6dc2411123"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}