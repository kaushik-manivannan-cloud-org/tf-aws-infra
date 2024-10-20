variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "database_port" {
  description = "Port on which the database runs"
  type        = number
}

variable "application_security_group_id" {
  description = "ID of the application security group"
  type        = string
}