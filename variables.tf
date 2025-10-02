variable "rails_app_image_tag" {
  description = "A tag da imagem Docker da aplicação Rails."
  type        = string
  default     = "latest"
}

variable "mgc_region" {
  description = "A região da Magalu Cloud onde o cluster será criado."
  type        = string
  default     = "br-se1"
}

variable "mgc_availability_zone" {
  description = "A zona de disponibilidade para o node pool."
  type        = string
  default     = "br-se1-a"
}

variable "cluster_name" {
  description = "O nome do cluster Kubernetes."
  type        = string
  default     = "soat-challenge-cluster"
}

variable "cluster_version" {
  description = "A versão do Kubernetes a ser usada."
  type        = string
  default     = "1.32.3"
}

variable "node_count" {
  description = "O número de nós no node pool."
  type        = number
  default     = 1
}

variable "node_flavor" {
  description = "O tamanho (flavor) dos nós."
  type        = string
  default     = "c1.medium"
}

variable "secret_key" {
  type        = string
  sensitive   = true
  description = "Secret Key"
}