variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to launch the EC2 instance in"
  type        = string
}

variable "ami_id" {
  description = "ID of the AMI to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "user_data" {
  description = "Base64-encoded user data for EC2 instance"
  type        = string
  default     = null
}