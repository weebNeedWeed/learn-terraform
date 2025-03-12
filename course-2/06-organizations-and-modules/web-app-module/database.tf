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
