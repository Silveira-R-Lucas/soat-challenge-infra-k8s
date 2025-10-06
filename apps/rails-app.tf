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
        annotations = {
          "timestamp" = timestamp()
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

          command = ["/rails/bin/docker-entrypoint"]
          args    = ["bin/rails", "server", "-b", "0.0.0.0"]
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

output "app_url" {
  description = "A URL de acesso para a aplicação Rails."
  value       = "http://${kubernetes_service_v1.rails_app.status[0].load_balancer[0].ingress[0].hostname}:3000"
}