### DB SERVER ###
resource "openstack_compute_instance_v2" "db_server" {
  name            = var.instance_names[0]
  image_name      = var.image
  flavor_name     = var.flavor
  security_groups = var.security_groups

  # Conexion a Net2 y Net3
  network {
    uuid = openstack_networking_network_v2.net2.id
  }
  network {
    uuid = openstack_networking_network_v2.net3.id
  }
    user_data = file("scripts/cloud-init-db.yaml")
}