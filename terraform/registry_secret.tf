locals {
  ocir_dockerconfig = {
    auths = {
      "${var.ocir_server}" = {
        username = var.ocir_username
        password = var.ocir_auth_token
        email    = var.ocir_email
        auth     = base64encode("${var.ocir_username}:${var.ocir_auth_token}")
      }
    }
  }
}

resource "kubernetes_secret" "ocirsecret" {
  metadata {
    name      = "ocirsecret"
    namespace = "default"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = base64encode(jsonencode(local.ocir_dockerconfig))
  }

  depends_on = [oci_containerengine_node_pool.laravel_nodes]
}


