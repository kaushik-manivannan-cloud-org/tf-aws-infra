variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "alb_security_group_id" {
  description = "ID of the security group for the application load balancer"
  type        = string
}