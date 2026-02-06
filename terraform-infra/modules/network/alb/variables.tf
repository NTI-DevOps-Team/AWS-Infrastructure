#ALB Variables
variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for the ALB"
  type        = list(string)
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_type" {
  description = "Target type (instance, ip, lambda)"
  type        = string
  default     = "instance"
}

variable "port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "listener_port" {
  description = "Listener port"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Listener protocol"
  type        = string
  default     = "HTTP"
}
