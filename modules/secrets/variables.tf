variable "environment" {
  description = "Environment name"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
}

variable "sendgrid_api_key" {
  description = "SendGrid API key"
  type        = string
}