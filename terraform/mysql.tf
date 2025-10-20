# Generate random MySQL admin password
resource "random_password" "mysql_admin" {
  length  = 16
  special = true
}

# OCI MySQL Database System
resource "oci_mysql_db_system" "laravel_db" {
  compartment_id = var.compartment_id
  shape_name     = "MySQL.VM.Standard.E3.1.8GB"
  display_name   = "laravel-db"
  subnet_id      = oci_core_subnet.laravel_subnet.id

  admin_username = "admin"
  admin_password = random_password.mysql_admin.result

  data_storage_size_in_gb = 50
  availability_domain     = data.oci_identity_availability_domains.ads.availability_domains[0].name
}
