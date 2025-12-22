data "aws_secretsmanager_secrets" "db_search" {
  filter {
    name   = "name"
    values = ["soat/db/database_url"]
  }
}

data "aws_secretsmanager_secret_version" "db_url" {
  count     = length(data.aws_secretsmanager_secrets.db_search.names) > 0 ? 1 : 0
  secret_id = "soat/db/database_url"
}

data "aws_secretsmanager_secrets" "redis_search" {
  filter {
    name   = "name"
    values = ["soat/db/redis_url"]
  }
}

data "aws_secretsmanager_secret_version" "redis_url" {
  count     = length(data.aws_secretsmanager_secrets.redis_search.names) > 0 ? 1 : 0
  secret_id = "soat/db/redis_url"
}

data "aws_secretsmanager_secrets" "mongo_search" {
  filter {
    name   = "name"
    values = ["soat/db/mongodb_url"]
  }
}

data "aws_secretsmanager_secret_version" "mongodb_url" {
  count     = length(data.aws_secretsmanager_secrets.mongo_search.names) > 0 ? 1 : 0
  secret_id = "soat/db/mongodb_url"
}


locals {
  database_url_val = length(data.aws_secretsmanager_secret_version.db_url) > 0 ? data.aws_secretsmanager_secret_version.db_url[0].secret_string : ""
  redis_url_val    = length(data.aws_secretsmanager_secret_version.redis_url) > 0 ? data.aws_secretsmanager_secret_version.redis_url[0].secret_string : ""
  mongodb_url_val  = length(data.aws_secretsmanager_secret_version.mongodb_url) > 0 ? data.aws_secretsmanager_secret_version.mongodb_url[0].secret_string : ""
}