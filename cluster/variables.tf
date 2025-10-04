variable "cluster_name" {
  description = "O nome do cluster Kubernetes a ser criado."
  type        = string
}

variable "mgc_region" {
  description = "A região da Magalu Cloud onde o cluster será criado."
  type        = string
}

variable "cluster_version" {
  description = "A versão do Kubernetes a ser usada."
  type        = string
}

variable "node_count" {
  description = "O número de nós no node pool."
  type        = number
}

variable "node_flavor" {
  description = "O tamanho (flavor) dos nós."
  type        = string
}