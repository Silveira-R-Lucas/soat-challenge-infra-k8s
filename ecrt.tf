resource "aws_ecr_repository" "services" {
  for_each = toset(["kitchen-service", "payment-service", "order-service"])
  
  name                 = "soat-challenge/${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_urls" {
  value = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}