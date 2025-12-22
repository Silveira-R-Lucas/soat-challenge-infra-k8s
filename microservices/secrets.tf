resource "kubernetes_secret_v1" "rails_db_secret" {
  metadata {
    name = "${var.app_name}db-secret"
    namespace = kubernetes_namespace_v1.soat.metadata[0].name
  }
  data = {
    DATABASE_URL = var.database_url
  }
}