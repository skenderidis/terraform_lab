# Lab - 1

## Exercise 1 - For_each command

Change the working directory to `~/terraform_lab/lab-2`

```
cd ~/terraform_lab/lab-2
```

Verify that main.tf exists and review the contents

```
$ more main.tf 

**********      OUTPUT      *************
resource "local_file" "pass_each" { 
  for_each = {
    file1 = "this is file 1"
    file2 = "this is file 2"
  }
  filename = "/var/tmp/each_${each.key}.txt"
  content = each.value
}
**************** END *********************
```

Run the `terraform init` command to initialize a working directory containing Terraform configuration files. 

```
$ terraform init
```
Verify the output.
```
****************************   OUTPUT   ****************************
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

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

****************************   END   ****************************
```


Run the `terraform apply` command.

```
$ terraform apply

```

Verify the output.
```
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
***********************************************************************

```


The files should have now been created. Run the following command to verify that the 2 files exists and that they the correct contents

```
ls -l /var/tmp/
more /var/tmp/.....txt
```


## Section 3 - Manage infrastrucutre

Now that the file has been created we will update the file terraform script and observe the behavior of Terraform. 
Before we do that lets review the provider and attributes of the State File that has been created by Terraform. 

```
$ more ~/terraform_lab/lab-1/terraform.tfstate

****************************   OUTPUT   ****************************
{
  "version": 4,
  "terraform_version": "1.1.8",
  "serial": 4,
  "lineage": "a0c4d20e-15b2-3634-e887-0d2197d82db0",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "local_file",
      "name": "pass",
      "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "content": "123456",
            "content_base64": null,
            "directory_permission": "0777",
            "file_permission": "0777",
            "filename": "/var/tmp/passwords.txt",
            "id": "7c4a8d09ca3762af61e59520943dc26494f8941b",
            "sensitive_content": null,
            "source": null
          },
          "sensitive_attributes": [],
          "private": "bnVsbA=="
        }
      ]
    }
  ]
}
********************************************************************
```

Let's now change the contents of the file that we have created through the terraform script. 

```
nano main.tf
```

Change `content = "123456"` to `content = "New Value"`, save the file and run `terraform apply' again.

```
$ terraform apply

****************************   OUTPUT   ****************************
local_file.pass: Refreshing state... [id=7c4a8d09ca3762af61e59520943dc26494f8941b]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # local_file.pass must be replaced
-/+ resource "local_file" "pass" {
      ~ content              = "123456" -> " New Value" # forces replacement
      ~ id                   = "7c4a8d09ca3762af61e59520943dc26494f8941b" -> (known after apply)
        # (3 unchanged attributes hidden)
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

local_file.pass: Destroying... [id=7c4a8d09ca3762af61e59520943dc26494f8941b]
local_file.pass: Destruction complete after 0s
local_file.pass: Creating...
local_file.pass: Creation complete after 0s [id=767bc16967f0909bac7cb717777656f68dcba552]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
**********************************************************************
```

The file should have now been modified. Run the following command to verify that the file contents have changed
```
$ more /var/tmp/passwords.txt

****** Output ********
 New Value
**********************
```

Run the `terraform state list` command to list all resources in the state file.
```
$ terraform state list

****** Output ********
local_file.pass
**********************
```

Run the `terraform state show` command to show the attributes of a single resource in the Terraform state.

```
$ terraform state show local_file.pass

****** Output ********
# local_file.pass:
resource "local_file" "pass" {
    content              = " New Value"
    directory_permission = "0777"
    file_permission      = "0777"
    filename             = "/var/tmp/passwords.txt"
    id                   = "767bc16967f0909bac7cb717777656f68dcba552"
}
**********************
```


Run the `terraform  show` command to provide human-readable output from all resources in the state. The output should be identical to the previous command as we only have 1 resource in the state file

```
$ terraform show
```

Run the `terraform version` command to display the current version of Terraform and all installed plugins.
```
$ terraform version

****** Output ********
Terraform v1.1.8
on linux_386
+ provider registry.terraform.io/hashicorp/local v2.2.2
**********************
```



## Section 4 - Delete infrastrucutre

Now let's delete the file that has been created. Run the `terraform destroy` command to remove all infratructure that has been created through this terraform script.


```
$ terraform destroy

****************************   OUTPUT   ****************************
local_file.pass: Refreshing state... [id=767bc16967f0909bac7cb717777656f68dcba552]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # local_file.pass will be destroyed
  - resource "local_file" "pass" {
      - content              = " New Value" -> null
      - directory_permission = "0777" -> null
      - file_permission      = "0777" -> null
      - filename             = "/var/tmp/passwords.txt" -> null
      - id                   = "767bc16967f0909bac7cb717777656f68dcba552" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

local_file.pass: Destroying... [id=767bc16967f0909bac7cb717777656f68dcba552]
local_file.pass: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
******************************************************************
```
