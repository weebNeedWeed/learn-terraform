output "instance_ip_addr" {
  value = aws_instance.instance.public_ip
}

output "rds_address" {
  value = aws_db_instance.db_instance.address
}
