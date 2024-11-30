variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "ec2_kms_key_arn" {
  description = "ARN of the EC2 KMS key"
  type        = string
}

variable "rds_kms_key_arn" {
  description = "ARN of the RDS KMS key"
  type        = string
}

variable "s3_kms_key_arn" {
  description = "ARN of the S3 KMS key"
  type        = string
}

variable "secrets_kms_key_arn" {
  description = "ARN of the Secrets KMS key"
  type        = string
}

variable "db_credentials_arn" {
  description = "ARN of the database credentials secret"
  type        = string
}