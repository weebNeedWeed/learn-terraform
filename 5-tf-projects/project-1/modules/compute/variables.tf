variable "ami" {
  description = "AMI that is used for creating ec2 instances"
  type        = string
  default     = "ami-0b5a4445ada4a59b1"
}

variable "instance_type" {
  description = "Instance type of ec2 instances"
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "VPC where resources are created"
  type        = string
}

variable "ec2_sg_id" {
  description = "Security group of ec2 instances"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group of ALB"
  type        = string
}

variable "public_subnet_id" {
  description = "Id of public subset in which we place ALB"
  type        = string
}

variable "private_subnet_id" {
  description = "Id of private subset in which we place EC2s"
  type        = string
}
