terraform {
  backend "s3" {
    bucket         = "my-meowracle-bucket-state"
    key            = "03-basics/web-app/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "my-meowracle-lock-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "instance1" {
  ami                    = "ami-0b03299ddb99998e9"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = <<-EOF
                          dnf update -y
                          dnf install httpd -y
                          systemctl start httpd
                          systemctl enable httpd
                          EOF

  tags = {
    Name = "instance1"
  }
}

resource "aws_instance" "instance2" {
  ami                    = "ami-0b03299ddb99998e9"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install httpd -y
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "instance2"
  }
}

data "aws_vpc" "default-vpc" {
  default = true
}

data "aws_subnets" "default-public-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default-vpc.id]
  }
}

data "aws_subnet" "default-public-subnets" {
  for_each = toset(data.aws_subnets.default-public-subnets.ids)
  id       = each.value
}

resource "aws_security_group" "sg" {
  name   = "allow-http"
  vpc_id = data.aws_vpc.default-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow-http" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow-ssh" {
  ip_protocol       = "all"
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
}

resource "aws_lb" "lb" {
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.sg.id]
  subnets            = [for s in data.aws_subnet.default-public-subnets : s.id]
}

resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default-vpc.id
}

resource "aws_lb_target_group_attachment" "tg-attachment1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg-attachment2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.instance2.id
  port             = 80
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "lb-listener-rule" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
