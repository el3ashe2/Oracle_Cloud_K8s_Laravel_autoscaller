resource "kubernetes_service" "laravel_service" {
  metadata {
    name      = "laravel-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "laravel" #kubernetes_deployment.laravel.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}
