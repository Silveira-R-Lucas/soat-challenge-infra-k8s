resource "azurerm_arc_kubernetes_flux_configuration" "app_config" {
  name       = "soat-app-config"
  cluster_id = "/subscriptions/b6427e39-73ed-4b61-a163-9adf7a231147/resourceGroups/defaultresourcegroup-cq/providers/Microsoft.Kubernetes/connectedClusters/SoatChallengeAKS"
  namespace  = "flux-system"
  scope      = "cluster"

  git_repository {
    url             = var.gitops_repo_url
    ssh_private_key_base64 = var.gitops_ssh_private_key
    reference_type  = "branch"
    reference_value = "main"
  }

  kustomizations {
    name                     = "rails-app"
    path                     = "./apps"
    sync_interval_in_seconds = 300
  }
}