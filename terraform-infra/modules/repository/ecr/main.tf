resource "aws_ecr_repository" "ecr" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = {
    Name = var.repository_name
  }

}

#lifecycle policy
resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.lifecycle_policy_json != "" ? 1 : 0
  repository = aws_ecr_repository.ecr.name
  policy     = var.lifecycle_policy_json
}
