terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 7.22.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "oci" {
  config_file_profile = "DEFAULT"
  # provider will read ~/.oci/config by default; remove explicit tenancy/user args to avoid schema changes
}

## The Kubernetes provider configuration is defined in k8s-provider.tf to depend on the created OKE cluster