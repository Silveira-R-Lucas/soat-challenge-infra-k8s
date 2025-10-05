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
    MERCADOPAGO_SECRET              = var.mercadopago_secret
    MERCADOPAGO_NOTIFICATION_URL    = var.mercadopago_notification_url
    MERCADOPAGO_EXTERNAL_POS_ID     = var.mercadopago_external_pos_id
    MERCADOPAGO_USER_ID             = var.mercadopago_user_id
    MERCADOPAGO_TOKEN               = var.mercadopago_token
  }
}