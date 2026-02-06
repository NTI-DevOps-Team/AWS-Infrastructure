
# security group variables
variable "vpc_id" {
  description = "VPC ID where the Security Groups will be created"
  type        = string
}

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
