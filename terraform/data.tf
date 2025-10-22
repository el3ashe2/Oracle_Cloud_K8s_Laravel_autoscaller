# Get list of availability domains in your tenancy
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Get the latest Oracle Linux image for worker nodes  
data "oci_core_images" "oracle_linux_latest" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  filter {
    name   = "display_name"
    values = ["^Oracle-Linux-.*-aarch64-.*"]
    regex  = true
  }
}

# Get object storage namespace
data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.compartment_id
}
