variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "vpcs" {
  description = "Map of VPC configurations"
  type = map(object({
    cidr_block           = string
    public_subnet_cidrs  = list(string)
    private_subnet_cidrs = list(string)
  }))
}

variable "availability_zones" {
  description = "Availability zones to use for subnets"
  type        = list(string)
}

variable "environment" {
  description = "Environment (e.g., dev, demo)"
  type        = string
}

variable "ami_id" {
  description = "ID of the custom AMI to use for EC2 instances"
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