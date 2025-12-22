resource "kubernetes_secret_v1" "rails_db_secret" {
  metadata {
    name = "${var.app_name}db-secret"
    namespace = var.namespace
  }
  data = {
    DATABASE_URL = var.database_url
  }
}