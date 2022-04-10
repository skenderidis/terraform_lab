resource "local_file" "pass" { 
   filename = var.file_name
   content = var.file_content
}
