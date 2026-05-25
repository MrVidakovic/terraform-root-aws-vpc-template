locals {
  administrative_access_tags = {
    cluster_component = "administrative-resources"
  }
}

# ==================================================================================
# | Configure a VPC Security Group to grant administrative access to the resources |
# ==================================================================================
module "admin_access_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  use_name_prefix = false
  name            = "${local.common_name_with_hyphens}-admin-access"
  description     = "Grant administrative access to the resources allocated in the VPC"
  vpc_id          = module.vpc.vpc_id

  ingress_cidr_blocks = var.operations_ips
  ingress_rules       = []
  ingress_with_cidr_blocks = []

  tags = merge({
    Name = "${local.common_name_with_hyphens}-admin-access"
    },
    local.administrative_access_tags
  )
}
