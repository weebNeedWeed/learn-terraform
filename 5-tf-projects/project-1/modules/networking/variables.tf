variable "public_subnet_az" {
  type        = string
  description = "The AZ used to create subnets in"
}

variable "private_subnet_az" {
  type        = string
  description = "The AZ used to create subnets in"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The cidr block of the main vpc"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.0.0/24"
  description = "The cidr block of the public subnet"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "The cidr block of the private subnet"
}

