# Lab - 2

In this Lab we have 4 exercises:
- [Exercise 2.1 - Simple variables](#exercise-2.1---simple-variables)
- [Exercise 2.2 - Command line variables](#exercise-22---command-line-variables)
- [Exercise 2.3 - Environment variables](#exercise-23---environment-variables)
- [Exercise 2.4 - Variable precedence](#exercise-24---variable-precedence)


## Exercise 2.1 - Simple variables

1. Change the working directory to `~/terraform_lab/lab-3`

    ```
    cd ~/terraform_lab/lab-3
    ```

1. Verify that main.tf and variables.tf exists and review the contents

    main.tf
    ```
    resource "local_file" "pass" { 
       filename = var.file_name
       content = var.file_content
    }
    ```
    variables.tf
    ```
    variable "file_name" {
       type = string
       default = "/var/tmp/passwords.txt"
    }
    variable "file_content" {
       type = string
    }
    ```

    ***Note: The `file_content` variable doesn't have a default value***

1. Run `terraform init` command to initialize a working directory containing Terraform configuration files. 

    ```
    $ terraform init
    ```

1. Run the `terraform apply` command.

    ```
    $ terraform apply
    ```

1. Terraform will ask you to input the value for the file_content variable.
    ```
    xxxxxxxxx    xxxxxxxxx
        xxxxxxxxx
        xxxxxxxxx
    xxxxxxxxx
    ```
1. Once the value has been inserted then the terraform will create the file. Run the following command to verify that the file exists and that it has the correct content

    ```
    ls -l /var/tmp/
    more /var/tmp/filename.txt
    ```


## Exercise 2.2 - Command line variables

1. Re-run terraform apply but now add the variable on the command line

    ```
    terraform apply -var "file_content"="command line variable"
    ```

1. The file should have now been modified. Run the following command to verify that the file contents have changed

    ```
    more /var/tmp/passwords.txt
    ```


## Exercise 2.3 - Environment variables

1. Create an environment variable for the `file_content` variable

    ```
    export TF_VAR_file_content="Testing variables123"
    ```

1. Re-run terraform apply so that the file gets updated. Insert `--auto-approve` so that you don't have to confirm the proposed plan
    ```
    terraform apply --auto-approve
    ```
    ***Note: Terraform didn't ask an input for the `file_content` variable***

1. The file should have now been modified. Verify that the file contents have been modified. 
    ```
    $ more /var/tmp/passwords.txt
    ```

## Exercise 2.4 - Variable precedence

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
    terraform apply --auto-approve
    ```

1. Verify that the file contents and identify which variable takes precendence. Environment variables or Default values 
    ```
    $ more /var/tmp/passwords.txt
    ```

