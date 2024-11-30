variable "environment" {
  description = "Environment name"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of KMS key for S3 encryption"
  type        = string
}