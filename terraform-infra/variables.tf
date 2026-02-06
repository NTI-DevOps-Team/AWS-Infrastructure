# Variable definitions for AWS VPC, Subnets and EKS configuration
#provider variables
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

#VPC variables
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string

}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

#Subnet variables
variable "subnets" {
  description = "A map of subnets to create with their CIDR blocks and availability zones"
  type = map(object({
    subnet_name     = string
    cidr            = string
    az_name         = string
    public_ip       = bool
    enable_eks_tags = bool
  }))
}

# Security group variables
variable "security_group" {
  description = "A map of security groups to create"
  type = map(object({
    name        = string
    description = string
    inbound_rules = map(object({
      protocol  = string
      from_port = number
      to_port   = number
      cidr_ipv4 = string
    }))
    outbound_rules = map(object({
      protocol  = string
      from_port = number
      to_port   = number
      cidr_ipv4 = string
    }))
  }))
}

# IAM Policy variables
variable "iam_roles" {
  description = "Map of IAM roles to create"
  type = map(object({
    resource_name  = string
    policy_version = optional(string, "2012-10-17")
    assume_role_policy_statement = list(object({
      Effect = string
      Action = list(string)
      Principal = object({
        Service   = optional(list(string))
        AWS       = optional(list(string))
        Federated = optional(string)
      })
    }))
    managed_policy_arns = optional(set(string), [])
  }))
}

# EKS Cluster Configuration Variables
# -------------- Cluster Configuration --------------
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.31"
}

# ==================== Access Configuration ====================
variable "authentication_mode" {
  description = "Authentication mode for the cluster (API, API_AND_CONFIG_MAP, CONFIG_MAP)"
  type        = string
  default     = "API"
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Whether to bootstrap cluster creator admin permissions"
  type        = bool
  default     = true
}
# EKS Endpoint Configuration
variable "eks_endpoint_private_access" {
  description = "Whether the EKS cluster endpoint is private"
  type        = bool
  default     = true
}

variable "eks_endpoint_public_access" {
  description = "Whether the EKS cluster endpoint is public"
  type        = bool
  default     = false
}

# Environment
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# ==================== Network Configuration ====================
variable "cluster_security_group_ids" {
  description = "Additional security group IDs to attach to the cluster"
  type        = list(string)
  default     = []
}


# ==================== Node Group Configuration ====================
variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    instance_types  = list(string)
    ami_type        = string
    disk_size       = number
    capacity_type   = string
    desired_size    = number
    max_size        = number
    min_size        = number
    max_unavailable = number
    tags            = optional(map(string), {})
  }))
}

# ==================== Dependencies ====================
variable "cluster_iam_role_policy_attachments" {
  description = "List of IAM policy attachments for the cluster role"
  type        = list(any)
  default     = []
}

variable "node_iam_role_policy_attachments" {
  description = "List of IAM policy attachments for the node role"
  type        = list(any)
  default     = []
}

# ==================== ECR Configuration ====================
variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}
variable "ecr_image_tag_mutability" {
  description = "Whether image tags are mutable or immutable in ECR"
  type        = string
  default     = "MUTABLE"
}
variable "ecr_scan_on_push" {
  description = "Whether to enable image scan on push in ECR"
  type        = bool
  default     = true
}
variable "ecr_lifecycle_policy_json" {
  description = "ECR lifecycle policy"
  type        = string
}
