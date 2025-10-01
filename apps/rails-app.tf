resource "kubernetes_deployment_v1" "rails_app" {
  metadata {
    name = "rails-app-deployment"
    labels = {
      app = "rails-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "rails-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "rails-app"
        }
      }

      spec {
        container {
          name  = "rails"
          image = "seu-container-registry/soat-app-rails:${var.rails_app_image_tag}"

          port {
            container_port = 3000
          }

          env_from {
            secret_ref {
              name = "rails-secrets"
            }
          }
          env_from {
            secret_ref {
              name = "rails-db-secret" 
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "rails_app" {
  metadata {
    name = "rails-app-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.rails_app.spec.0.template.0.metadata.0.labels.app
    }
    port {
      protocol    = "TCP"
      port        = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}