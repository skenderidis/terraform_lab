resource "local_file" "pass_each" { 
  for_each = {
    file1 = "this is file 1"
    file2 = "this is file 2"
  }
  filename = "/var/tmp/each_${each.key}.txt"
  content = each.value
}

