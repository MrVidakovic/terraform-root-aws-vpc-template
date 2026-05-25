locals {
  private_subnets = flatten([
    for component in var.components :
    module.network_design.component_subnets[component.name]
    if component.network_type == "private"
  ])
  private_subnets_names = flatten([
    for component in var.components : [
      for current_subnet in module.network_design.component_subnets[component.name] :
      "${local.common_name_with_hyphens}-${component.name}-private"
    ]
    if component.network_type == "private"
  ])
  intra_subnets = flatten([
    for component in var.components :
    module.network_design.component_subnets[component.name]
    if component.network_type == "intra"
  ])
  intra_subnets_names = flatten([
    for component in var.components : [
      for current_subnet in module.network_design.component_subnets[component.name] :
      "${local.common_name_with_hyphens}-${component.name}-intra"
    ]
    if component.network_type == "intra"
  ])
  public_subnets = flatten([
    for component in var.components :
    module.network_design.component_subnets[component.name]
    if component.network_type == "public"
  ])
  public_subnets_names = flatten([
    for component in var.components : [
      for current_subnet in module.network_design.component_subnets[component.name] :
      "${local.common_name_with_hyphens}-${component.name}-public"
    ]
    if component.network_type == "public"
  ])
  elasticache_networks = flatten([
    for component in var.components :
    module.network_design.component_subnets[component.name]
    if component.network_type == "elasticache"
  ])
  elasticache_subnets_names = flatten([
    for component in var.components : [
      for current_subnet in module.network_design.component_subnets[component.name] :
      "${local.common_name_with_hyphens}-${component.name}-elasticache"
    ]
    if component.network_type == "elasticache"
  ])
  rds_networks = flatten([
    for component in var.components :
    module.network_design.component_subnets[component.name]
    if component.network_type == "rds"
  ])
  rds_subnets_names = flatten([
    for component in var.components : [
      for current_subnet in module.network_design.component_subnets[component.name] :
      "${local.common_name_with_hyphens}-${component.name}-rds"
    ]
    if component.network_type == "rds"
  ])
}

data "aws_availability_zones" "vpc_azs" {
  filter {
    name   = "region-name"
    values = [var.region]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.common_name_with_hyphens
  cidr = var.vpc_network

  azs                  = slice(data.aws_availability_zones.vpc_azs.names, 0, 3)
  private_subnets      = local.private_subnets
  private_subnet_names = local.private_subnets_names
  intra_subnets        = local.intra_subnets
  intra_subnet_names   = local.intra_subnets_names
  public_subnets       = local.public_subnets
  public_subnet_names  = local.public_subnets_names

  #================================
  #| RDS networking configuration |
  #================================
  create_database_subnet_group = length(local.rds_networks) > 0 ? true : false
  database_subnets             = local.rds_networks
  database_subnet_names        = local.rds_subnets_names

  #========================================
  #| Elasticache networking configuration |
  #========================================
  create_elasticache_subnet_group = length(local.elasticache_networks) > 0 ? true : false
  elasticache_subnets             = local.elasticache_networks
  elasticache_subnet_names        = local.elasticache_subnets_names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  # Need DNS hostnames configuration in VPC for private DNS zone resolution
  enable_dns_hostnames = true
  enable_dns_support   = true
}

locals {
  all_vpc_network_cidr_blocks = concat(module.vpc.intra_subnets_cidr_blocks, module.vpc.private_subnets_cidr_blocks, module.vpc.public_subnets_cidr_blocks, module.vpc.database_subnets_cidr_blocks, module.vpc.elasticache_subnets_cidr_blocks)
  all_vpc_network_ids         = concat(module.vpc.intra_subnets, module.vpc.private_subnets, module.vpc.public_subnets, module.vpc.database_subnets, module.vpc.elasticache_subnets)

  component_subnets_ids = {
    for component_definition in var.components :
    component_definition.name => tolist([
      for component_network_cidr in module.network_design.component_subnets[component_definition.name] :
      element(local.all_vpc_network_ids, index(local.all_vpc_network_cidr_blocks, component_network_cidr))
    ])
  }
}
