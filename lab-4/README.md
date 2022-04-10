# Lab - 1

## Exercise 1 - For_each command

Change the working directory to `~/terraform_lab/lab-4`

```
cd ~/terraform_lab/lab-4
```

Verify that the module ltm exists and review the file called `vs_ltm.tf` inside the module

```
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
```

ltm module contains the `bigip_ltm_virtual_server` resource that creates an F5 virtual server based on 3 variables; `vs_name`, `dest_ip` and `dest_port`

The root module defines the bigip providers and calls the ltm module to create the appropriate resources.

```
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
}
```

