# Networking Outputs
output "vpc_ids" {
  description = "Map of VPC IDs"
  value       = { for k, v in module.networking : k => v.vpc_id }
}

output "vpc_cidr_blocks" {
  description = "Map of VPC CIDR blocks"
  value       = { for k, v in module.networking : k => v.vpc_cidr_block }
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs for each VPC"
  value       = { for k, v in module.networking : k => v.public_subnet_ids }
}

output "public_subnet_cidr_blocks" {
  description = "Map of public subnet CIDR blocks for each VPC"
  value       = { for k, v in module.networking : k => v.public_subnet_cidr_blocks }
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs for each VPC"
  value       = { for k, v in module.networking : k => v.private_subnet_ids }
}

output "private_subnet_cidr_blocks" {
  description = "Map of private subnet CIDR blocks for each VPC"
  value       = { for k, v in module.networking : k => v.private_subnet_cidr_blocks }
}

output "internet_gateway_ids" {
  description = "Map of Internet Gateway IDs for each VPC"
  value       = { for k, v in module.networking : k => v.internet_gateway_id }
}

output "public_route_table_ids" {
  description = "Map of public route table IDs for each VPC"
  value       = { for k, v in module.networking : k => v.public_route_table_id }
}

output "private_route_table_ids" {
  description = "Map of private route table IDs for each VPC"
  value       = { for k, v in module.networking : k => v.private_route_table_id }
}

# EC2 Outputs
# output "ec2_instance_id" {
#   description = "ID of the EC2 instance"
#   value       = module.ec2.instance_id
# }

output "application_security_group_id" {
  description = "ID of the application security group"
  value       = module.ec2.security_group_id
}

# RDS Outputs
output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "rds_port" {
  description = "The port the RDS instance is listening on"
  value       = module.rds.db_instance_port
}

output "rds_name" {
  description = "The name of the RDS database"
  value       = module.rds.db_instance_name
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = module.rds.security_group_id
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for user verification"
  value       = module.sns.topic_arn
}

output "lambda_function_name" {
  description = "Name of the email verification Lambda function"
  value       = module.lambda.function_name
}