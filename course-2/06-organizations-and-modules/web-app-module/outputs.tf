output "instance-1-ip" {
  value = aws_instance.instance[0].public_ip
}

output "instance-2-ip" {
  value = aws_instance.instance[1].public_ip
}

output "db-url" {
  value = aws_db_instance.sql-db.address
}
