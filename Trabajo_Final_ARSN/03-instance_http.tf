### WEB SERVERS ###
resource "openstack_compute_instance_v2" "web_server" {
  count           = 3
  name            = "s${count.index + 1}"
  image_name      = var.image
  flavor_name     = var.flavor
  security_groups = var.security_groups
  depends_on = [openstack_networking_network_v2.net1, openstack_networking_network_v2.net2]

  # Conexion a Net1 y Net2
  network {
    name = var.network_1
  }
  network {
    name = var.network_2
  }
  # Configuración de cloud-init
  user_data = file("scripts/cloud-init-http.yaml")

  
}