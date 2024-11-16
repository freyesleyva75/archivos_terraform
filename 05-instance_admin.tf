### ADMINISTRATOR SERVER ###
resource "openstack_compute_instance_v2" "admin_server" {
  name            = var.instance_names[1]
  image_name      = var.image
  flavor_name     = var.flavor
  security_groups = var.security_groups

  # Conexion a Net1 y Net2
  network {
    uuid = openstack_networking_network_v2.net1.id
  }
  network {
    uuid = openstack_networking_network_v2.net2.id
  }
     user_data = file("cloud-init-admin.yaml")
}

#Configuracion del acceso externo del servidor de administracion
resource "openstack_networking_floatingip_v2" "admin_floating_ip" {
  pool = var.external_network_name
}

#Asociar la IP flotante a admin_server
resource "openstack_compute_floatingip_associate_v2" "admin_floating_ip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.admin_floating_ip.address
  instance_id = openstack_compute_instance_v2.admin_server.id
}