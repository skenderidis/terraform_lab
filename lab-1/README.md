# Lab - 1
## Terraform installation

### Step 1 - Download Terraform
The first step is to identify the appropriate Terraform package for your system and download it as a zip archive.

wget https://releases.hashicorp.com/terraform/1.1.8/terraform_1.1.8_linux_386.zip

After downloading Terraform, unzip the package. Terraform runs as a single binary named terraform. Any other files in the package can be safely removed and Terraform will still function.

unzip terraform_1.1.8_linux_386.zip 


echo $PATH

verify /usr/local/bin 

Move the Terraform binary to one of the listed locations.

mv ~/terraform /usr/local/bin/

Verify that the installation worked by opening a new terminal session and listing Terraform's available subcommands.
terraform -help


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

'''
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

