variable "prefix" {
  description = "Name prefix for resources."
  type        = string
}
variable "ipv4_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}
variable "ipv4_cidr_newbits" {
  description = "Number of additional bits with which to extend the prefix."
  type        = number
}
variable "subnets_number" {
  description = "Number of subnets."
  type        = number
}
variable "create_private_subnets" {
  description = "Whether to create private subnets."
  type        = bool
  default     = true
}
variable "add_eks_tags_to_subnets" {
  description = "Whether to add EKS tags to subnets for the load balancer controller."
  type        = bool
  default     = false
}
