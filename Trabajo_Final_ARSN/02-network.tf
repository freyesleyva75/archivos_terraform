### CONFIGURACION DE LA RED ###

# Creación de la red Net1
resource "openstack_networking_network_v2" "net1" {
  name = var.network_1
}

# Creación de la subred subnet1 correspondiente a Net1
resource "openstack_networking_subnet_v2" "subnet1" {
  name       = var.subnet_1["subnet_name"]
  network_id = openstack_networking_network_v2.net1.id
  cidr       = var.subnet_1["cidr"]
  ip_version = 4
  dns_nameservers = var.dns_ip
}

# Creación de la red Net2
resource "openstack_networking_network_v2" "net2" {
  name = var.network_2
}

# Creación de la subred subnet2 correspondiente a Net2
resource "openstack_networking_subnet_v2" "subnet2" {
  name       = var.subnet_2["subnet_name"]
  network_id = openstack_networking_network_v2.net2.id
  cidr       = var.subnet_2["cidr"]
  ip_version = 4
  dns_nameservers = var.dns_ip
 }

#Creacion del puerto que conecta el Firewall con Net1
resource "openstack_networking_port_v2" "net1_port" {
  name         = "net1_port"
  network_id   = openstack_networking_network_v2.net1.id
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet1.id
    ip_address = "10.0.1.1"
  }
  depends_on = [openstack_networking_network_v2.net1, openstack_networking_subnet_v2.subnet1]
}

### CONFIGURACION DE LA RED DE ACCESO DE DB_SERVER ###

# Creación de la red Net3
resource "openstack_networking_network_v2" "net3" {
  name = "Net3"
}

# Creación de la subred subnet3 correspondiente a Net3
resource "openstack_networking_subnet_v2" "subnet3" {
  name            = var.subnet_3["subnet_name"]
  network_id      = openstack_networking_network_v2.net3.id
  cidr            = var.subnet_3["cidr"]
  ip_version      = 4
  dns_nameservers = var.dns_ip
  gateway_ip      = var.subnet_3["gateway_ip"]
}

### CONFIGURACIÓN DE ROUTERS ###

### CONFIGURACIÓN DEL FIREWALL ###
data "openstack_networking_network_v2" "external_network" {
  name = var.external_network_name
}

#Creación del Firewall
resource "openstack_networking_router_v2" "firewall_rc" {
  name                = "firewall_rc"
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

# Configuración de las interfaces del Firewall
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.firewall_rc.id
  port_id   = openstack_networking_port_v2.net1_port.id
}

### CONFIGURACIÓN DEL ENLACE DEL DB SERVER A INTERNET ###

#Configuracion del router Backup
resource "openstack_networking_router_v2" "backup" {
  name                = "backup"
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

# Configuración de las interfaces del router Backup
resource "openstack_networking_router_interface_v2" "backup_interface" {
  router_id = openstack_networking_router_v2.backup.id
  subnet_id = openstack_networking_subnet_v2.subnet3.id
}