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
  source            = "../../modules/networking"
  public_subnet_az  = "ap-southeast-1a"
  private_subnet_az = "ap-southeast-1b"
}

module "compute" {
  source = "../../modules/compute"

  vpc_id            = module.networking.vpc_id
  ec2_sg_id         = module.networking.ec2_sg_id
  alb_sg_id         = module.networking.alb_sg_id
  private_subnet_id = module.networking.private_subnet_id
  public_subnet_id  = module.networking.public_subnet_id
}
