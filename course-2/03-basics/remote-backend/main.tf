terraform {
  # backend "s3" {
  #   bucket         = "dogthecat-state-bucket"
  #   key            = "original/terraform.tfstate"
  #   dynamodb_table = "dogthecat-state-lock"
  #   region         = "ap-southeast-1"
  #   encrypt        = true
  #   profile        = "DogTheCat"
  # }

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

resource "aws_s3_bucket" "state-bucket" {
  bucket        = "dogthecat-state-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "state-bucket-versioning" {
  depends_on = [aws_s3_bucket.state-bucket]
  bucket     = aws_s3_bucket.state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "state-lock" {
  name           = "dogthecat-state-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}



