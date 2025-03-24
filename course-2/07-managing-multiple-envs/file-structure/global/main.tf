terraform {
  backend "s3" {
    bucket       = "states-bucket-032422025"
    region       = "ap-southeast-1"
    key          = "states/global/terraform.tfstate"
    use_lockfile = true
  }
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

resource "aws_route53_zone" "primary" {
  name = "harley.id.vn"
}
