variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}