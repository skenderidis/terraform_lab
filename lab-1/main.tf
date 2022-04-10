resource "local_file" "pass" { 
  filename = "/var/tmp/passwords.txt"
  content = " New Value"
}
