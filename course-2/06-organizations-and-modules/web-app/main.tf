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
  type = string
}

module "web-app" {
  source = "../web-app-module"

  # Variables
  region           = "ap-southeast-1"
  ami              = "ami-0b03299ddb99998e9"
  db-name          = "mydb11"
  db-user          = "mydbuser11"
  domain-name      = "meobeo1111.com"
  s3-bucket-prefix = "04folder"
  db-pass          = var.db-pass
}
