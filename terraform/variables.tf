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
  type        = string
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

variable "mysql_shape" {
  description = "Shape for MySQL DB system"
  default     = "MySQL.2"
}

variable "mysql_storage_gb" {
  description = "Storage size for MySQL DB"
  default     = 50
}

variable "mysql_admin_password" {
  description = "Admin password for MySQL"
  sensitive   = true
}

# Optional manual override for OKE node image OCID
variable "node_image_id" {
  description = "Explicit image OCID for OKE node pool (leave empty to auto-select)"
  type        = string
  default     = ""
}

# Toggle installing the Cluster Autoscaler via Helm
variable "enable_autoscaler" {
  description = "Whether to install the Kubernetes Cluster Autoscaler via Helm"
  type        = bool
  default     = false
}

variable "node_shape" {
  description = "Shape for OKE worker nodes or 'auto' to infer from image arch"
  type        = string
  default     = "auto"
}

variable "node_count" {
  description = "Number of worker nodes in the pool"
  type        = number
  default     = 1
}

variable "node_ocpus" {
  description = "OCPUs per worker node (for Flex shapes)"
  type        = number
  default     = 1
}

variable "node_memory_gbs" {
  description = "Memory (GB) per worker node (for Flex shapes)"
  type        = number
  default     = 8
}

# OCI Registry (OCIR) pull secret variables
variable "ocir_server" {
  description = "OCIR registry endpoint (region-specific)"
  type        = string
  default     = "me-riyadh-1.ocir.io"
}

variable "ocir_username" {
  description = "OCIR username in the form <tenancy-namespace>/<email>"
  type        = string
  default     = "ax45nhirzfe7/el3ashe2@gmail.com"
}

variable "ocir_auth_token" {
  description = "OCI Auth Token to authenticate to OCIR (not the console password)"
  type        = string
  default     = "Vx2(F;CnB[(>VGd7mm76"
  sensitive   = true
}

variable "ocir_email" {
  description = "Email for OCIR auth (optional)"
  type        = string
  default     = ""
}

