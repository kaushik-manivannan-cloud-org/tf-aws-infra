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

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "application_security_group_id" {
  description = "ID of the application security group"
  value       = module.ec2.security_group_id
}