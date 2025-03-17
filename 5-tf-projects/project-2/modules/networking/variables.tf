variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "web_subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "app_subnet_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}

variable "db_subnet_cidr_block" {
  type    = string
  default = "10.0.3.0/24"
}

