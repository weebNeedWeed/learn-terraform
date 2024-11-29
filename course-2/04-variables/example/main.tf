terraform {
  backend "s3" {
    bucket         = "session-4-bucket-dogthecat"
    key            = "example/terraform.tfstate"
    region         = "ap-southeast-1"
    profile        = "DogTheCat"
    dynamodb_table = "session-4-lock-dogthecat"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "DogTheCat"
  region  = "ap-southeast-1"
}

locals {
  tags = {
    Owner = "DogTheCat"
    Env   = "Dev"
  }
}

resource "aws_instance" "instance_01" {
  ami           = var.ami
  instance_type = var.instance_type

  user_data = <<-EOF
  #! /bin/bash
  yum install -y httpd
  systemctl start httpd
  EOF

  tags = merge({
    Name = var.instance_name
  }, local.tags)
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  tags = merge(
    local.tags,
    { Name = var.db_name }
  )
}
