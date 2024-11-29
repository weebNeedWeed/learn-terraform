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

resource "aws_instance" "myec2" {
  ami           = "ami-0aa097a5c0d31430a"
  instance_type = "t2.micro"
}
