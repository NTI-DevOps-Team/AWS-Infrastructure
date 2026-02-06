# ==================== VPC Information ====================
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

# ==================== Subnet Information ====================
output "private_subnet_ids" {
  description = "List of private subnet IDs for EKS worker nodes"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs for EKS load balancers"
  value       = module.vpc.public_subnet_ids
}

output "all_subnet_ids" {
  description = "Map of all subnet IDs"
  value       = module.vpc.subnet_ids
}

# ==================== NAT Gateway Information ====================
output "nat_gateway_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.vpc.nat_gateway_public_ip
}



# ==================== Security Groups ====================
output "security_groups" {
  description = "Map of all security group IDs"
  value       = module.sg.security_group_ids
}

output "web_sg_id" {
  description = "Web security group ID"
  value       = module.sg.web_security_group_id
}

output "alb_sg_id" {
  description = "alb security group ID"
  value       = module.sg.alb_security_group_id
}

output "eks_nodes_sg_id" {
  description = "eks nodes security group ID"
  value       = module.sg.eks_node_security_group_id
}

# ==================== EKS Configuration ====================
output "eks_vpc_config" {
  description = "Complete VPC configuration for EKS cluster"
  value       = module.vpc.eks_vpc_config
}

# ==================== Network Summary ====================
output "network_summary" {
  description = "Complete network infrastructure summary"
  value       = module.vpc.network_summary
}


# ==================== All IAM Roles ====================
output "iam_roles" {
  description = "Map of all created IAM roles with their details"
  value = {
    for k, role in module.iam : k => {
      role_arn             = role.role_arn
      role_name            = role.role_name
      attached_policy_arns = role.attached_policy_arns
    }
  }
}

# ==================== Specific Role Outputs (for easy access) ====================
output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = try(module.iam["eks_cluster"].role_arn, null)
}

output "eks_node_group_role_arn" {
  description = "ARN of the EKS node group IAM role"
  value       = try(module.iam["eks_node_group"].role_arn, null)
}

#-----------------ssh key output -------
output "ssh_key_name" {
  description = "Name of ssh key"
  value       = aws_key_pair.deployer
}


# ==================== EKS Cluster Outputs ====================
output "eks_cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}


output "eks_cluster_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = module.eks.cluster_version
}

output "eks_cluster_status" {
  description = "The status of the EKS cluster"
  value       = module.eks.cluster_status
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}
# ==================== EKS Node Groups Outputs ====================
output "eks_node_group_ids" {
  description = "Map of node group IDs"
  value       = module.eks.node_group_ids
}

output "eks_node_group_status" {
  description = "Map of node group statuses"
  value       = module.eks.node_group_status
}
# ==================== Infrastructure Summary ====================

output "infrastructure_summary" {
  description = "Summary of the complete infrastructure"
  value = {
    # Network
    vpc_id             = module.vpc.vpc_id
    vpc_cidr           = module.vpc.vpc_cidr
    availability_zones = module.vpc.availability_zones

    # EKS
    cluster_name    = module.eks.cluster_name
    cluster_version = module.eks.cluster_version
    node_groups     = keys(var.node_groups)
  }
}

# ==================== ECR Repository Outputs ====================
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}
output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}
