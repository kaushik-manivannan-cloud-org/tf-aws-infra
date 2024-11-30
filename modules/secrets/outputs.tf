output "db_credentials_arn" {
  description = "ARN of the database credentials secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "email_credentials_arn" {
  description = "ARN of the SendGrid credentials secret"
  value       = aws_secretsmanager_secret.email_credentials.arn
}

output "db_password" {
  description = "Generated database password"
  value       = random_password.db_password.result
  sensitive   = true
}