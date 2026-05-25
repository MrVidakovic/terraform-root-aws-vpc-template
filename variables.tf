#======================
#| Naming and tagging |
#======================
variable "cluster_name" {
  description = "The name of the cluster being deployed."
  type        = string
}

variable "cluster_product" {
  description = "The name of the product being deployed."
  type        = string
}

variable "environment" {
  description = "The type of deployment, like production, staging, development, etc."
  type        = string
  default     = ""

  validation {
    condition     = contains(["production", "stage", "devel"], var.environment)
    error_message = "The environment variable should be 'production', 'stage' or 'devel'."
  }
}

variable "owner" {
  description = "The team or person responsible of this cluster."
  type        = string
  default     = "SRE team"
}

variable "region" {
  description = "The region where the cluster is deployed."
  type        = string
  default     = "us-east-1"
}

#============================
#| Networking configuration |
#============================
variable "components" {
  description = "List of the component being part of the SKM cluster. Usually there's no need to change it."
  type = list(object({
    name         = string
    network_size = string
    network_type = string
  }))
  default = [
    {
      name         = "database"
      network_size = "small"
      network_type = "rds"
    },
    {
      name         = "cache"
      network_size = "small"
      network_type = "elasticache"
    },
    {
      name         = "ssm"
      network_size = "small"
      network_type = "intra"
    },
    {
      name         = "public"
      network_size = "small"
      network_type = "public"
    },
    {
      name         = "private"
      network_size = "regular"
      network_type = "private"
    },
  ]
}

variable "vpc_network" {
  description = "The base CIDR of the VPC. the netmask part should be /16 or greater."
  type        = string

  validation {
    condition     = var.vpc_network != "" && can(tonumber(element(split("/", var.vpc_network), length(split("/", var.vpc_network)) - 1)) >= 16)
    error_message = "The vpc_network variable should be set with a subnet of at least 16 bits (X.X.X.X/16)."
  }
}

variable "operations_ips" {
  description = "List of CIDRs with administrative access"
  type        = list(string)
  default     = ["10.0.0.0/0"]
}
