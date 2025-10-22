resource "oci_containerengine_cluster" "laravel_cluster" {
  name           = "laravel-cluster"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.laravel_vcn.id
  kubernetes_version = "v1.33.1" # Update to your OCI region's supported version
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.laravel_subnet.id
  }
  options {
    service_lb_subnet_ids = [oci_core_subnet.laravel_subnet.id]
  }
}
resource "oci_containerengine_node_pool" "laravel_nodes" {
  name            = "laravel-node-pool"
  cluster_id      = oci_containerengine_cluster.laravel_cluster.id
  compartment_id  = var.compartment_id
  node_shape      = "VM.Standard.E4.Flex"
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id = oci_core_subnet.laravel_subnet.id
    }
    size = 2
  }
  node_shape_config {
    ocpus = 2
    memory_in_gbs = 16
  }
  node_source_details {
    source_type = "image"
    image_id    = data.oci_core_images.oracle_linux_latest.id
  }
}
# 🔹 Get list of availability domains in your tenancy
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}
# 🔹 Get the latest Oracle Linux image for worker nodes
data "oci_core_images" "oracle_linux_latest" {
  compartment_id = var.compartment_id
  operating_system = "Oracle Linux"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
  filter {
    name   = "display_name"
    values = ["Oracle-Linux-8*"]
    regex  = true
  }
}
