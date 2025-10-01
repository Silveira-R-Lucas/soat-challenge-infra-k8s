data "azurerm_kubernetes_cluster" "arc_cluster" {
  name                = var.arc_cluster_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_k8s_flux_configuration" "app_config" {
  name                = "soat-app-config"
  cluster_id          = data.azurerm_kubernetes_cluster.arc_cluster.id
  namespace           = "flux-system"
  scope               = "cluster"

  git_repository {
    url      = var.gitops_repo_url
    ssh_private_key = file("~/.ssh/id_rsa") 

    reference_type = "branch"
    reference_value = "main"
  }

  kustomization {
    name = "rails-app"
    path = "./apps"
    sync_interval_in_seconds = 300
  }
}