data "aws_vpc" "default-vpc" {
  default = true
}

data "aws_subnet" "default-subnet-a" {
  vpc_id            = data.aws_vpc.default-vpc.id
  availability_zone = var.availability_zone
}

data "aws_subnets" "default-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default-vpc.id]
  }
}

resource "aws_s3_bucket" "web-app-bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "web-app-bucket-encrypt" {
  bucket = aws_s3_bucket.web-app-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_security_group" "instance-sg" {
  name   = "instance-sg"
  vpc_id = data.aws_vpc.default-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance-01" {
  ami           = "ami-0aa097a5c0d31430a"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.default-subnet-a.id

  vpc_security_group_ids = [aws_security_group.instance-sg.id]

  user_data = <<-EOF
  #! /bin/bash
  yum install -y httpd
  systemctl start httpd
  EOF

  tags = {
    Name = "instance-01"
  }
}

resource "aws_instance" "instance-02" {
  ami           = "ami-0aa097a5c0d31430a"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.default-subnet-a.id

  vpc_security_group_ids = [aws_security_group.instance-sg.id]

  user_data = <<-EOF
  #! /bin/bash
  yum install -y httpd
  systemctl start httpd
  EOF

  tags = {
    Name = "instance-02"
  }
}

resource "aws_lb" "web-app-alb" {
  name               = "web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.instance-sg.id]
  subnets            = data.aws_subnets.default-subnets.ids
}

resource "aws_lb_target_group" "web-app-alb-tg" {
  name     = "web-app-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default-vpc.id
}

resource "aws_lb_target_group_attachment" "web-app-alb-tg-attachment-01" {
  target_group_arn = aws_lb_target_group.web-app-alb-tg.arn
  target_id        = aws_instance.instance-01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web-app-alb-tg-attachment-02" {
  target_group_arn = aws_lb_target_group.web-app-alb-tg.arn
  target_id        = aws_instance.instance-02.id
  port             = 80
}

resource "aws_lb_listener" "web-app-alb-listener" {
  load_balancer_arn = aws_lb.web-app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-app-alb-tg.arn
  }
}

data "aws_route53_zone" "web-app-zone" {
  name = "livekit.meowracle.live."
}

resource "aws_route53_record" "web-app-record" {
  zone_id = data.aws_route53_zone.web-app-zone.id
  name    = "hello.${data.aws_route53_zone.web-app-zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.web-app-alb.dns_name
    zone_id                = aws_lb.web-app-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_db_instance" "web-app-db" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}
