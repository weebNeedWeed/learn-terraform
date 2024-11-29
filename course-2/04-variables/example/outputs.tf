output "instance_private_ip" {
  value = aws_instance.instance_01.private_ip
}

output "db_dns" {
  value = aws_db_instance.rds_instance.address
}
