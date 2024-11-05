variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# variable "subnet_id" {
#   description = "ID of the subnet to launch the EC2 instance in"
#   type        = string
# }

# variable "ami_id" {
#   description = "ID of the AMI to use for the EC2 instance"
#   type        = string
# }

# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
# }

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
}

# variable "user_data" {
#   description = "Base64-encoded user data for EC2 instance"
#   type        = string
#   default     = null
# }

# variable "iam_instance_profile" {
#   description = "Name of the IAM instance profile"
#   type        = string
# }

variable "alb_security_group_id" {
  description = "ID of the security group for the application load balancer"
  type        = string
}