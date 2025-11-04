resource "oci_core_virtual_network" "laravel_vcn" {
  compartment_id = var.compartment_id
  cidr_block     = "10.0.0.0/16"
  display_name   = "laravel-vcn"
  dns_label      = "laravelvcn"
}

resource "oci_core_internet_gateway" "laravel_igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.laravel_vcn.id
  display_name   = "laravel-internet-gateway"
}

resource "oci_core_route_table" "laravel_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.laravel_vcn.id

  route_rules {
    network_entity_id = oci_core_internet_gateway.laravel_igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# ✅ SECURITY LIST (block syntax)
resource "oci_core_security_list" "laravel_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.laravel_vcn.id
  display_name   = "laravel-security-list"

  # SSH
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Kubernetes API (port 6443)
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # ICMP external
  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "0.0.0.0/0"

    icmp_options {
      type = 3
      code = 4
    }
  }

  # ICMP internal
  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "10.0.0.0/16"

    icmp_options {
      type = 3
    }
  }

  # Egress
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# ✅ Public subnet
resource "oci_core_subnet" "laravel_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_virtual_network.laravel_vcn.id
  cidr_block                 = "10.0.1.0/24"
  display_name               = "laravel-subnet"
  route_table_id             = oci_core_route_table.laravel_rt.id
  dns_label                  = "laravel"
  prohibit_public_ip_on_vnic = false
  security_list_ids          = [oci_core_security_list.laravel_security_list.id]
}

# ✅ Worker nodes subnet (separate from service/LB subnet)
resource "oci_core_subnet" "laravel_nodes_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_virtual_network.laravel_vcn.id
  cidr_block                 = "10.0.2.0/24"
  display_name               = "laravel-nodes-subnet"
  route_table_id             = oci_core_route_table.laravel_rt.id
  dns_label                  = "nodesub"
  prohibit_public_ip_on_vnic = false
  security_list_ids          = [oci_core_security_list.laravel_security_list.id]
}

# ✅ Private subnet
resource "oci_core_subnet" "laravel_db_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_virtual_network.laravel_vcn.id
  display_name               = "laravel-db-subnet"
  cidr_block                 = "10.0.3.0/24"
  dns_label                  = "dbsub"
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [oci_core_security_list.laravel_security_list.id]
}
