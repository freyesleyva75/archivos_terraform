#Configuracion del balanceador de carga
resource "openstack_lb_loadbalancer_v2" "http" {
  name          = "web-loadbalancer"
  vip_subnet_id = openstack_networking_subnet_v2.subnet1.id
  depends_on    = [openstack_compute_instance_v2.web_server]
}

resource "openstack_lb_listener_v2" "http" {
  name            = "web-listener"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.http.id
  depends_on      = [openstack_lb_loadbalancer_v2.http]
}

resource "openstack_lb_pool_v2" "http" {
  name        = "web-pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.http.id
  depends_on  = [openstack_lb_listener_v2.http]
}

resource "openstack_lb_member_v2" "http" {
  count         = 3
  pool_id       = openstack_lb_pool_v2.http.id
  address       = element([for i in openstack_compute_instance_v2.web_server: i.access_ip_v4], count.index)
  protocol_port = 80
  subnet_id     = openstack_networking_subnet_v2.subnet1.id
  depends_on    = [openstack_lb_pool_v2.http]
}

### (ADICIONAL) ###
# Creación de monitor para verificar el estado de las instancias 
resource "openstack_lb_monitor_v2" "http" {
  name        = "monitor_http"
  pool_id     = openstack_lb_pool_v2.http.id
  type        = "TCP"
  delay       = 2
  timeout     = 2
  max_retries = 2
  depends_on  = [openstack_lb_member_v2.http]
}

#Configuracion del acceso externo del balanceador de carga
resource "openstack_networking_floatingip_v2" "loadbalancer_floating_ip" {
  pool       = var.external_network_name
  depends_on = [openstack_lb_loadbalancer_v2.http]
}

#Asociar la IP flotante al balanceador de carga
resource "openstack_networking_floatingip_associate_v2" "lb_floating_ip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.loadbalancer_floating_ip.address
  port_id     = openstack_lb_loadbalancer_v2.http.vip_port_id
  depends_on = [openstack_lb_loadbalancer_v2.http]
}