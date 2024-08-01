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

# Create VPC
resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.10.0.0/16"

    tags = {
        Name = "prod-vpc"
    }
}

# Create subnet inside VPC
resource "aws_subnet" "prod-subnet" {
    cidr_block = "10.10.1.0/24"
    availability_zone = "ap-southeast-1a"
    vpc_id = aws_vpc.prod-vpc.id
    
    tags = {
        Name = "prod-subnet"
    }
}

# Create internet gateway and attach it to the VPC
resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.prod-vpc.id

    tags = {
        Name = "prod-igw"
    }
}

# Create route table
resource "aws_route_table" "prod-rb" {
    vpc_id = aws_vpc.prod-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod-igw.id
    }

    tags = {
        Name = "prod-rb"
    }
}

# Attach route table to subnet
resource "aws_route_table_association" "rb-asso" {
    subnet_id = aws_subnet.prod-subnet.id
    route_table_id = aws_route_table.prod-rb.id
}

# Create security group for EC2
resource "aws_security_group" "prod-sg-allow-http-ssh" {
    name = "prod-sg-allow-http-ssh"
    description = "prod-sg-allow-http-ssh"
    vpc_id = aws_vpc.prod-vpc.id
    
    ingress {
        cidr_blocks       = ["0.0.0.0/0"]
        from_port         = 80
        protocol       = "tcp"
        to_port           = 80
    }

    ingress {
        cidr_blocks       = ["0.0.0.0/0"]
        from_port         = 22
        protocol       = "tcp"
        to_port           = 22
    }
    
    # Allow all
    egress {
        cidr_blocks       = ["0.0.0.0/0"]
        from_port         = 0
        protocol       = "-1"
        to_port           = 0
    }
}

# Create network interface
resource "aws_network_interface" "prod-eni" {
    subnet_id = aws_subnet.prod-subnet.id
    security_groups = [aws_security_group.prod-sg-allow-http-ssh.id]

    tags = {
        Name = "prod-eni"
    }
}

# Create Elastic IP
resource "aws_eip" "prod-eip" {
    depends_on = [aws_internet_gateway.prod-igw, aws_instance.prod-instance]
    domain = "vpc"
    network_interface = aws_network_interface.prod-eni.id

    tags = {
        Name = "prod-eip"
    }
}

# Create EC2 instance
resource "aws_instance" "prod-instance" {
    ami = "ami-012c2e8e24e2ae21d"
    instance_type = "t2.micro"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.prod-eni.id
    }

    tags = {
        Name = "prod-instance"
    }

    user_data = file("user_data.sh")
}

output "server-public-ip" {
    value = aws_eip.prod-eip.public_ip
}

