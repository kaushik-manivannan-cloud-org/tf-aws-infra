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