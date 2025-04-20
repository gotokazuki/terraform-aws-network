module "network" {
  source = "../../"

  prefix                       = local.prefix
  ipv4_cidr                    = local.ipv4_cidr
  ipv4_cidr_newbits            = local.ipv4_cidr_newbits
  subnets_number               = local.subnets_number
  create_private_subnets       = true
  add_eks_tags_to_subnets      = true
  create_s3_vpc_endpoint       = true
  create_dynamodb_vpc_endpoint = true
}
