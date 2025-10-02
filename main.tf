terraform {
  required_providers {
    mgc = {
      source = "magalucloud/mgc"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "mgc" {
  api_key = var.mgc_api_key
}

module "kubernetes_cluster" {
  source = "./cluster"

  cluster_name          = var.cluster_name
  mgc_region            = var.mgc_region
  cluster_version       = var.cluster_version
  node_count            = var.node_count
  node_flavor           = var.node_flavor
  mgc_availability_zone = var.mgc_availability_zone
}

provider "kubernetes" {
  config_context = module.kubernetes_cluster.cluster_kubeconfig_content
}

module "kubernetes_apps" {
  source              = "./apps"
  depends_on          = [module.kubernetes_cluster]
  rails_app_image_tag = var.rails_app_image_tag
}