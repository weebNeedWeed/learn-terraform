terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "state-bucket" {
  bucket        = "my-meowracle-bucket-state"
  force_destroy = true
}

resource "aws_dynamodb_table" "lock-table" {
  name         = "my-meowracle-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
