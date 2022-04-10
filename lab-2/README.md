# Lab - 2
In this Lab we have 2 exercises:
- [Exercise 2.1 - For_each meta-argument](#exercise-21---for_each-meta-argument)
- [Exercise 2.2 - Count meta-argument](#exercise-22---count-meta-argument)


## Exercise 2.1 - For_each meta-argument

1. Change the working directory to `~/terraform_lab/lab-2`

    ```
    cd ~/terraform_lab/lab-2
    ```

1. Verify that for-each.tf exists

    ```
    more for-each.tf 
    ```

1. Review the contents of the `for-each.tf` file

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

1. Run the `terraform init` command to initialize the working directory.

    ```
    terraform init
    ```

1. Run the `terraform apply` command so that the resources get created.

    ```
    $ terraform apply

    ****************************   OUTPUT   ****************************
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


1. The files should have now been created. Run the following command to verify that the 2 files exist and they have the correct contents

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

## Exercise 2.2 - Count meta-argument

1. Create a new terraform file `count.tf` 
    ```
    nano count.tf
    ```

1. Copy & paste the configuration below 
    ```
    resource "local_file" "pass_count" { 
      count = 2
      filename = "/var/tmp/count_${count.index}.txt"
      content = "this is file ${count.index}"
    }
    ```    
1. Save the `count.tf` file and the `terraform apply` command so that the resources get created.
    ```
    $ terraform apply

    ****************************   OUTPUT   ****************************
    local_file.pass_each["file2"]: Refreshing state... [id=4b12046facfee0eca1fa3d1910c4c5baad3e660f]
    local_file.pass_each["file1"]: Refreshing state... [id=c6e077a4ccaf1a7f3a709f164f6973afa86b168b]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      # local_file.pass_count[0] will be created
      + resource "local_file" "pass_count" {
          + content              = "this is file 0"
          + directory_permission = "0777"
          + file_permission      = "0777"
          + filename             = "/var/tmp/count_0.txt"
          + id                   = (known after apply)
        }

      # local_file.pass_count[1] will be created
      + resource "local_file" "pass_count" {
          + content              = "this is file 1"
          + directory_permission = "0777"
          + file_permission      = "0777"
          + filename             = "/var/tmp/count_1.txt"
          + id                   = (known after apply)
        }

    Plan: 2 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

      Enter a value: yes

    local_file.pass_count[0]: Creating...
    local_file.pass_count[1]: Creating...
    local_file.pass_count[0]: Creation complete after 0s [id=3c1e00e0c66b4698c15df1ea3613a762a967be92]
    local_file.pass_count[1]: Creation complete after 0s [id=c6e077a4ccaf1a7f3a709f164f6973afa86b168b]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    ***********************************************************************
    ```


1. The files should have now been created. Run the following command to verify that the 2 new and the 2 old files (from the previous exercise) exist and they have the correct contents

    ```
    $ ls -l /var/tmp/
    
    ************ Output ************
    -rwxrwxr-x 1 ubuntu ubuntu   14 Apr 10 19:21 count_0.txt
    -rwxrwxr-x 1 ubuntu ubuntu   14 Apr 10 19:21 count_1.txt
    -rwxrwxr-x 1 ubuntu ubuntu   14 Apr 10 18:51 each_file1.txt
    -rwxrwxr-x 1 ubuntu ubuntu   14 Apr 10 18:51 each_file2.txt    
    ********************************
    
    $ more /var/tmp/count_0.txt
    ************ Output ************
    this is file 0
    ********************************

    $ more /var/tmp/count_1.txt
    ************ Output ************
    this is file 1
    ********************************
    ```

1. Now let's delete the file that has been created. Run the `terraform destroy` command to remove all infratructure that has been created through the terraform scripts.

    ```
    $ terraform destroy

    ****************************   OUTPUT   ****************************
    local_file.pass_count[1]: Refreshing state... [id=c6e077a4ccaf1a7f3a709f164f6973afa86b168b]
    local_file.pass_each["file2"]: Refreshing state... [id=4b12046facfee0eca1fa3d1910c4c5baad3e660f]
    local_file.pass_count[0]: Refreshing state... [id=3c1e00e0c66b4698c15df1ea3613a762a967be92]
    local_file.pass_each["file1"]: Refreshing state... [id=c6e077a4ccaf1a7f3a709f164f6973afa86b168b]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      - destroy

    Terraform will perform the following actions:

      # local_file.pass_count[0] will be destroyed
      - resource "local_file" "pass_count" {
          - content              = "this is file 0" -> null
          - directory_permission = "0777" -> null
          - file_permission      = "0777" -> null
          - filename             = "/var/tmp/count_0.txt" -> null
          - id                   = "3c1e00e0c66b4698c15df1ea3613a762a967be92" -> null
        }

      # local_file.pass_count[1] will be destroyed
      - resource "local_file" "pass_count" {
          - content              = "this is file 1" -> null
          - directory_permission = "0777" -> null
          - file_permission      = "0777" -> null
          - filename             = "/var/tmp/count_1.txt" -> null
          - id                   = "c6e077a4ccaf1a7f3a709f164f6973afa86b168b" -> null
        }

      # local_file.pass_each["file1"] will be destroyed
      - resource "local_file" "pass_each" {
          - content              = "this is file 1" -> null
          - directory_permission = "0777" -> null
          - file_permission      = "0777" -> null
          - filename             = "/var/tmp/each_file1.txt" -> null
          - id                   = "c6e077a4ccaf1a7f3a709f164f6973afa86b168b" -> null
        }

      # local_file.pass_each["file2"] will be destroyed
      - resource "local_file" "pass_each" {
          - content              = "this is file 2" -> null
          - directory_permission = "0777" -> null
          - file_permission      = "0777" -> null
          - filename             = "/var/tmp/each_file2.txt" -> null
          - id                   = "4b12046facfee0eca1fa3d1910c4c5baad3e660f" -> null
        }

    Plan: 0 to add, 0 to change, 4 to destroy.

    Do you really want to destroy all resources?
      Terraform will destroy all your managed infrastructure, as shown above.
      There is no undo. Only 'yes' will be accepted to confirm.

      Enter a value: yes

    local_file.pass_count[0]: Destroying... [id=3c1e00e0c66b4698c15df1ea3613a762a967be92]
    local_file.pass_count[1]: Destroying... [id=c6e077a4ccaf1a7f3a709f164f6973afa86b168b]
    local_file.pass_each["file2"]: Destroying... [id=4b12046facfee0eca1fa3d1910c4c5baad3e660f]
    local_file.pass_count[1]: Destruction complete after 0s
    local_file.pass_each["file1"]: Destroying... [id=c6e077a4ccaf1a7f3a709f164f6973afa86b168b]
    local_file.pass_count[0]: Destruction complete after 0s
    local_file.pass_each["file1"]: Destruction complete after 0s
    local_file.pass_each["file2"]: Destruction complete after 0s

    Destroy complete! Resources: 4 destroyed.
    ***********************************************************************
    ```