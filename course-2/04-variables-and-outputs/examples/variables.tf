# General

variable "region" {
  default = "ap-southeast-1"
  type    = string
}

# EC2

variable "ami" {
  type    = string
  default = "ami-0b03299ddb99998e9"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

# RDS

variable "db_user" {
  type = string
}

variable "db_pass" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}
