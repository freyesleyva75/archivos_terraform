
### CONFIGURACIÓN DE LOS GRUPOS DE SEGURIDAD ###

# Grupo de seguridad 1 para permitir tráfico TCP
resource "openstack_networking_secgroup_v2" "my_security_group" {
  name                 = "open"
  description          = "Grupo de Seguridad para permitir todo el trafico TCP"
  delete_default_rules = true
}

# Regla para permitir el tráfico TCP entrante
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = var.ip_default
  security_group_id = openstack_networking_secgroup_v2.my_security_group.id
}

# Regla para permitir el trafico TCP saliente
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_engress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = var.ip_default
  security_group_id = openstack_networking_secgroup_v2.my_security_group.id
}

### GRUPO DE SEGURIDAD PARA DEPURACION Y TESTING ###

# Creacion del grupo de serguridad 2 para permitir tráfico ICMP
resource "openstack_networking_secgroup_v2" "my_security_group_1" {
  name                 = "open_1"
  description          = "Grupo de Seguridad para permitir todo el trafico ICMP"
  delete_default_rules = true
}

# Regla para permitir el tráfico ICMP entrante
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_ingress_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.ip_default
  security_group_id = openstack_networking_secgroup_v2.my_security_group_1.id
}

# Regla para permitir el tráfico ICMP saliente
resource "openstack_networking_secgroup_rule_v2" "security_group_rule_engress_1" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.ip_default
  security_group_id = openstack_networking_secgroup_v2.my_security_group_1.id
}