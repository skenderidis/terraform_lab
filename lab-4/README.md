# Lab - 4
In this lab we have 2 exercises:
- [Exercise 4.1 - LTM module](#exercise-41---ltm-module)
- [Exercise 4.2 - AWS VPC custom module](#exercise-42---aws-module)

## Exercise 4.1 - LTM module

1. Change the working directory to `~/terraform_lab/lab-4/f5`

    ```
    cd ~/terraform_lab/lab-4/f5
    ```

1. Verify that the module ltm exists 
    ```
    $ tree
    
    ************ Output ****************
    .
    ├── ltm               <---  Module ltm
    │   └── vs_ltm.tf     
    ├── main.tf
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
      address  = "x.x.x.x"
      username = "username"
      password = "password"
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


## Exercise 4.2 - AWS module

1. We have to create a new module for creating VPCs in AWS environment. To do that we need to create the folder (same name as the module) that will contain all the Terraform configuration files.
    ```
    mkdir aws-infra
    ```
1. Create a new terraform file `aws.tf` under the child module directory (`aws-infra`)
    ```
    nano aws-infra/aws.tf
    ```

1. Copy & paste the configuration below 
    ```
    # variables
    variable region { }
    # VPC
    resource "aws_vpc" "main" {
      cidr_block                = "10.0.0.0/16"
      enable_dns_hostnames      = true
      enable_dns_support        = true  
      tags                      = { Name = "VPC-infra" }
    }
    # Subnet
    resource "aws_subnet" "my_subnet" {
      vpc_id            = aws_vpc.main.id
      cidr_block        = "10.0.0.0/24"
      availability_zone = "${var.region}a"
      tags              = { Name = "Subnet-1" }
    }
    ```
1. Edit the existing `main.tf` (or create a new terraform file `main-aws.tf` under the root module directory)
    ```
    nano main.tf
    ```

1. Copy & paste the configuration below at the end of the existing file. The configuration below includes the aws provider, the variable used (region) and the reference to the module `aws-infra`.
    ```
    variable region {
      default = "us-east-1"
    }
    provider aws {
      region = var.region
    }

    module "server" {
      source = "./aws-infra"
      region =  var.region
    }
    ```
1. Before applying the `terraform apply` command is it important that you setup the AWS Access Key and the AWS Secret as environment variables so that Terraform can authenticate with AWS API service.
    ```
    export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
    ```

1. We need to run the `terraform init` command so that Terraform can initialize the new module and the new AWS provider.
    ```
    $ terraform init

    ****************************   OUTPUT   ****************************
    Initializing modules...
    - server in aws-infra

    Initializing the backend...

    Initializing provider plugins...
    - Reusing previous version of f5networks/bigip from the dependency lock file
    - Finding latest version of hashicorp/aws...
    - Using previously-installed f5networks/bigip v1.13.0
    - Installing hashicorp/aws v4.9.0...
    - Installed hashicorp/aws v4.9.0 (signed by HashiCorp)

    Terraform has made some changes to the provider dependency selections recorded
    in the .terraform.lock.hcl file. Review those changes and commit them to your
    version control system if they represent changes you intended to make.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ***********************************************************************
    ```


1. Run the `terraform apply` command so that the resources get created in AWS.
    ```
    $ terraform apply --auto-approve

    ****************************   OUTPUT   ****************************
    module.virtual_server_01.bigip_ltm_virtual_server.http: Refreshing state... [id=/Common/Test]

    Note: Objects have changed outside of Terraform

    Terraform detected the following changes made outside of Terraform since the last "terraform apply":

      # module.virtual_server_01.bigip_ltm_virtual_server.http has changed
      ~ resource "bigip_ltm_virtual_server" "http" {
            id                         = "/Common/Test"
          + irules                     = []
            name                       = "/Common/Test"
          + policies                   = []
          + security_log_profiles      = []
          + vlans                      = []
            # (11 unchanged attributes hidden)
        }


    Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to these changes.

    ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      # module.server.aws_subnet.my_subnet will be created
      + resource "aws_subnet" "my_subnet" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-east-1a"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "10.0.0.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "Name" = "Subnet-1"
            }
          + tags_all                                       = {
              + "Name" = "Subnet-1"
            }
          + vpc_id                                         = (known after apply)
        }

      # module.server.aws_vpc.main will be created
      + resource "aws_vpc" "main" {
          + arn                                  = (known after apply)
          + cidr_block                           = "10.0.0.0/16"
          + default_network_acl_id               = (known after apply)
          + default_route_table_id               = (known after apply)
          + default_security_group_id            = (known after apply)
          + dhcp_options_id                      = (known after apply)
          + enable_classiclink                   = (known after apply)
          + enable_classiclink_dns_support       = (known after apply)
          + enable_dns_hostnames                 = true
          + enable_dns_support                   = true
          + id                                   = (known after apply)
          + instance_tenancy                     = "default"
          + ipv6_association_id                  = (known after apply)
          + ipv6_cidr_block                      = (known after apply)
          + ipv6_cidr_block_network_border_group = (known after apply)
          + main_route_table_id                  = (known after apply)
          + owner_id                             = (known after apply)
          + tags                                 = {
              + "Name" = "VPC-infra"
            }
          + tags_all                             = {
              + "Name" = "VPC-infra"
            }
        }

    Plan: 2 to add, 0 to change, 0 to destroy.
    module.server.aws_vpc.main: Creating...
    module.server.aws_vpc.main: Still creating... [10s elapsed]
    module.server.aws_vpc.main: Creation complete after 15s [id=vpc-0cf780f994f1d18b7]
    module.server.aws_subnet.my_subnet: Creating...
    module.server.aws_subnet.my_subnet: Creation complete after 1s [id=subnet-07e6bf1391d0533df]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    ***********************************************************************
    ```

1. Login AWS Dashboard and review that the new VPC/Subnet have been created.
