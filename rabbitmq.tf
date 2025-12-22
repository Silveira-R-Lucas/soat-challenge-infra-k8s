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
            name = "RABBITMQ_DEFAULT_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.rabbitmq_credentials.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "RABBITMQ_DEFAULT_PASS"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.rabbitmq_credentials.metadata[0].name
                key  = "password"
              }
            }
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

resource "kubernetes_secret_v1" "rabbitmq_credentials" {
  provider = kubernetes.eks
  
  metadata {
    name      = "rabbitmq-credentials"
    namespace = kubernetes_namespace_v1.soat.metadata[0].name
  }

  data = {
    username = var.rabbitmq_user
    password = var.rabbitmq_password
  }

  type = "Opaque"
}