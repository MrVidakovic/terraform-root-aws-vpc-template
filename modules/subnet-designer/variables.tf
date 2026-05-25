variable "base_network_cidr" {
  description = "The base CIDR from where all the networks are derived."
  type        = string
}

variable "network_services" {
  description = "List of component needing networks. The network size can be 'regular' or 'small'. Small size is useful to host VPC EndPoints, Load Balancers, HSM clusters and so on."
  type = list(object({
    name         = string
    network_size = string
  }))
}

variable "regular_network_mask" {
  description = "Number of bits of the network part of the mask for regular networks."
  type        = number
  default     = 22
}

variable "small_network_mask" {
  description = "Number of bits of the network part of the mask for tiny networks."
  type        = number
  default     = 26
}
