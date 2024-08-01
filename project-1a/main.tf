terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "ap-southeast-1"
    profile = "DogTheCat"
}

resource "aws_vpc" "first-vpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = "my-first-vpc"
    }
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.first-vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "subnet1"
    }
}
