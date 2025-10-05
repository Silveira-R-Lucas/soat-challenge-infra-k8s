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