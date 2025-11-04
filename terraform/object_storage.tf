# Create an Object Storage bucket for backups
data "oci_objectstorage_namespace" "ns" {}

resource "oci_objectstorage_bucket" "backups" {

  name           = var.backup_bucket_name
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  storage_tier   = "Standard"
  versioning     = "Enabled"
}
