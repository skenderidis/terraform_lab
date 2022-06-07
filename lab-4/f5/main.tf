terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
    }
  }
}

provider "bigip" {
  address  = "192.168.3.103"
  username = "admin"
  password = "Kostas123"
}

variable name { default = "Test"}
variable ip { default = "10.1.10.10"}
variable port { default = 80}


module virtual_server_01 {
  source    = "./ltm" 
  vs_name   = var.name
  dest_ip   = var.ip
  dest_port = var.port
}

