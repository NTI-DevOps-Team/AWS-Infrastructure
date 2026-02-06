# ==================== Cluster Outputs ====================
output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.eks.id
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.eks.arn
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}


output "cluster_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.eks.version
}

output "cluster_platform_version" {
  description = "The platform version of the EKS cluster"
  value       = aws_eks_cluster.eks.platform_version
}

output "cluster_status" {
  description = "The status of the EKS cluster"
  value       = aws_eks_cluster.eks.status
}



# ==================== Security Group ====================
output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

# ==================== Node Groups ====================
output "node_group_ids" {
  description = "Map of node group IDs"
  value = {
    for k, ng in aws_eks_node_group.nodes : k => ng.id
  }
}

output "node_group_arns" {
  description = "Map of node group ARNs"
  value = {
    for k, ng in aws_eks_node_group.nodes : k => ng.arn
  }
}

output "node_group_status" {
  description = "Map of node group statuses"
  value = {
    for k, ng in aws_eks_node_group.nodes : k => ng.status
  }
}

output "node_group_resources" {
  description = "Map of node group resources (ASG, security groups)"
  value = {
    for k, ng in aws_eks_node_group.nodes : k => ng.resources
  }
}

# ==================== Cluster Summary ====================
output "cluster_summary" {
  description = "Summary of the EKS cluster configuration"
  value = {
    cluster_name        = aws_eks_cluster.eks.name
    cluster_version     = aws_eks_cluster.eks.version
    cluster_endpoint    = aws_eks_cluster.eks.endpoint
    cluster_status      = aws_eks_cluster.eks.status
    authentication_mode = var.authentication_mode
    node_groups_count   = length(aws_eks_node_group.nodes)
  }
}
