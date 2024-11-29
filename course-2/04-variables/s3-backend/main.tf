terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "DogTheCat"
}

resource "aws_s3_bucket" "backend-state-bucket" {
  bucket        = "session-4-bucket-dogthecat"
  force_destroy = true
}

resource "aws_dynamodb_table" "backend-state-lock" {
  name           = "session-4-lock-dogthecat"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}
