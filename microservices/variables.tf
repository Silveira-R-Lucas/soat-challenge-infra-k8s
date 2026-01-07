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

variable "namespace" {
  type        = string
  description = "O namespace onde os recursos serão criados"
}

variable "command" {
  type        = list(string)
  default     = null
  description = "Comando customizado para o container (usado para o consumer)"
}

variable "use_tcp_probe" {
  type        = bool
  default     = false
  description = "Se verdadeiro, utiliza tcp_socket em vez de http_get nas probes"
}

variable "run_migrations" {
  type        = bool
  default     = false
  description = "Define se deve executar as migrações do Rails"
}

variable "master_key_app_name" {
  type        = string
  default     = null
  description = "Nome do app original para buscar a Master Key"
}

variable "enable_probes" {
  type        = bool
  default     = true
  description = "Define se as liveness e readiness probes devem ser criadas"
}