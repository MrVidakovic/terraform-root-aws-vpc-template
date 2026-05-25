locals {
  source_network_mask     = regex("/([[:digit:]]+)$", var.base_network_cidr)
  regular_networks_offset = var.regular_network_mask - 2 - local.source_network_mask.0
  small_networks_offset   = var.small_network_mask - 2 - local.source_network_mask.0

  regular_nets = {
    for network_service in var.network_services :
    network_service.name => tolist([lookup(module.regular_subnet_a.network_cidr_blocks, network_service.name), lookup(module.regular_subnet_b.network_cidr_blocks, network_service.name), lookup(module.regular_subnet_c.network_cidr_blocks, network_service.name)])
    if network_service.network_size == "regular"
  }
  small_nets = {
    for network_service in var.network_services :
    network_service.name => tolist([
      for availability_zone in tolist(["a", "b", "c"]) :
      lookup(module.small_subnets.network_cidr_blocks, "${network_service.name}_${availability_zone}")
    ])
    if network_service.network_size == "small"
  }
}

module "regional_subnets" {
  source = "hashicorp/subnets/cidr"
  version = "~> 1.0"

  base_cidr_block = var.base_network_cidr
  networks = [
    {
      name     = "region_a"
      new_bits = 2
    },
    {
      name     = "region_b"
      new_bits = 2
    },
    {
      name     = "region_c"
      new_bits = 2
    },
    {
      name     = "special-services"
      new_bits = 2
    }
  ]
}

# ================
# | Regular nets |
# ================
module "regular_subnet_a" {
  source = "hashicorp/subnets/cidr"
  version = "~> 1.0"

  base_cidr_block = lookup(module.regional_subnets.network_cidr_blocks, "region_a")
  networks = [
    for network_service in var.network_services : {
      name     = network_service.name
      new_bits = local.regular_networks_offset
    } if network_service.network_size == "regular"
  ]
}

module "regular_subnet_b" {
  source = "hashicorp/subnets/cidr"
  version = "~> 1.0"

  base_cidr_block = lookup(module.regional_subnets.network_cidr_blocks, "region_b")
  networks = [
    for network_service in var.network_services : {
      name     = network_service.name
      new_bits = local.regular_networks_offset
    } if network_service.network_size == "regular"
  ]
}

module "regular_subnet_c" {
  source = "hashicorp/subnets/cidr"
  version = "~> 1.0"

  base_cidr_block = lookup(module.regional_subnets.network_cidr_blocks, "region_c")
  networks = [
    for network_service in var.network_services : {
      name     = network_service.name
      new_bits = local.regular_networks_offset
    } if network_service.network_size == "regular"
  ]
}

# ==============
# | Small nets |
# ==============
module "small_subnets" {
  source = "hashicorp/subnets/cidr"
  version = "~> 1.0"

  base_cidr_block = lookup(module.regional_subnets.network_cidr_blocks, "special-services")
  networks = flatten([
    for network_service in var.network_services : [
      for availability_zone in ["a", "b", "c"] : {
        name     = "${network_service.name}_${availability_zone}"
        new_bits = local.small_networks_offset
      }
    ] if network_service.network_size == "small"
  ])
}
