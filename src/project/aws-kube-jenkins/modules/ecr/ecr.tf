resource "aws_ecr_repository" "app" {
  name                = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  tags = {
    Name        = "${var.repository_name}-repository"
    Environment = "aws-iac"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}