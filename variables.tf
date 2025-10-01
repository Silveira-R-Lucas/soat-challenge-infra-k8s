variable "resource_group_name" {
  description = "Nome do grupo de recursos Azure"
  type        = string
}

variable "location" {
  description = "Brazil South"
  type        = string
  default     = "Brazil South"
}

variable "arc_cluster_name" {
  description = "Nomde do cluster conectado no Azure"
  type        = string
}

variable "gitops_repo_url" {
  description = "git@github.com:Silveira-R-Lucas/soat-challenge-infra-k8s.git"
  type        = string
  default     = "git@github.com:Silveira-R-Lucas/soat-challenge-infra-k8s.git"
}

variable "gitops_ssh_private_key" {
  description = "A chave SSH privada (em formato Base64) para aceder ao repositório Git."
  type        = string
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "O ID da subscrição do Azure onde os recursos serão provisionados."
  type        = string
}