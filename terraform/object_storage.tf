# Create an Object Storage bucket for backups
resource "oci_objectstorage_bucket" "backups" {
  compartment_id = var.compartment_id
  namespace      = var.object_storage_namespace
  name           = var.backup_bucket_name
  #public_access_type = "NoPublicAccess"
}
