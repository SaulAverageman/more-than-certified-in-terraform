#...rds/outputs...

output "rds-endpoint" {
  value = aws_db_instance.rds-res.endpoint
}