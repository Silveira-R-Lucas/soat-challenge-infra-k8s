resource "kubernetes_secret_v1" "rails_db_secret" {
  metadata {
    name = "rails-db-secret"
  }
  data = {
    DATABASE_URL = var.database_url
  }
}