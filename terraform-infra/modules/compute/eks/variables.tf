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

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
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

# ==================== Network Configuration ====================
variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS node groups"
  type        = list(string)
}

variable "cluster_security_group_ids" {
  description = "Additional security group IDs to attach to the cluster"
  type        = list(string)
}


# ==================== Node Group Configuration ====================
variable "node_role_arn" {
  description = "ARN of the IAM role for the EKS node groups"
  type        = string
}

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

variable "ssh_key_name" {
  description = "Name of SSH Key"
  type        = string
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
