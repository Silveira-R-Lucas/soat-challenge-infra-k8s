resource "kubernetes_secret_v1" "magalu_registry_secret" {
  metadata {
    name = "magalu-registry-secret"
  }
  type = "kubernetes.ioio/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "container-registry.br-se1.magalu.cloud" = {
          username = var.magalu_cr_username
          password = var.magalu_cr_password
          auth     = base64encode("${var.magalu_cr_username}:${var.magalu_cr_password}")
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
    DATABASE_URL = var.database_url
  }
}