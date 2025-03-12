resource "aws_instance" "instance" {
  count                  = 2
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
    Name = "instance ${count.index}"
  }
}
