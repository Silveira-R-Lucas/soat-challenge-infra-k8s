resource "kubernetes_secret_v1" "rails_db_secret" {
  count = var.database_url != null ? 1 : 0

  metadata {
    name      = "${var.app_name}db-secret"
    namespace = var.namespace
  }

  data = {
    DATABASE_URL = var.database_url
  }
}