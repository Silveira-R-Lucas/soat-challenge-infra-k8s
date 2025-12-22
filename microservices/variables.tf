variable "identify_client_function_url" {
  description = "A URL da Azure Function para identificar clientes."
  type        = string
  sensitive   = true
  default     = null
}

variable "create_user_function_url" {
  description = "A URL da Azure Function para criar utilizadores."
  type        = string
  sensitive   = true
  default     = null
}

variable "mercadopago_token" {
  description = "TOKEN Mercado Pago."
  type        = string
  sensitive   = true
  default     = null
}

variable "mercadopago_user_id" {
  description = "User Mercado pago"
  type        = string
  sensitive   = true
  default     = null
}

variable "mercadopago_external_pos_id" {
  description = "Var Mercado Pago registro caixa"
  type        = string
  sensitive   = true
  default     = null
}

variable "mercadopago_notification_url" {
  description = "url de retorno de resposta Mercado Pago"
  type        = string
  default     = null
}

variable "mercadopago_secret" {
  description = "O segredo do webhook do Mercado Pago."
  type        = string
  sensitive   = true
  default     = null
}

variable "database_url" {
  type      = string
  sensitive = true
  default     = null
}

variable "redis_url" {
  type      = string
  sensitive = true
  default     = null
}

variable "mongodb_uri" {
  type      = string
  sensitive = true
  default     = null
}

variable "app_name" { 
  type = string 
}

variable "container_image" { 
  type = string 
}

variable "replicas" { 
  type    = number
  default = 2 
}

variable "rabbitmq_url" { 
  type = string 
}

variable "app_port" {
  type        = number
  description = "A porta que o Service irá expor"
}