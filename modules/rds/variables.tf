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

variable "db_parameter_group_family" {
  description = "The family of the DB parameter group"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of VPC private subnet IDs"
  type        = list(string)
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
}


variable "db_credentials_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of KMS key for RDS encryption"
  type        = string
}