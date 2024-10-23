output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.database.endpoint
}

output "db_instance_name" {
  description = "The database name"
  value       = aws_db_instance.database.db_name
}

output "db_instance_port" {
  description = "The port the database is listening on"
  value       = aws_db_instance.database.port
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = aws_db_instance.database.username
}

output "security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database.id
}