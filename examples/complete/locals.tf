locals {
  prefix            = "hoge-dev"
  ipv4_cidr         = "10.0.0.0/16"
  ipv4_cidr_newbits = 3
  subnets_number    = 2
  default_tags = {
    owner      = "gotokazuki"
    repository = "terraform-aws-network"
    created_by = "terraform"
  }
}