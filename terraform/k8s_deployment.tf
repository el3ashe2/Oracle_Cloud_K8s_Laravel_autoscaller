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
        image_pull_secrets {
          name = "ocirsecret"
        }
        container {
          name  = "laravel"
          image = "me-riyadh-1.ocir.io/ax45nhirzfe7/guapa:nginx-prod"
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
# ==============================
# Autoscaler
# ==============================
resource "kubernetes_horizontal_pod_autoscaler_v2" "laravel_autoscaler" {
  metadata {
    name = "laravel-hpa"
  }
  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = kubernetes_deployment.laravel.metadata[0].name
      api_version = "apps/v1"
    }
    min_replicas = 2
    max_replicas = 10
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
  depends_on = [oci_containerengine_node_pool.laravel_nodes]
}
