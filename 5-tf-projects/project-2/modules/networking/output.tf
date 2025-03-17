output "ec2_web_subnet_id" {
  value = aws_subnet.web.id
}

output "ec2_app_subnet_id" {
  value = aws_subnet.app.id
}

output "ec2_db_subnet_id" {
  value = aws_subnet.db.id
}

output "web_sg_id" {
  value = aws_security_group.web-sg.id
}

output "app_sg_id" {
  value = aws_security_group.app-sg.id
}

output "db_sg_id" {
  value = aws_security_group.db-sg.id
}
