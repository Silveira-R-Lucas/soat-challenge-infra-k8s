data "aws_secretsmanager_secret" "app_master_key" {
  name = "soat/${var.app_name}/master_key"
}

data "aws_secretsmanager_secret_version" "app_master_key_val" {
  secret_id = data.aws_secretsmanager_secret.app_master_key.id
}