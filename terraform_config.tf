#============
#| Versions |
#============
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
  }
}

#===========
#| Backend |
#===========
terraform {
  backend "s3" {
    bucket = "terraform-state"
    region = "us-east-1"
  }
}

#=============
#| Providers |
#=============
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      cluster_product   = var.cluster_product
      cluster_name      = var.cluster_name
      environment       = var.environment
      owner             = var.owner
      terraform_managed = "true"
    }
  }
}
