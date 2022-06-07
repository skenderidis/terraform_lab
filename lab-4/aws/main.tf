variable region {
  default = "eu-central-1"
}
provider aws {
  region = var.region
}

module "server" {
  source = "./aws-infra"
  region =  var.region
}