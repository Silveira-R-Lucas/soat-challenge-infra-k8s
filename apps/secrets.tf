resource "kubernetes_secret_v1" "magalu_registry_secret" {
  metadata {
    name = "magalu-registry-secret"
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "container-registry.br-se1.magalu.cloud" = {
          username = local.magalu_cr_credentials.docker-username
          password = local.magalu_cr_credentials.docker-password
          auth     = base64encode("${local.magalu_cr_credentials.docker-username}:${local.magalu_cr_credentials.docker-password}")
        }
      }
    })
  }
}

resource "kubernetes_secret_v1" "rails_db_secret" {
  metadata {
    name = "rails-db-secret"
  }
  data = {
    DATABASE_URL = data.aws_secretsmanager_secret_version.db_url.secret_string
  }
}