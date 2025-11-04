output "oke_cluster_id" {
  value = oci_containerengine_cluster.laravel_cluster.id
}

output "oke_cluster_endpoint" {
  value = oci_containerengine_cluster.laravel_cluster.endpoints[0].public_endpoint
}

output "mysql_admin_password_secret_id" {
  value       = oci_vault_secret.db_password.id
  description = "OCID of Vault secret storing MySQL admin password"
}

output "backup_bucket_name" {
  value = oci_objectstorage_bucket.backups.name
}


