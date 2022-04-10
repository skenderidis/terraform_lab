# Lab - 1

## Exercise 1 - For_each command

1. Change the working directory to `~/terraform_lab/lab-4`

    ```
    cd ~/terraform_lab/lab-4
    ```

1. Verify that the module ltm exists 
    ```
    $ tree
    
    ************ Output ****************
    .
    ├── ltm               <---  Module ltm
    │   └── vs_ltm.tf     
    ├── main.tf
    ├── README.md
    *************************************
    ```

1. Review `ltm/vs_ltm.tf` file under ltm module and verify it contains the **bigip_ltm_virtual_server** resource that creates an F5 virtual server based on 3 variables; `vs_name`, `dest_ip` and `dest_port`. 
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

1. The BIGIP provider is configured on the Root module which calls the ltm module to create the appropriate resources. The BIGIP provider configuration is inherited by the module.

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

1. Run `terraform init` command to initialize the Root working directory containing Terraform configuration files. 

    ```
    $ terraform init
    ```

1. Run the `terraform apply` command so that the resources gets created. Insert ***--auto-approve*** so that you don't have to confirm the proposed plan

    ```
    $ terraform apply
    ```
    
1. Login to F5 to see that the Virtual Server has been created <a href="https://192.168.3.103/">https://192.168.3.103</a> .
