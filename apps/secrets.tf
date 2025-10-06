resource "kubernetes_secret_v1" "magalu_registry_secret" {
  metadata {
    name = "magalu-registry-secret"
  }
  type = "kubernetes.io/dockerconfigjson"
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

resource "kubernetes_secret_v1" "rails_app_secrets" {
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