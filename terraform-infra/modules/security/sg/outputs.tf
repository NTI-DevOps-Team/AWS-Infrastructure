# ==================== Security Group Outputs ====================
output "security_group_ids" {
  description = "Map of security group names to their IDs"
  value = {
    for k, sg in aws_security_group.vpc_sg : k => sg.id
  }
}

output "web_security_group_id" {
  description = "The ID of the web security group"
  value       = try(aws_security_group.vpc_sg["web_sg"].id, null)
}

output "alb_security_group_id" {
  description = "The ID of the alb security group"
  value       = try(aws_security_group.vpc_sg["alb_sg"].id, null)
}

output "eks_node_security_group_id" {
  description = "The ID of the eks node security group"
  value       = try(aws_security_group.vpc_sg["eks_nodes_sg"].id, null)
}
