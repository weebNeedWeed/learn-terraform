variable "ami" {
  type        = string
  description = "Amazon Machine Image ID to use"
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2 instance"
}

variable "instance_name" {
  type        = string
  description = "Name tag for EC2 instance"
}

variable "db_name" {
  type        = string
  description = "Name for database"
}

variable "db_username" {
  type        = string
  description = "Username for database"
}

variable "db_password" {
  type        = string
  description = "Password for database"
}
