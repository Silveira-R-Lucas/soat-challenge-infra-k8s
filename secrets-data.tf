data "aws_secretsmanager_secret_version" "db_url" {
  secret_id = "soat/db/database_url"
}

data "aws_secretsmanager_secret_version" "redis_url" {
  secret_id = "soat/db/redis_url"
}

data "aws_secretsmanager_secret_version" "mongodb_url" {
  secret_id = "soat/db/mongodb_url"
}
