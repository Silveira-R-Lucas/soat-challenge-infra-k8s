resource "kubernetes_secret" "rails_db_secret" {
  metadata {
    name = "rails-db-secret"
  }
  data = {
    DATABASE_URL = var.database_url
  }
}

resource "kubernetes_secret" "rails_app_secrets" {
  metadata {
    name = "rails-app-secrets"
  }
  data = {
    RAILS_MASTER_KEY                = var.rails_master_key
    IDENTIFY_CLIENT_FUNCTION_URL    = var.identify_client_function_url
    CREATE_USER_FUNCTION_URL        = var.create_user_function_url
    MERCADOPAGO_SECRET              = secrets.MERCADOPAGO_SECRET
    MERCADOPAGO_NOTIFICATION_URL    = vars.MERCADOPAGO_NOTIFICATION_URL
    MERCADOPAGO_EXTERNAL_POS_ID     = secrets.MERCADOPAGO_EXTERNAL_POS_ID
    MERCADOPAGO_USER_ID             = secrets.MERCADOPAGO_USER_ID
    MERCADOPAGO_TOKEN               = secrets.MERCADOPAGO_TOKEN
  }
}