output "vpc_id" {
  value = module.network.vpc_id
}
output "vpc_cidr_block" {
  value = module.network.vpc_cidr_block
}
output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}
output "private_subnet_azs" {
  value = module.network.private_subnet_azs
}
