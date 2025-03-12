terraform {
  backend "s3" {
    bucket         = "my-meowracle-bucket-state"
    key            = "04-variables-and-outputs/web-app/terraform.tfstate"
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
  region = var.region
}

resource "aws_instance" "instance1" {
  ami                    = var.ami
  instance_type          = var.instance-type
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
  ami                    = var.ami
  instance_type          = var.instance-type
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
  ip_protocol       = "-1"
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "-1"
  to_port           = "-1"
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

resource "aws_s3_bucket" "s3-bucket" {
  force_destroy = true
  bucket_prefix = var.s3-bucket-prefix
}

resource "aws_db_instance" "sql-db" {
  allocated_storage    = 10
  db_name              = var.db-name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db-user
  password             = var.db-pass
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true
}

resource "aws_route53_zone" "route53-zone" {
  name = var.domain-name
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.route53-zone.id
  name    = format("www.%s", var.domain-name)
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
