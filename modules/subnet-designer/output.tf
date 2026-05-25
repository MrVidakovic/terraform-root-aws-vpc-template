output "regular_subnets" {
  description = "A list containing the components with a regular size network and it associated CIDRs."
  value       = local.regular_nets
}

output "small_nets" {
  description = "A list containing the components with small size network and it associated CIDRs."
  value       = local.small_nets
}

output "component_subnets" {
  description = "The whole list with all the components and associated CIDRs."
  value       = merge(local.regular_nets, local.small_nets)
}
