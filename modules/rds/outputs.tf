output "security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database.id
}