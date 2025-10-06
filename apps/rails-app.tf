variable "ecr_repository_url" {
  description = "A URL do repositório ECR"
  type        = string
}

resource "kubernetes_deployment_v1" "rails_app" {
  metadata {
    name   = "rails-app-deployment"
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
          image = "${var.ecr_repository_url}:${var.rails_app_image_tag}"

          port {
            container_port = 3000
          }
          
          env_from {
            secret_ref {
              name = kubernetes_secret_v1.rails_db_secret.metadata[0].name
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