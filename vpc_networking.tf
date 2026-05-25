module "network_design" {
  source = "../modules/subnet-designer"

  base_network_cidr = var.vpc_network
  network_services  = var.components
}
