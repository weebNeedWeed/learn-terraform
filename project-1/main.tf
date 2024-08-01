terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region     = "ap-southeast-1"
    access_key = ""
    secret_key = ""
}

resource "aws_instance" "my-first-instance" {
    ami = "ami-012c2e8e24e2ae21d"
    instance_type = "t2.micro"

    tags = {
        Name = "hello-world"
    }
}
