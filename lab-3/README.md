# Lab - 3

In this lab we have 4 exercises:
- [Exercise 3.1 - Simple variables](#exercise-31---simple-variables)
- [Exercise 3.2 - Command line variables](#exercise-32---command-line-variables)
- [Exercise 3.3 - Environment variables](#exercise-33---environment-variables)
- [Exercise 3.4 - Variable precedence](#exercise-34---variable-precedence)


## Exercise 3.1 - Simple variables

1. Change the working directory to `~/terraform_lab/lab-3`

    ```
    cd ~/terraform_lab/lab-3
    ```

1. Verify that main.tf and variables.tf exists and review the contents

    
    ```
    $  more main.tf

    ********   OUTPUT   ********
    resource "local_file" "pass" { 
       filename = var.file_name
       content = var.file_content
    }
    *****************************


    $  more variables.tf

    ********   OUTPUT   ********
    variable "file_name" {
       type = string
       default = "/var/tmp/passwords.txt"
    }
    variable "file_content" {
       type = string
    }
    *****************************
    ```

    ***Note: The `file_content` variable doesn't have a default value***

1. Run `terraform init` command to initialize the working directory. 

    ```
    $ terraform init
    ```

1. Run the `terraform apply` command so that the resources get created. You will be asked to insert a value for the `file_content` variable that doesn't have a default value. Once inserted the script will continue as planned.
    ```
    var.file_content
        Enter a value: 
    ```


    ```
    $ terraform apply
    
    ****************************   OUTPUT   ****************************
    var.file_content
    Enter a value: this is a test value             <==== Insert the content you want to save to the file 


    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # local_file.pass will be created
    + resource "local_file" "pass" {
        + content              = "this is a test value"
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
    local_file.pass: Creation complete after 0s [id=69601da586cbdbba27434e8bd9c0c17daf55458c]
    *******************************************************************
    ```


1. The files should have now been created. Run the following command to verify that the 2 files exist and they have the correct contents

    ```
    $ ls -l /var/tmp/
    
    ************ Output ************
    -rwxrwxr-x 1 ubuntu ubuntu   20 Apr 10 19:34 passwords.txt
    ********************************
    
    $ more /var/tmp/passwords.txt

    ************ Output ************
    this is a test value
    ********************************
    ```
    

## Exercise 3.2 - Command line variables

1. Re-run terraform apply but now add the variable on the command line

    ```
    $ terraform apply -var "file_content"="this is a new value through the command line variable"

    ****************************   OUTPUT   ****************************
    local_file.pass: Refreshing state... [id=69601da586cbdbba27434e8bd9c0c17daf55458c]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    -/+ destroy and then create replacement

    Terraform will perform the following actions:

    # local_file.pass must be replaced
    -/+ resource "local_file" "pass" {
        ~ content              = "this is a test value" -> "this is a new value through the command line variable" # forces replacement
        ~ id                   = "69601da586cbdbba27434e8bd9c0c17daf55458c" -> (known after apply)
            # (3 unchanged attributes hidden)
        }

    Plan: 1 to add, 0 to change, 1 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    local_file.pass: Destroying... [id=69601da586cbdbba27434e8bd9c0c17daf55458c]
    local_file.pass: Destruction complete after 0s
    local_file.pass: Creating...
    local_file.pass: Creation complete after 0s [id=bf17dac3a5e6b4515d9e6deca3f4dd1c49e31cc4]

    Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
    *******************************************************************
    ```

1. The file should have now been modified. Run the following command to verify that the file contents have changed

    ```
    more /var/tmp/passwords.txt

    ************ Output ************
    this is a new value through the command line variable
    ********************************
    ```


## Exercise 3.3 - Environment variables

1. Create an environment variable for the `file_content` variable

    ```
    export TF_VAR_file_content="Testing variables123"
    ```

1. Re-run terraform apply so that the file gets updated. Insert `--auto-approve` so that you don't have to confirm the proposed plan
    ```
    $ terraform apply --auto-approve

    ****************************   OUTPUT   ****************************
    local_file.pass: Refreshing state... [id=bf17dac3a5e6b4515d9e6deca3f4dd1c49e31cc4]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    -/+ destroy and then create replacement

    Terraform will perform the following actions:

    # local_file.pass must be replaced
    -/+ resource "local_file" "pass" {
        ~ content              = "this is a new value through the command line variable" -> "Testing variables123" # forces replacement
        ~ id                   = "bf17dac3a5e6b4515d9e6deca3f4dd1c49e31cc4" -> (known after apply)
            # (3 unchanged attributes hidden)
        }

    Plan: 1 to add, 0 to change, 1 to destroy.
    local_file.pass: Destroying... [id=bf17dac3a5e6b4515d9e6deca3f4dd1c49e31cc4]
    local_file.pass: Destruction complete after 0s
    local_file.pass: Creating...
    local_file.pass: Creation complete after 0s [id=74027d9694578e6cba4720857542be47319b51ee]

    Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
    **************************************************************************
    ```
    ***Note: Terraform didn't ask an input for the `file_content` variable***

1. The file should have now been modified. Verify that the file contents have been modified. 
    ```
    $ more /var/tmp/passwords.txt

    ************ Output ************
    Testing variables123
    ********************************    
    ```

## Exercise 3.4 - Variable precedence

1. Edit the variables.tf file and add a default value of `file_content` varialbe.

    ```
    nano variables.tf

    ********************* 
    }
    variable "file_content" {
       type = string
       default = "New content"  <--- Add this line 
    }
    *********************
    ```

1. Having set the `file_content` variable with both environment variable and a default value on the variable resource it is important to check which variable will take precedence.

    ```
    $ terraform apply --auto-approve

    ****************************   OUTPUT   ****************************
    local_file.pass: Refreshing state... [id=74027d9694578e6cba4720857542be47319b51ee]

    No changes. Your infrastructure matches the configuration.

    Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    **************************************************************************
    ```

1. Verify the file contents and determine which variable takes precendence. Environment variables or Default values?
    ```
    $ more /var/tmp/passwords.txt

    ************ Output ************
    Testing variables123
    ********************************    
    ```


1. Now let's delete the file that has been created. Run the `terraform destroy` command to remove all infratructure that has been created through the terraform scripts.

    ```
    $ terraform destroy --auto-approve

    ****************************   OUTPUT   ****************************
    local_file.pass: Refreshing state... [id=74027d9694578e6cba4720857542be47319b51ee]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    - destroy

    Terraform will perform the following actions:

    # local_file.pass will be destroyed
    - resource "local_file" "pass" {
        - content              = "Testing variables123" -> null
        - directory_permission = "0777" -> null
        - file_permission      = "0777" -> null
        - filename             = "/var/tmp/passwords.txt" -> null
        - id                   = "74027d9694578e6cba4720857542be47319b51ee" -> null
        }

    Plan: 0 to add, 0 to change, 1 to destroy.
    local_file.pass: Destroying... [id=74027d9694578e6cba4720857542be47319b51ee]
    local_file.pass: Destruction complete after 0s

    Destroy complete! Resources: 1 destroyed.
    ***********************************************************************
    ```