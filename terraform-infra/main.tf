# Backend
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-734468801857"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

# Provider
provider "aws" {
  region = var.region
}

# Network Module
# VPC Module
module "vpc" {
  source = "./modules/network/vpc"

  region   = var.region
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  subnets  = var.subnets
}


#Security Module
#sg module
module "sg" {
  source         = "./modules/security/sg"
  vpc_id         = module.vpc.vpc_id
  security_group = var.security_group
}

#IAM Module for EKS
module "iam" {
  source   = "./modules/security/iam"
  for_each = var.iam_roles

  resource_name                = each.value.resource_name
  policy_version               = each.value.policy_version
  assume_role_policy_statement = each.value.assume_role_policy_statement
  managed_policy_arns          = each.value.managed_policy_arns
}

#SSH Key
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

#EKS Module
module "eks" {
  source = "./modules/compute/eks"

  # Cluster configuration
  eks_cluster_name    = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version
  cluster_role_arn    = module.iam["eks_cluster"].role_arn

  # Access configuration
  authentication_mode                         = var.authentication_mode
  bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions

  # vpc configuration
  public_subnet_ids          = module.vpc.public_subnet_ids
  private_subnet_ids         = module.vpc.private_subnet_ids
  cluster_security_group_ids = compact([module.sg.eks_node_security_group_id])


  # Node groups
  node_role_arn = module.iam["eks_node_group"].role_arn
  node_groups   = var.node_groups

  ssh_key_name = aws_key_pair.deployer.key_name

  # Dependencies
  cluster_iam_role_policy_attachments = [
    module.iam["eks_cluster"]
  ]

  node_iam_role_policy_attachments = [
    module.iam["eks_node_group"]
  ]
}

# ECR Module
module "ecr" {
  source                = "./modules/compute/ecr"
  repository_name       = var.ecr_repository_name
  image_tag_mutability  = var.ecr_image_tag_mutability
  scan_on_push          = var.ecr_scan_on_push
  lifecycle_policy_json = var.ecr_lifecycle_policy_json
}
