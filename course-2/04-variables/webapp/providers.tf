terraform {
  backend "s3" {
    bucket         = "session-4-bucket-dogthecat"
    key            = "webapp/terraform.tfstate"
    region         = "ap-southeast-1"
    profile        = "DogTheCat"
    dynamodb_table = "session-4-lock-dogthecat"
    encrypt        = true
  }

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
