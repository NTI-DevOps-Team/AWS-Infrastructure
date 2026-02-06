#ec2 instance variables
variable "ec2_ssh_key" {
  description = "The EC2 SSH key pair name for accessing the worker nodes"
  type        = string
}
variable "instance_name" {
  description = "The name tag for the EC2 instance"
  type        = string
}
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}
variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be launched"
  type        = string
}
variable "security_group_id" {
  description = "The security group ID to associate with the EC2 instance"
  type        = string
}
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the EC2 instance"
  type        = bool
}
variable "instance_type" {
  description = "EC2 instance type for the instance"
  type        = string
}

variable "bootstrap_script" {
  description = "Path to the bootstrap script for EC2 user_data"
  type        = string
}
