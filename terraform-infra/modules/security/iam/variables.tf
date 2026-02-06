variable "resource_name" {
  description = "The name of the IAM role (will be suffixed with -role)"
  type        = string
}

variable "policy_version" {
  description = "The version of the IAM policy"
  type        = string
  default     = "2012-10-17"
}

variable "assume_role_policy_statement" {
  description = "The assume role policy statement for the IAM role"
  type = list(object({
    Effect = string
    Action = list(string)
    Principal = object({
      Service   = optional(list(string))
      AWS       = optional(list(string))
      Federated = optional(string)
    })
  }))
}

# Managed policy ARNs to attach to the IAM role
variable "managed_policy_arns" {
  description = "Set of AWS managed or customer managed policy ARNs to attach to the role"
  type        = set(string)
}
