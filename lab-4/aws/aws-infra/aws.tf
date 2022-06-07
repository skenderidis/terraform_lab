# variables
variable region { }
# VPC
resource "aws_vpc" "main" {
  cidr_block                = "10.0.0.0/16"
  enable_dns_hostnames      = true
  enable_dns_support        = true  
  tags                      = { Name = "VPC-infra" }
}
# Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.region}a"
  tags              = { Name = "Subnet-1" }
}