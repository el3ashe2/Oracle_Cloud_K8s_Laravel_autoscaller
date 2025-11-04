resource "oci_kms_vault" "laravel_vault" {
  compartment_id = var.compartment_id
  display_name   = "laravel-vault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "laravel_key" {
  compartment_id      = var.compartment_id
  display_name        = "laravel-key"
  management_endpoint = oci_kms_vault.laravel_vault.management_endpoint
  key_shape {
    algorithm = "AES"
    length    = 32
  }
}

resource "random_password" "mysql_admin" {
  length  = 16
  special = true
}

resource "oci_vault_secret" "db_password" {
  compartment_id = var.compartment_id
  vault_id       = oci_kms_vault.laravel_vault.id
  key_id         = oci_kms_key.laravel_key.id
  secret_content {
    content_type = "BASE64"
    content      = base64encode(random_password.mysql_admin.result)
  }
  description = "Laravel MySQL admin password"
  secret_name = "laravel-db-password"
}

output "db_password_secret_id" {
  value = oci_vault_secret.db_password.id
}
