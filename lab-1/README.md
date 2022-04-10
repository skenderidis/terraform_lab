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

Verify that the installation worked by run the following command that lists Terraform's available subcommands.
```
terraform -help
```

You should see the following output

```
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
```

## First 

Go to working directory terraform_lab/lab-1 

cd ~/terraform_lab/lab-1

verify that main.tf exists and review the contents


Initialize the directory

terraform init


Review check that the contents of the main.tf

'''
resource "local_file" "pass" { 
  filename = "var/tmp/passwords.txt"
  content = 123456
}

'''


'''
terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Installing hashicorp/local v2.2.2...
- Installed hashicorp/local v2.2.2 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
'''


run terraform plan

terraform plan


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.pass will be created
  + resource "local_file" "pass" {
      + content              = "123456"
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "var/tmp/passwords.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
'''

run terraform apply

Type 'yes' to when requested by terraform

Review the output 
'''
local_file.pass: Creating...
local_file.pass: Creation complete after 0s [id=7c4a8d09ca3762af61e59520943dc26494f8941b]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
'''

