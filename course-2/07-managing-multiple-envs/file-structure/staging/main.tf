terraform {
  backend "s3" {
    bucket       = "states-bucket-032422025"
    region       = "ap-southeast-1"
    key          = "states/staging/terraform.tfstate"
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

variable "db-pass" {
  type = string
}

locals {
  environment_name = "staging"
}

module "web-app" {
  source = "../../web-app-module-v2"

  # Variables
  environment-name = local.environment_name
  region           = "ap-southeast-1"
  ami              = "ami-0b03299ddb99998e9"
  db-name          = "${local.environment_name}mydb"
  db-user          = "mydbuser11"
  domain-name      = "harley.id.vn"
  s3-bucket-prefix = "web-app-data-${local.environment_name}"
  db-pass          = var.db-pass
  create-dns-zone  = false
}
