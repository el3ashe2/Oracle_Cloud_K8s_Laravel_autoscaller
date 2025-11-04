# ==============================
# OKE Cluster Configuration
# ==============================

resource "oci_containerengine_cluster" "laravel_cluster" {
  name               = "laravel-cluster"
  compartment_id     = var.compartment_id
  vcn_id             = oci_core_virtual_network.laravel_vcn.id
  kubernetes_version = data.oci_containerengine_cluster_option.cluster_options.kubernetes_versions[0]
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

  lifecycle {
    ignore_changes = [
      kubernetes_version
    ]
  }
}

# ==============================
# Data Sources
# ==============================

# Get supported cluster options (Kubernetes versions)
data "oci_containerengine_cluster_option" "cluster_options" {
  cluster_option_id = "all"
}

# Get Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Get Available Node Pool Options
data "oci_containerengine_node_pool_option" "oke_options" {
  # Query options specific to this cluster to ensure compatible images are returned
  node_pool_option_id = oci_containerengine_cluster.laravel_cluster.id
}

# Fallback: global options ("all") if cluster-specific API doesn't return images
data "oci_containerengine_node_pool_option" "oke_options_all" {
  node_pool_option_id = "all"
}

# Pick a compatible image from node pool options (image-type sources)
locals {
  oke_image_sources = [for s in data.oci_containerengine_node_pool_option.oke_options.sources : s if s.source_type == "image"]
  oke_image_sources_all = [for s in data.oci_containerengine_node_pool_option.oke_options_all.sources : s if s.source_type == "image"]
  selected_image_source = length(local.oke_image_sources) > 0 ? local.oke_image_sources[0] : (length(local.oke_image_sources_all) > 0 ? local.oke_image_sources_all[0] : null)
  selected_is_arm       = local.selected_image_source == null ? false : can(regex("aarch64", local.selected_image_source.source_name))
  effective_node_shape  = var.node_shape != "auto" ? var.node_shape : (local.selected_is_arm ? "VM.Standard.A1.Flex" : "VM.Standard.E4.Flex")
}


# Get latest Oracle Linux 9 OKE image (preferred for newer OKE versions)
data "oci_core_images" "oke_ol9" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"

  filter {
    name   = "display_name"
    values = ["Oracle-Linux-9-*-OKE-*"]
    regex  = true
  }
}

# Fallback: Oracle Linux 8 OKE image
data "oci_core_images" "oke_ol8" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"

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
  node_shape         = local.effective_node_shape

  node_config_details {
    size = var.node_count
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.laravel_nodes_subnet.id
    }
    placement_configs {
      availability_domain = length(data.oci_identity_availability_domains.ads.availability_domains) > 1 ? data.oci_identity_availability_domains.ads.availability_domains[1].name : data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.laravel_nodes_subnet.id
    }
    placement_configs {
      availability_domain = length(data.oci_identity_availability_domains.ads.availability_domains) > 2 ? data.oci_identity_availability_domains.ads.availability_domains[2].name : data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.laravel_nodes_subnet.id
    }
  }

  node_shape_config {
    ocpus         = var.node_ocpus
    memory_in_gbs = var.node_memory_gbs
  }

  node_source_details {
    source_type = "image"
    image_id    = var.node_image_id != "" ? var.node_image_id : local.selected_image_source.image_id
  }

  lifecycle {
    precondition {
      condition     = (var.node_image_id != "") || (local.selected_image_source != null)
      error_message = "No compatible OKE node images found and no node_image_id override provided."
    }
  }

  depends_on = [oci_containerengine_cluster.laravel_cluster]
}
