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

module "web-app" {
  source = "../../modules/hello-world"
}

output "instance_ip_addr" {
  value = module.web-app.instance_ip_addr
}

output "url" {
  value = "http://${module.web-app.instance_ip_addr}:80"
}
