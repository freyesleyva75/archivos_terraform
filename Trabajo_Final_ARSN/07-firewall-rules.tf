# Regla de firewall para el tráfico SSH hacia el server de administración
# resource "openstack_fw_rule_v2" "ssh_rule" {
#   name                   = "allow_ssh"
#   action                 = "allow"
#   protocol               = "tcp"
#   destination_port       = "2022"
#   source_ip_address = var.ip_default
#   destination_ip_address = openstack_compute_instance_v2.admin_server.network[0].fixed_ip_v4
#   depends_on             = [openstack_compute_instance_v2.admin_server]
# }

# Regla de firewall para el tráfico SSH hacia el server de administración

# Para habilitar la regla especificando una direccion ip de origen, ejecutar:
# terraform apply -var="admin_source_ip=192.168.1.100"

# Para deshabilitar la regla, ejecutar:
# terraform apply -var="enable_ssh=false" 
# Nota: No se podra acceder por ssh a la vm de ,
# Pues esta especificado el puerto 2022 en el fichero /etc/ssh/sshd_config

resource "openstack_fw_rule_v2" "ssh_rule" {
  count = var.enable_ssh ? 1 : 0

  name                   = "allow_ssh"
  action                 = "allow"
  protocol               = "tcp"
  destination_port       = "2022"
  source_ip_address      = var.admin_source_ip
  destination_ip_address = openstack_compute_instance_v2.admin_server.network[0].fixed_ip_v4
  depends_on             = [openstack_compute_instance_v2.admin_server]
}


# Regla de firewall para el tráfico HTTP entrante
resource "openstack_fw_rule_v2" "http_rule" {
  name                   = "allow_http"
  action                 = "allow"
  protocol               = "tcp"
  destination_port       = "80"
  source_ip_address      = var.ip_default
  destination_ip_address = openstack_lb_loadbalancer_v2.http.vip_address
  depends_on             = [openstack_lb_loadbalancer_v2.http]
}

# Regla de firewall para el tráfico saliente de la red Net1
resource "openstack_fw_rule_v2" "allow_internal" {
  name                   = "allow_internal"
  action                 = "allow"
  protocol               = "any"
  destination_ip_address = var.ip_default
  source_ip_address      = var.subnet_1["cidr"]
  depends_on             = [openstack_networking_subnet_v2.subnet1]
}

# Política para tráfico entrante
resource "openstack_fw_policy_v2" "policy_in" {
  name          = "firewall-policy-in"
  rules         = [openstack_fw_rule_v2.ssh_rule.id, openstack_fw_rule_v2.http_rule.id]
  depends_on    = [openstack_fw_rule_v2.ssh_rule, openstack_fw_rule_v2.http_rule]
}

# Política para tráfico saliente
resource "openstack_fw_policy_v2" "policy_out" {
  name        = "firewall-policy-out"
  rules       = [openstack_fw_rule_v2.allow_internal.id]
  depends_on  = [openstack_fw_rule_v2.allow_internal]
}

# Firewall grupo de asociacion de politicas y puerto de conexión con Net1
resource "openstack_fw_group_v2" "firewall_group" {
  name                       = "firewall-group"
  ingress_firewall_policy_id = openstack_fw_policy_v2.policy_in.id
  egress_firewall_policy_id  = openstack_fw_policy_v2.policy_out.id
  ports                      = [openstack_networking_port_v2.net1_port.id]
  depends_on                 = [openstack_fw_policy_v2.policy_in,
                                openstack_fw_policy_v2.policy_out,
                                openstack_networking_port_v2.net1_port]
}