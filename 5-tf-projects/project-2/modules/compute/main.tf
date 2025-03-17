data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.ec2_web_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.web_sg_id]

  tags = {
    "Name" = "web-instance"
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.ec2_app_subnet_id
  vpc_security_group_ids = [var.app_sg_id]

  tags = {
    "Name" = "app-instance"
  }
}

resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.ec2_db_subnet_id
  vpc_security_group_ids = [var.db_sg_id]

  tags = {
    "Name" = "db-instance"
  }
}
