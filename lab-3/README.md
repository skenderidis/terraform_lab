# Lab - 1

## Exercise 1 - For_each command

Change the working directory to `~/terraform_lab/lab-3`

```
cd ~/terraform_lab/lab-3
```

Verify that main.tf and variables.tf exists and review the contents

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

Note: The `file_content` variable doesn't have a default value

Run the `terraform init` command to initialize a working directory containing Terraform configuration files. 

```
$ terraform init
```

Run the `terraform apply` command.

```
$ terraform apply
```

Terraform will ask you to input the value for the file_content variable.
Once the value has been inserted then the terraform will create the file. Run the following command to verify that the file exists and that it has the correct content

```
ls -l /var/tmp/
more /var/tmp/filename.txt
```


## Exercise 2 - Variables on command line

Re-run terraform apply but now add the variable on the command line

```
terraform apply -var "file_content"="command line variable"
```

The file should have now been modified. Run the following command to verify that the file contents have changed

```
$ more /var/tmp/passwords.txt
```


## Exercise 3 - Environment Variables

Create an environment variable for the `file_content` variable

```
export TF_VAR_file_content="Testing variables123"
```

Re-run terraform apply so that the file gets updated. Insert `--auto-approve` so that you don't have to confirm the proposed plan
```
terraform apply --auto-approve
```
Note: Terraform didn't ask an input for the `file_content` variable 

The file should have now been modified. Verify that the file contents have been modified. 
```
$ more /var/tmp/passwords.txt
```







Re-run terraform apply and verify which variable takes precedence. 


## Exercise 3 - Variable Precedence

Edit the variables.tf file and add a default value of `file_content` varialbe.

```
nano variables.tf

**** for example ****
}
variable "file_content" {
   type = string
   default = "New content"
}
*********************
```

Having set the `file_content` variable with both environment variable and a default value on the variable resource it is important to check which will take precedence.

```
terraform apply --auto-approve
```

Verify that the file contents and identify which takes precendence. Environment variables or Default values 
```
$ more /var/tmp/passwords.txt
```

