variable "tenancy_ocid" {
  type = string
}
variable "user_ocid" {
  type = string
}
variable "fingerprint" {
  type = string
}
variable "private_key_path" {
  type = string
}
variable "region" {
  type = string
}
variable "compartment_id" {
  description = "The OCID of the compartment in which to create resources"  
  type = string
}
variable "ssh_public_key" {
  type = string
}
variable "object_storage_namespace" {
  type = string
}
variable "backup_bucket_name" {
  description = "The name of the OCI Object Storage bucket used for automatic MySQL backups"
  type        = string
  default     = "laravel-backup-bucket"
}

