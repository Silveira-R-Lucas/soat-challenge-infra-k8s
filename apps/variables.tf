variable "rails_app_image_tag" {
  type = string
}

variable "rails_master_key" {
  description = "A RAILS_MASTER_KEY para decifrar as credenciais."
  type        = string
  sensitive   = true
}

variable "identify_client_function_url" {
  description = "A URL da Azure Function para identificar clientes."
  type        = string
  sensitive   = true
}

variable "create_user_function_url" {
  description = "A URL da Azure Function para criar utilizadores."
  type        = string
  sensitive   = true
}

variable "mercadopago_token" {
  description = "TOKEN Mercado Pago."
  type        = string
  sensitive   = true
}

variable "mercadopago_user_id" {
  description = "User Mercado pago"
  type        = string
  sensitive   = true
}

variable "mercadopago_external_pos_id" {
  description = "Var Mercado Pago registro caixa"
  type        = string
  sensitive   = true
}

variable "mercadopago_notification_url" {
  description = "url de retorno de resposta Mercado Pago"
  type        = string
}

variable "mercadopago_secret" {
  description = "O segredo do webhook do Mercado Pago."
  type        = string
  sensitive   = true
}