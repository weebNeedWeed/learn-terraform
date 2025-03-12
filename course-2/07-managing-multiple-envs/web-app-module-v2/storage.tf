resource "aws_s3_bucket" "s3-bucket" {
  force_destroy = true
  bucket_prefix = var.s3-bucket-prefix
}
