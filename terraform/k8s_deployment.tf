resource "kubernetes_deployment" "laravel" {
  metadata {
    name      = "laravel-app"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "laravel"
      }
    }

    template {
      metadata {
        labels = {
          app = "laravel"
        }
      }

      spec {
        container {
          name  = "laravel"
          image = "ghcr.io/yourrepo/laravel:latest"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "laravel_autoscaler" {
  metadata {
    name = "laravel-hpa"
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.laravel.metadata[0].name
      api_version = "apps/v1"
    }

    min_replicas = 2
    max_replicas = 10

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type               = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
}
