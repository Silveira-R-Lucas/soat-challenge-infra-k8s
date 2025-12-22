resource "kubernetes_deployment_v1" "rabbitmq" {
  count     = var.deploy_apps ? 1 : 0  
  provider  = kubernetes.eks 

  metadata {
    name   = "rabbitmq"
    labels = { app = "rabbitmq" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "rabbitmq" } }
    template {
      metadata { labels = { app = "rabbitmq" } }
      spec {
        container {
          name  = "rabbitmq"
          image = "rabbitmq:3-management"
          
          port { 
            container_port = 5672 
            name           = "amqp" 
          }
          
          port { 
            container_port = 15672 
            name           = "management" 
          }

          env {
            name  = "RABBITMQ_DEFAULT_USER"
            value = "guest"
          }
          env {
            name  = "RABBITMQ_DEFAULT_PASS"
            value = "guest"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "rabbitmq_service" {
  count     = var.deploy_apps ? 1 : 0
  provider  = kubernetes.eks

  metadata { name = "rabbitmq-service" }
  spec {
    selector = { app = "rabbitmq" }
    port {
      name        = "amqp"
      port        = 5672
      target_port = 5672
    }
    type = "ClusterIP"
  }
}