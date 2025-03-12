# General Variables

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

# EC2 Variables

variable "ami" {
  type    = string
  default = "ami-0b03299ddb99998e9"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

# S3 Variables

variable "s3-bucket-prefix" {
  type = string
}

# Route53 Variables

variable "domain-name" {
  type = string
}

# RDS Variables

variable "db-user" {
  type = string
}

variable "db-name" {
  type    = string
  default = "mydb"
}

variable "db-pass" {
  type      = string
  sensitive = true
}
