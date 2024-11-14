output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.email_verification.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.email_verification.function_name
}

output "role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda_role.arn
}