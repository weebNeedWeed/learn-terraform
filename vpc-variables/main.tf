terraform {
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

variable "vpc-cidr-block" {
  description = "Vpc cidr block"
}

variable "prod-subnet-cidr-block" {
  description = "Subnet cidr block"
  type        = string
}

variable "dev-subnet-cidr-blocks" {
  type = list(string)
}

variable "staging-subnets" {
  type = list(object({
    cidr-block = string
    name       = string
  }))
}

resource "aws_vpc" "prod-vpc" {
  cidr_block = var.vpc-cidr-block

  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "prod-subnet" {
  cidr_block = var.prod-subnet-cidr-block
  vpc_id     = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-subnet"
  }
}

resource "aws_subnet" "dev-subnet1" {
  cidr_block = var.dev-subnet-cidr-blocks[0]
  vpc_id     = aws_vpc.prod-vpc.id

  tags = {
    Name = "dev-subnet1"
  }
}

resource "aws_subnet" "dev-subnet2" {
  cidr_block = var.dev-subnet-cidr-blocks[1]
  vpc_id     = aws_vpc.prod-vpc.id

  tags = {
    Name = "dev-subnet2"
  }
}

resource "aws_subnet" "staging-subnet1" {
  cidr_block = var.staging-subnets[0].cidr-block
  vpc_id     = aws_vpc.prod-vpc.id

  tags = {
    Name = var.staging-subnets[0].name
  }
}

resource "aws_subnet" "staging-subnet2" {
  cidr_block = var.staging-subnets[1].cidr-block
  vpc_id     = aws_vpc.prod-vpc.id

  tags = {
    Name = var.staging-subnets[1].name
  }
}
