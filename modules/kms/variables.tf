variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_role_arn" {
  description = "ARN of the IAM role for EC2 instances"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}