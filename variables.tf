# variables.tf

variable "resource_group_name" {
  description = "DefaultResourceGroup-CQ"
  type        = string
}

variable "location" {
  description = "Brazil South"
  type        = string
  default     = "Brazil South"
}

variable "arc_cluster_name" {
  description = "SoatChallengeAKS"
  type        = string
  default     = "cluster-magalu-soat"
}

variable "gitops_repo_url" {
  description = "A URL do repositório Git que contém os manifestos do Kubernetes."
  type        = string
  # Exemplo: "git@github.com:seu-usuario/soat-challenge-k8s-manifests.git"
}