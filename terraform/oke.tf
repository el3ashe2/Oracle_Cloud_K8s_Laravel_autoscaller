# ==============================
# OKE Cluster Configuration
# ==============================

resource "oci_containerengine_cluster" "laravel_cluster" {
  name               = "laravel-cluster"
  compartment_id     = var.compartment_id
  vcn_id             = oci_core_virtual_network.laravel_vcn.id
  kubernetes_version = "v1.34.1" # One of the supported versions
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.laravel_subnet.id
  }

  options {
    service_lb_subnet_ids = [oci_core_subnet.laravel_subnet.id]
  }

  freeform_tags = {
    "Environment" = "Dev"
    "Project"     = "Laravel"
  }
}

# ==============================
# Data Sources
# ==============================

# Get Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Get Available Node Pool Options
data "oci_containerengine_node_pool_option" "oke_options" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_id
}

# Get latest Oracle Linux image for OKE node
data "oci_core_images" "oke_compatible" {
  compartment_id   = var.compartment_id
  operating_system = "Oracle Linux"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"

  filter {
    name   = "display_name"
    values = ["Oracle-Linux-8-*-OKE-*"]
    regex  = true
  }
}


# ==============================
# Node Pool Configuration
# ==============================
resource "oci_containerengine_node_pool" "laravel_nodes" {
  cluster_id         = oci_containerengine_cluster.laravel_cluster.id
  compartment_id     = var.compartment_id
  name               = "laravel-node-pool"
  kubernetes_version = oci_containerengine_cluster.laravel_cluster.kubernetes_version
  node_shape         = "VM.Standard.E4.Flex"

  node_config_details {
    size = 3
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.laravel_subnet.id
    }
  }

  node_shape_config {
    ocpus         = 2
    memory_in_gbs = 16
  }

  node_source_details {
    source_type = "image"
    image_id    = data.oci_core_images.oke_compatible.images[0].id
  }

  depends_on = [oci_containerengine_cluster.laravel_cluster]
}
