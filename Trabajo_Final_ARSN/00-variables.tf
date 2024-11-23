# Variable para el nombre de la red externa
variable "external_network_name" {
  default = "ExtNet"
}

variable "network_1" {
  type    = string
  default = "Net1"
}

variable "network_2" {
  type    = string
  default = "Net2"
}

variable "network_3" {
  type    = string
  default = "Net3"
}

variable "subnet_1" {
  type = map(string)
  default = {
    subnet_name = "Subnet1"
    cidr        = "10.0.1.0/24"
  }
}

variable "subnet_2" {
  type = map(string)
  default = {
    subnet_name = "Subnet2"
    cidr        = "10.0.2.0/24"
  }
}

variable "subnet_3" {
  type = map(string)
  default = {
    subnet_name = "Subnet3"
    cidr        = "10.0.3.0/24"
    gateway_ip = "10.0.3.1"
  }
}

variable "dns_ip" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.8.4"]
}

variable "image" {
  type    = string
  default = "jammy-server-cloudimg-amd64-vnx"
}

variable "flavor" {
  type    = string
  default = "m1.smaller"
}

variable "security_groups" {
  type    = list(string)
  default = ["open", "open_1"]
}

variable "admin" {
  type    = string
  default = "admin-server"
}

variable "instance_names" {
  type = list(string)
  default = [ "db-server", "admin-server"]
}

variable "ip_default" {
    type = string
    default = "0.0.0.0/0"
}

variable "enable_ssh" {
  type = bool
  default = true
}

variable "admin_source_ip" {
    type = string
    default = "0.0.0.0/0"
}