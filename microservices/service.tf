resource "kubernetes_service_v1" "app_service" {
  metadata {
    name      = "${var.app_name}-service"
    namespace = "default"
    labels = {
      app = var.app_name
    }
  }

  spec {
    selector = {
      app = var.app_name 
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = var.app_port
    }

    type = "LoadBalancer"
  }
}