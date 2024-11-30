output "ec2_key_arn" {
  description = "ARN of the EC2 KMS key"
  value       = aws_kms_key.ec2.arn
}

output "rds_key_arn" {
  description = "ARN of the RDS KMS key"
  value       = aws_kms_key.rds.arn
}

output "s3_key_arn" {
  description = "ARN of the S3 KMS key"
  value       = aws_kms_key.s3.arn
}

output "secrets_key_arn" {
  description = "ARN of the Secrets Manager KMS key"
  value       = aws_kms_key.secrets.arn
}