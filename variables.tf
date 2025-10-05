variable "aws_region" {
  description = "A região da AWS onde os recursos serão criados."
  type        = string
  default     = "sa-east-1"
}

variable "cluster_name" {
  description = "O nome do cluster Kubernetes EKS."
  type        = string
  default     = "soat-challenge-cluster"
}

variable "cluster_version" {
  description = "A versão do Kubernetes a ser usada."
  type        = string
  default     = "1.33"
}

variable "node_count" {
  description = "O número de nós no node pool."
  type        = number
  default     = 1
}

variable "node_flavor" {
  description = "O tipo de instância (flavor) dos nós."
  type        = string
  default     = "t3.small"
}

variable "rails_app_image_tag" {
  description = "A tag da imagem Docker da aplicação Rails."
  type        = string
  default     = "latest"
}

variable "database_url" {
  description = "A URL de conexão completa para o banco de dados do Rails."
  type        = string
  sensitive   = true
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
  description = "User Mercado pago""
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