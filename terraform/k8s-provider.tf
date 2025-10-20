data "oci_containerengine_cluster_kube_config" "laravel_kubeconfig" {
  cluster_id = oci_containerengine_cluster.laravel_cluster.id
}

provider "kubernetes" {
  host                   = oci_containerengine_cluster.laravel_cluster.endpoints[0].public_endpoint
  cluster_ca_certificate = base64decode(oci_containerengine_cluster.laravel_cluster.endpoints[0].ca_certificate)
  token                  = data.oci_containerengine_cluster_kube_config.laravel_kubeconfig.token
}
