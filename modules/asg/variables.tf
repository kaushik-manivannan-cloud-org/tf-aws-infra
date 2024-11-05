variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "ID of the AMI to use for EC2 instances"
  type        = string
}

variable "application_security_group_id" {
  description = "ID of the application security group"
  type        = string
}

variable "iam_instance_profile" {
  description = "Name of the IAM instance profile"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "user_data" {
  description = "Base64-encoded user data script"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}