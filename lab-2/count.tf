resource "local_file" "pass_count" { 
  count = 2
  filename = "/var/tmp/count_${count.index}.txt"
  content = "this is file ${count.index}"
}