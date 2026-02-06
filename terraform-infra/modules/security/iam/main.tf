# Create IAM Role for resources
resource "aws_iam_role" "resource_role" {
  name = "${var.resource_name}-role"

  assume_role_policy = jsonencode({
    Version = var.policy_version
    Statement = [
      for stmt in var.assume_role_policy_statement : {
        Effect = stmt.Effect
        Action = stmt.Action
        Principal = {
          for k, v in stmt.Principal : k => v if v != null
        }
      }
    ]
  })

  tags = {
    Name = "${var.resource_name}-role"
  }
}

# Attach AWS managed policies to the role
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = var.managed_policy_arns

  role       = aws_iam_role.resource_role.name
  policy_arn = each.value
}
