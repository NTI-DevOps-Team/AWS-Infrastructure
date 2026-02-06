# Variable definitions for the network module
#------------------vpc_variables--------------------
variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC and tag"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

#------------------subnet_variables--------------------
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
