output "instance-1-ip" {
  value = aws_instance.instance1.public_ip
}

output "instance-2-ip" {
  value = aws_instance.instance2.public_ip
}

output "db-url" {
  value = aws_db_instance.sql-db.address
}
