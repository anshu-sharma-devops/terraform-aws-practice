output "rds_endpoint" {
  value = aws_db_instance.mydb.endpoint
}

output "rds_engine" {
  value = aws_db_instance.mydb.engine
}

output "rds_instance_class" {
  value = aws_db_instance.mydb.instance_class
}