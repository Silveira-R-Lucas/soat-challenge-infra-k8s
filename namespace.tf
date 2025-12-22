resource "kubernetes_namespace_v1" "soat" {
  metadata {
    name = "soat-challenge"
  }
}