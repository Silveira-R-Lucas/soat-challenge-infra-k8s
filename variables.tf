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
  default     = "SoatChallengeAKS"
}

variable "gitops_repo_url" {
  description = "git@github.com:Silveira-R-Lucas/soat-challenge-infra-k8s.git"
  type        = string
}