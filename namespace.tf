resource "kubernetes_namespace_v1" "soat" {
  provider = kubernetes.eks
  
  metadata {
    name = "soat-challenge"
  }
}