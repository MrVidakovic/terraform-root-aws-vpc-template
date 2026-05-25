# Terraform AWS VPC template

My Terraform root module template to start developing a new VPC in AWS.

## Characteristics

### Basic configuration elements

This templates comes with EditorConfig, Git pre-commit and git ignore configuration to fulfill security and best pactices basics. It also comes with a [Taskfile](https://taskfile.dev/) definition to help with the creation and switching of different environments.

### Terraform preconfigured components

The Terraform code ships the following elements:

- Terraform AWS provider with default tags preconfigured.
- `base_resources.tf` file with commonly used elements.
- VPC basic configuration with automatic IP calcaulation to remove most of the networking configuration related hassle by using the `components` variable and all the related configuration.
- VPC EndPoint definition for SSMM private access.
- Security Group to allow adminitrative access to different resources (for example from internet of VPN).

## Using this template

To ensure a smooth please perform the following actions when using this template to bootstrap a new Terraform root module:

1. Set the Terraform backend in `terraform_config.tf` to use your AWS S3 bucket and the right bucket region:
    ```hcl
      backend "s3" {
        bucket = "terraform-state"
        region = "us-east-1"
      }
    ```
2. Configure how `cluster_product` should be provided:
    - By default, this template keeps `cluster_product` required.
    - You can define `cluster_product` in each environment tfvars file, such as `production.tfvars` and `stage.tfvars`.
    - If you prefer a shared default, add a `default` value to `variable "cluster_product"` in `variables.tf`.
3. Set the required variables in each environment tfvars file (`production.tfvars`, `stage.tfvars`):
    - `cluster_name`: The name of the cluster being deployed.
    - `vpc_network`: The CIDR of the VPC (must be at least /16).
4. Adjust the `components` variable default value in either `variables.tf` or your tfvars files if the default subnets do not fit your use case.
5. Review and adjust other optional variables (`region`, `owner`, `operations_ips`) as needed.
6. Use AWS profiles ending in `-production` or `-stage`:
    - The Taskfile infers the Terraform environment from `AWS_PROFILE`.
    - `plan` and `apply` always re-run `init` to ensure Terraform uses the correct backend state.
    - The backend state key is built as `cluster_product/environment/cluster_name.tfstate`.

<!-- markdownlint-disable MD033 -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.28 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.28 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_admin_access_security_group"></a> [admin\_access\_security\_group](#module\_admin\_access\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_network_design"></a> [network\_design](#module\_network\_design) | ../modules/subnet-designer | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 6.0 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | ~> 6.1 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_security_group.vpc_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_availability_zones.vpc_azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_alias.aws_ssm_kms_encription_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_kms_alias.storage_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster being deployed. | `string` | n/a | yes |
| <a name="input_cluster_product"></a> [cluster\_product](#input\_cluster\_product) | The name of the product being deployed. | `string` | n/a | yes |
| <a name="input_components"></a> [components](#input\_components) | List of the component being part of the SKM cluster. Usually there's no need to change it. | <pre>list(object({<br/>    name         = string<br/>    network_size = string<br/>    network_type = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "database",<br/>    "network_size": "small",<br/>    "network_type": "rds"<br/>  },<br/>  {<br/>    "name": "cache",<br/>    "network_size": "small",<br/>    "network_type": "elasticache"<br/>  },<br/>  {<br/>    "name": "ssm",<br/>    "network_size": "small",<br/>    "network_type": "intra"<br/>  },<br/>  {<br/>    "name": "public",<br/>    "network_size": "small",<br/>    "network_type": "public"<br/>  },<br/>  {<br/>    "name": "private",<br/>    "network_size": "regular",<br/>    "network_type": "private"<br/>  }<br/>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The type of deployment, like production, staging, development, etc. | `string` | `""` | no |
| <a name="input_operations_ips"></a> [operations\_ips](#input\_operations\_ips) | List of CIDRs with administrative access | `list(string)` | <pre>[<br/>  "10.0.0.0/0"<br/>]</pre> | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The person responsible of this cluster. | `string` | `"SRE team"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the cluster is deployed. | `string` | `"us-east-1"` | no |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | The CIDR of the VPC. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- markdownlint-enable MD033 -->
