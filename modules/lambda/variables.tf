variable "environment" {
  description = "Environment name"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the Lambda function ZIP file"
  type        = string
}

variable "sendgrid_api_key" {
  description = "SendGrid API Key"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name for verification emails"
  type        = string
}

variable "secrets_kms_key_arn" {
  description = "ARN of the Secrets Manager KMS key"
  type        = string
}

variable "email_credentials_arn" {
  description = "ARN of the email credentials secret"
  type        = string
}