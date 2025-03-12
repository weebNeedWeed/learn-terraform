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

variable "db-pass" {
  type      = string
  sensitive = true
}

locals {
  environment_name = terraform.workspace
}

module "web-app" {
  source = "../web-app-module-v2"

  # Variables
  environment-name = local.environment_name
  region           = "ap-southeast-1"
  ami              = "ami-0b03299ddb99998e9"
  db-name          = "${local.environment_name}mydb"
  db-user          = "mydbuser11"
  domain-name      = "meobeo1111.com"
  s3-bucket-prefix = "web-app-data-${local.environment_name}"
  db-pass          = var.db-pass
  create-dns-zone  = local.environment_name == "production" ? true : false
}
