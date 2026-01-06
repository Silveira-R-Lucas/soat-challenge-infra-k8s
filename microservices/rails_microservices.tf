resource "kubernetes_deployment_v1" "rails_microservices" {
  depends_on = [data.aws_secretsmanager_secret_version.app_master_key_val]
  
  metadata {
    name = "${var.app_name}-deployment"
    namespace = var.namespace
    labels = { app = var.app_name }
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = { app = var.app_name }
    }

    template {
      metadata {
        labels = { app = var.app_name }
        annotations = {
          "timestamp" = timestamp()
        }
      }

      spec {
        security_context {
          run_as_non_root = true
          run_as_user     = 1000
        }

        init_container {
          name  = "migrate"
          image = var.container_image
          command = ["/bin/sh", "-c", "bundle exec rails db:migrate"]
          
          env_from {
            secret_ref {
              name = kubernetes_secret_v1.rails_db_secret.metadata[0].name
            }
          }
          env {
            name  = "RAILS_ENV"
            value = "production"
          }
          env {
            name  = "RAILS_MASTER_KEY"
            value = data.aws_secretsmanager_secret_version.app_master_key_val.secret_string
          }
        }

        container {
          image = var.container_image
          name  = var.app_name
          command = var.command

          volume_mount {
            name       = "tmp-volume"
            mount_path = "/app/tmp"
          }

          port {
            container_port = var.app_port
          }

          env {
            name  = "MERCADOPAGO_NOTIFICATION_URL"
            value = var.mercadopago_notification_url
          }

          env {
            name  = "RABBITMQ_URL"
            value = var.rabbitmq_url
          }

          env {
            name  = "RAILS_MASTER_KEY"
            value = data.aws_secretsmanager_secret_version.app_master_key_val.secret_string
          }

          env {
            name  = "RAILS_ENV"
            value = "production"
          }
          env {
            name  = "RAILS_SERVE_STATIC_FILES"
            value = "true"
          }

          dynamic "env" {
            for_each = var.redis_url != null ? [1] : []
            content {
              name  = "REDIS_URL"
              value = var.redis_url
            }
          }

          dynamic "env" {
            for_each = var.mongodb_uri != null ? [1] : []
            content {
              name  = "MONGODB_URI"
              value = var.mongodb_uri
            }
          }

          dynamic "env" {
            for_each = var.database_url != null ? [1] : []
            content {
              name  = "DATABASE_URL"
              value = var.database_url
            }
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            dynamic "http_get" {
              for_each = var.use_tcp_probe ? [] : [1]
              content {
                path = "/404.html"
                port = var.app_port
              }
            }

            dynamic "tcp_socket" {
              for_each = var.use_tcp_probe ? [1] : []
              content {
                port = var.app_port
              }
            }
            
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            dynamic "http_get" {
              for_each = var.use_tcp_probe ? [] : [1]
              content {
                path = "/404.html"
                port = var.app_port
              }
            }

            dynamic "tcp_socket" {
              for_each = var.use_tcp_probe ? [1] : []
              content {
                port = var.app_port
              }
            }
            
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
          }
        }

        volume {
          name = "tmp-volume"
          empty_dir {}
        }
      }
    }
  }
}
