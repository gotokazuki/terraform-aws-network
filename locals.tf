locals {
  az_suffix = [for i in [0, 1, 2] : reverse(split("-", data.aws_availability_zones.available.names[i]))[0]]
}
