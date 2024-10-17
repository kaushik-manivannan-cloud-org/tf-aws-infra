output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "security_group_id" {
  description = "ID of the application security group"
  value       = aws_security_group.application.id
}