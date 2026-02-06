resource "aws_eks_cluster" "eks" {
  name     = var.eks_cluster_name
  version  = var.eks_cluster_version
  role_arn = var.cluster_role_arn

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    subnet_ids = concat(
      var.public_subnet_ids,
      var.private_subnet_ids
    )
    security_group_ids = var.cluster_security_group_ids
  }


  tags = {
    Name = var.eks_cluster_name
  }

  depends_on = [
    var.cluster_iam_role_policy_attachments
  ]
}

resource "aws_eks_node_group" "nodes" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = each.key
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  instance_types = each.value.instance_types
  ami_type       = each.value.ami_type
  disk_size      = each.value.disk_size
  capacity_type  = each.value.capacity_type

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  update_config {
    max_unavailable = each.value.max_unavailable
  }

  remote_access {
    ec2_ssh_key = var.ssh_key_name
  }

  tags = {
    Name = each.key
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  depends_on = [
    aws_eks_cluster.eks,
    var.node_iam_role_policy_attachments
  ]
}
