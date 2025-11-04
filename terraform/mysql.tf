# Create OCI MySQL DB System (managed MySQL)
resource "oci_mysql_mysql_db_system" "laravel_db" {
  compartment_id          = var.compartment_id
  display_name            = "laravel-mysql"
  mysql_version           = "8.4.6"
  shape_name              = var.mysql_shape
  subnet_id               = oci_core_subnet.laravel_db_subnet.id
  admin_username          = "admin"
  admin_password          = random_password.mysql_admin.result
  data_storage_size_in_gb = var.mysql_storage_gb
  availability_domain     = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

# Output DB connection details
output "mysql_admin_password" {
  value       = random_password.mysql_admin.result
  description = "Temporary admin password for the managed MySQL (store this somewhere secure)."
  sensitive   = true
}

output "mysql_endpoint" {
  value       = oci_mysql_mysql_db_system.laravel_db.ip_address # or use .hostname if available
  description = "DB host (use this in your Laravel APP config)."
}
