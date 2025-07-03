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


