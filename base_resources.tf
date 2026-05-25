locals {
  common_name_with_hyphens = var.cluster_name == var.cluster_product ? replace("${var.cluster_product}-${var.environment}", "_", "-") : replace("${var.cluster_product}-${var.cluster_name}-${var.environment}", "_", "-")
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

#=========================================
#| Custom KMS key for storage encryption |
#=========================================
data "aws_kms_alias" "storage_encryption" {
  name = "alias/storage-encryption"
}

#==========================================
#| SSM Parameter store KMS encryption key |
#==========================================
data "aws_kms_alias" "aws_ssm_kms_encription_key" {
  name = "alias/aws/ssm"
}
