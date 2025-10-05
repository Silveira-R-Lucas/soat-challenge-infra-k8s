terraform {
  backend "s3" {
    bucket         = "soat-challenge-bucket"
    key            = "soat-challenge/k8s/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}