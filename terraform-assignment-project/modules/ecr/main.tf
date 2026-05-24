# ============================================================
# MODULE: ecr/main.tf
# ECR = Elastic Container Registry
# A private Docker image registry managed by AWS.
# Jenkins will build and push images here; EKS will pull from here.
# ============================================================

resource "aws_ecr_repository" "main" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"   # allows overwriting tags like "latest"

  # Scan images for known vulnerabilities automatically on push
  image_scanning_configuration {
    scan_on_push = true
  }

  # Encrypt images at rest using AES-256
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "${var.project_name}-ecr"
  }
}

# ---------- Lifecycle Policy ----------
# Automatically deletes untagged images older than 30 days
# to save storage costs.
resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Delete untagged images after 30 days"
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = 30
      }
      action = { type = "expire" }
    }]
  })
}
