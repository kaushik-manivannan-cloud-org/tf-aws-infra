output "instance_profile_name" {
  description = "Name of the instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "instance_role_arn" {
  description = "ARN of the instance role"
  value       = aws_iam_role.ec2_role.arn
}