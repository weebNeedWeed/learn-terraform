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

module "networking" {
  source = "../../modules/networking"
}

module "compute" {
  source = "../../modules/compute"

  ec2_app_subnet_id = module.networking.ec2_app_subnet_id
  ec2_web_subnet_id = module.networking.ec2_web_subnet_id
  ec2_db_subnet_id  = module.networking.ec2_db_subnet_id

  app_sg_id = module.networking.app_sg_id
  web_sg_id = module.networking.web_sg_id
  db_sg_id  = module.networking.db_sg_id
}
