env {
  name  = "DB_HOST"
  value = oci_mysql_db_system.laravel_db.hostname
}

env {
  name  = "DB_USERNAME"
  value = "admin"
}

env {
  name  = "DB_PASSWORD"
  value = random_password.mysql_admin.result
}
