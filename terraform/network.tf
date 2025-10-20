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

resource "oci_core_subnet" "laravel_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_virtual_network.laravel_vcn.id
  cidr_block        = "10.0.1.0/24"
  display_name      = "laravel-subnet"
  route_table_id    = oci_core_route_table.laravel_rt.id
  dns_label         = "laravel"
  prohibit_public_ip_on_vnic = false
}
