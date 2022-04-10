# Lab - 1
## Terraform installation

The first step is to identify the appropriate Terraform package for your system and download it as a zip archive. In this lab we will be using an Ubuntu 20.04 system. Use the link below to download the Terraform package on the home directory. After downloading Terraform, unzip the package. Terraform runs as a single binary named terraform. Any other files in the package can be safely removed.


```
cd ~
wget https://releases.hashicorp.com/terraform/1.1.8/terraform_1.1.8_linux_386.zip
unzip terraform_1.1.8_linux_386.zip 
```

Verify that `/usr/local/bin` is part of your PATH before moving Terraform binary to the specified location

```
echo $PATH
mv ~/terraform /usr/local/bin/
```

Verify that the installation worked by running the `terraform -help` command that lists Terraform's available subcommands.
```
$ terraform -help

******************      OUTPUT      *******************
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  ...
  ...
  ...
  ...
************************ END *************************
```

## Run your first script

Change the working directory to `~/terraform_lab/lab-1`

```
cd ~/terraform_lab/lab-1
```

Verify that main.tf exists and review the contents

```
$ more main.tf 

**********      OUTPUT      *************
resource "local_file" "pass" { 
  filename = "/var/tmp/passwords.txt"
  content = 123456
}
**************** END *********************
```

Run the `terraform init` command to initialize a working directory containing Terraform configuration files. 

```
$ terraform init

****************************   OUTPUT   ****************************
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/local...              <--- Provider
- Installing hashicorp/local v2.2.2...                      <--- Provider verion
- Installed hashicorp/local v2.2.2 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

****************************   END   ****************************
```

Run the `terraform plan` command that will create an execution plan and let you preview the changes that Terraform plans to make to your infrastructure. 
Type 'yes' to when requested by Terraform

```
$ terraform plan

****************************   OUTPUT   ****************************
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.pass will be created
  + resource "local_file" "pass" {
      + content              = "123456"
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "/var/tmp/passwords.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
********************************************************************
```

Run the `terraform apply` command that executes the actions proposed in a Terraform plan.

```
$ terraform apply

****************************   OUTPUT   ****************************
Terraform used the selected providers to generate the following execution plan. 
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.pass will be created
  + resource "local_file" "pass" {
      + content              = "123456"
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "/var/tmp/passwords.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

local_file.pass: Creating...
local_file.pass: Creation complete after 0s [id=7c4a8d09ca3762af61e59520943dc26494f8941b]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```


The file should have now been created. Run the following command to verify that the file exists

```
ls -l /var/tmp/
```

