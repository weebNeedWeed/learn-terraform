terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "consul" {
  source  = "hashicorp/consul/aws"
  version = "0.11.0"
}
