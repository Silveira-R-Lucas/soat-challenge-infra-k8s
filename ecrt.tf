resource "aws_ecr_repository" "rails_app" {
  name                 = "soat-challenge/rails-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "SOAT Challenge"
    ManagedBy = "Terraform"
  }
}

output "ecr_repository_url" {
  description = "A URL do repositório ECR da aplicação."
  value       = aws_ecr_repository.rails_app.repository_url
}