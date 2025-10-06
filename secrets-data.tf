data "aws_secretsmanager_secret_version" "db_url" {
  secret_id = "soat/db/database_url"
}

data "aws_secretsmanager_secret_version" "magalu_cr" {
  secret_id = "soat/k8s/app-secrets"
}

locals {
  magalu_cr_credentials = jsondecode(data.aws_secretsmanager_secret_version.magalu_cr.secret_string)
  app_secrets           = jsondecode(data.aws_secretsmanager_secret_version.app_secrets.secret_string)
}