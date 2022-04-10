terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
    }
  }
}

variable vs_name {}
variable dest_ip {}
variable dest_port {}

resource "bigip_ltm_virtual_server" "http" {
  name        = "/Common/${var.vs_name}"
  destination = var.dest_ip
  port        = var.dest_port
}