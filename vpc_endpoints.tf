module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 6.1"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = local.component_subnets_ids["ssm"]
      security_group_ids  = [aws_security_group.vpc_tls.id]
    },
  }
  tags = {
    Name = "${local.common_name_with_hyphens}-endpoint-ssm"
  }
}

#========================
#| Supporting Resources |
#========================
resource "aws_security_group" "vpc_tls" {
  name_prefix = "${local.common_name_with_hyphens}-vpc-tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = "${local.common_name_with_hyphens}-interface-endpoint-access"
  }
}
