data "oci_containerengine_cluster_kube_config" "oke" {
  cluster_id = oci_containerengine_cluster.laravel_cluster.id
  # Use token-based kubeconfig for provider auth
  token_version = "2.0.0"
}

provider "kubernetes" {
  host                   = yamldecode(data.oci_containerengine_cluster_kube_config.oke.content)["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(yamldecode(data.oci_containerengine_cluster_kube_config.oke.content)["clusters"][0]["cluster"]["certificate-authority-data"])

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "oci"
    args = [
      "ce", "cluster", "generate-token",
      "--cluster-id", oci_containerengine_cluster.laravel_cluster.id,
      "--region", var.region
    ]
  }
}


