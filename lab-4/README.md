# Lab - 4
In this lab we have 2 exercises:
- [Exercise 4.1 - LTM module](#exercise-41---ltm-module)
- [Exercise 4.2 - AWS module (TODO)](#exercise-41---aws-module)

## Exercise 4.1 - LTM module

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

1. Run `terraform init` command to initialize the Root working directory. 

    ```
    $ terraform init

    ****************************   OUTPUT   ****************************
    Initializing modules...
    - virtual_server_01 in ltm    <== Initialed the modules

    Initializing the backend...

    Initializing provider plugins...
    - Reusing previous version of f5networks/bigip from the dependency lock file
    - Using previously-installed f5networks/bigip v1.13.0

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```
    ***Note: Terraform initialized the modueles also. Look at the output***


1. Run the `terraform apply` command so that the resources gets created. Insert ***--auto-approve*** so that you don't have to confirm the proposed plan

    ```
    $ terraform apply --auto-approve

    ****************************   OUTPUT   ****************************
    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      # module.virtual_server_01.bigip_ltm_virtual_server.http will be created
      + resource "bigip_ltm_virtual_server" "http" {
          + destination                    = "10.1.10.10"
          + fallback_persistence_profile   = (known after apply)
          + id                             = (known after apply)
          + ip_protocol                    = (known after apply)
          + mask                           = (known after apply)
          + name                           = "/Common/Test"
          + per_flow_request_access_policy = (known after apply)
          + port                           = 80
          + profiles                       = (known after apply)
          + snatpool                       = (known after apply)
          + source                         = (known after apply)
          + source_address_translation     = (known after apply)
          + state                          = "enabled"
          + translate_address              = (known after apply)
          + translate_port                 = (known after apply)
          + vlans_enabled                  = false
        }

    Plan: 1 to add, 0 to change, 0 to destroy.
    module.virtual_server_01.bigip_ltm_virtual_server.http: Creating...
    module.virtual_server_01.bigip_ltm_virtual_server.http: Creation complete after 2s [id=/Common/Test]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    ************************************************************************
    ```
    
1. Login to F5 to see that the Virtual Server has been created <a href="https://192.168.3.103/">https://192.168.3.103</a> .
