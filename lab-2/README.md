# Lab - 2

## Exercise 2.1 - For_each meta-argument

1. Change the working directory to `~/terraform_lab/lab-2`

    ```
    cd ~/terraform_lab/lab-2
    ```

1. Verify that main.tf exists and review the contents

    ```
    more main.tf 
    ```

1. Review file contents

    ```
    resource "local_file" "pass_each" { 
    for_each = {
      file1 = "this is file 1"
      file2 = "this is file 2"
    }
    filename = "/var/tmp/each_${each.key}.txt"
    content = each.value
    }
    ```

1. Run the `terraform init` command to initialize a working directory containing Terraform configuration files. 

    ```
    terraform init
    ```

1. Run the `terraform apply` command.

    ```
    $ terraform apply

    ****************************   OUTPUT   ****************************
$ terraform apply --auto-approve

    Terraform used the selected providers to generate the following execution plan. 
    Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      # local_file.pass_each["file1"] will be created
      + resource "local_file" "pass_each" {
          + content              = "this is file 1"
          + directory_permission = "0777"
          + file_permission      = "0777"
          + filename             = "/var/tmp/each_file1.txt"
          + id                   = (known after apply)
        }

      # local_file.pass_each["file2"] will be created
      + resource "local_file" "pass_each" {
          + content              = "this is file 2"
          + directory_permission = "0777"
          + file_permission      = "0777"
          + filename             = "/var/tmp/each_file2.txt"
          + id                   = (known after apply)
        }

    Plan: 2 to add, 0 to change, 0 to destroy.
 
    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

      Enter a value: yes

    local_file.pass_each["file2"]: Creating...
    local_file.pass_each["file1"]: Creating...
    local_file.pass_each["file2"]: Creation complete after 0s [id=4b12046facfee0eca1fa3d1910c4c5baad3e660f]
    local_file.pass_each["file1"]: Creation complete after 0s [id=c6e077a4ccaf1a7f3a709f164f6973afa86b168b]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    ***********************************************************************
```


1. The files should have now been created. Run the following command to verify that the 2 files exists and that they the correct contents

    ```
    $ ls -l /var/tmp/
    
    ************ Output ************
    -rwxrwxr-x 1 ubuntu ubuntu   14 Apr 10 18:51 each_file1.txt
    -rwxrwxr-x 1 ubuntu ubuntu   14 Apr 10 18:51 each_file2.txt
    ********************************
    
    $ more /var/tmp/each_file1.txt
    ************ Output ************
    this is file 1
    ********************************

    $ more /var/tmp/each_file2.txt
    ************ Output ************
    this is file 2
    ********************************
    ```

1. Now let's delete the file that has been created. Run the `terraform destroy` command to remove all infratructure that has been created through this terraform script.

    ```
    terraform destroy
    ~~ strike ~~
    ```
    ~~ strike ~~
## Exercise 2.2 - Count meta-argument

1. Now that the file has been created we will update the file terraform script and observe the behavior of Terraform. 
Before we do that lets review the provider and attributes of the State File that has been created by Terraform. 

```
$ more ~/terraform_lab/lab-1/terraform.tfstate

resource "local_file" "pass_count" { 
  count = 2
  filename = "/var/tmp/count_${count.index}.txt"
  content = "this is file ${count.index}"
}

********************************************************************
```
