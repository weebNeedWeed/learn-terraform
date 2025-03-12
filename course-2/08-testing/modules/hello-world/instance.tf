resource "aws_instance" "instance" {
  ami                    = "ami-0b03299ddb99998e9"
  instance_type          = "t2.micro"
  depends_on             = [aws_vpc_security_group_egress_rule.allow-outbound]
  vpc_security_group_ids = [aws_security_group.instances.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install httpd -y
              systemctl start httpd
              systemctl enable httpd
              EOF
}

resource "aws_security_group" "instances" {
  name = "instance-sg"
}

resource "aws_vpc_security_group_ingress_rule" "allow-http" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.instances.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow-outbound" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.instances.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "-1"
  to_port           = "-1"
}

output "instance_ip_addr" {
  value = aws_instance.instance.public_ip
}
