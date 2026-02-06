# Outputs for IAM Role Module
output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.resource_role.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.resource_role.name
}

output "role_id" {
  description = "The ID of the IAM role"
  value       = aws_iam_role.resource_role.id
}

output "role_unique_id" {
  description = "The unique ID of the IAM role"
  value       = aws_iam_role.resource_role.unique_id
}

output "attached_policy_arns" {
  description = "List of attached managed policy ARNs"
  value       = [for k, v in aws_iam_role_policy_attachment.managed_policies : v.policy_arn]
}


