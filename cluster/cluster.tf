terraform {
  required_providers {
    mgc = {
      source  = "MagaluCloud/mgc"
    }
  }
}

resource "mgc_kubernetes_cluster" "soat_cluster" {
  name    = var.cluster_name
  version = var.cluster_version
}

resource "mgc_kubernetes_nodepool" "main_pool" {
  name       = "main-worker-pool"
  cluster_id = mgc_kubernetes_cluster.soat_cluster.id
  replicas = var.node_count
  flavor_name = var.node_flavor
  availability_zones = [var.mgc_availability_zone]
}