############################################
# Get Kubernetes cluster config from OCI
############################################
data "oci_containerengine_cluster_kube_config" "laravel_kubeconfig" {
  cluster_id = oci_containerengine_cluster.laravel_cluster.id
}

############################################
# Kubernetes provider (for OKE)
############################################
provider "kubernetes" {
  host                   = yamldecode(data.oci_containerengine_cluster_kube_config.laravel_kubeconfig.content)["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(yamldecode(data.oci_containerengine_cluster_kube_config.laravel_kubeconfig.content)["clusters"][0]["cluster"]["certificate-authority-data"])

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

############################################
# Helm provider (uses Kubernetes provider)
############################################
provider "helm" {
  kubernetes = {
    host                   = yamldecode(data.oci_containerengine_cluster_kube_config.laravel_kubeconfig.content)["clusters"][0]["cluster"]["server"]
    cluster_ca_certificate = base64decode(yamldecode(data.oci_containerengine_cluster_kube_config.laravel_kubeconfig.content)["clusters"][0]["cluster"]["certificate-authority-data"])

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "oci"
      args = [
        "ce", "cluster", "generate-token",
        "--cluster-id", oci_containerengine_cluster.laravel_cluster.id,
        "--region", var.region
      ]
    }
  }
}

############################################
# Helm Release for Cluster Autoscaler
############################################
resource "helm_release" "cluster_autoscaler" {
  depends_on = [
    oci_containerengine_node_pool.laravel_nodes
  ]
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"

  set = [
    {
      name  = "autoDiscovery.clusterName"
      value = oci_containerengine_cluster.laravel_cluster.name
    },
    {
      name  = "awsRegion"
      value = var.region
    },
    {
      name  = "rbac.serviceAccount.create"
      value = "true"
    }
  ]

}
