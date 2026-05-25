# OVidakovic Subnet designer

Terraform module to calculate all the subnets required by a VPC. The idea is to provide the base CIDR for the whole VPC, as well as a list providing the component names and sizes, and it will output a list of all the components and the associated CIDRs, ready to deploy to a VPC.

## Functionality

The module requires a list of maps, each of them containing at least a `name` filed with the component name, and a `network_size` field indicating the network size. Right now `network_size` can have 2 values:

- `regular`: intended for servers, big clusters, etc. By defuault it has a mask of 22 bits, meaning capacity of 10204 hosts.
- `small`: intended for small networks, mainly for transit networks: load balancers, endpoints, vpc peerings, etc. By default it has a mask of 26 bits, meaning capacity of 64 hosts.

Exmaple:

```hcl
[
    {
        name = "my-amazing-component"
        network_size = "regular"
    },
    {
        name = "my-transit-network"
        network_size = "small"
    }
]
```

The module will calculate the subnetting for 3 different availiability zones, and will output a map contaning the CIDR list for each component, like this:

```hcl
{
    my-amazing-component = [
        "10.0.0.0/22",
        "10.0.32.0/22",
        "10.0.64.0/22"
    ]
    my-amazing-component = [
        "10.0.128.0/26",
        "10.0.128.32/26",
        "10.0.128.64/26"
    ]
}
```

## Examples

```hcl
locals {
  system_components = [
    {
      name         = "consumer"
      network_size = "regular"
    },
    {
      name         = "sp-public"
      network_size = "regular"
    },
    {
      name         = "frontend"
      network_size = "small"
    },
    {
      name         = "sqs-endpoint"
      network_size = "small"
    },
  ]
}

module "network_design" {
  source = "../modules/subnet-designer"

  base_network_cidr = "172.16.0.0/16"
  network_services  = local.system_components
}

```

<!-- markdownlint-disable MD033 -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_regional_subnets"></a> [regional\_subnets](#module\_regional\_subnets) | hashicorp/subnets/cidr | ~> 1.0 |
| <a name="module_regular_subnet_a"></a> [regular\_subnet\_a](#module\_regular\_subnet\_a) | hashicorp/subnets/cidr | ~> 1.0 |
| <a name="module_regular_subnet_b"></a> [regular\_subnet\_b](#module\_regular\_subnet\_b) | hashicorp/subnets/cidr | ~> 1.0 |
| <a name="module_regular_subnet_c"></a> [regular\_subnet\_c](#module\_regular\_subnet\_c) | hashicorp/subnets/cidr | ~> 1.0 |
| <a name="module_small_subnets"></a> [small\_subnets](#module\_small\_subnets) | hashicorp/subnets/cidr | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_base_network_cidr"></a> [base\_network\_cidr](#input\_base\_network\_cidr) | The base CIDR from where all the networks are derived. | `string` | n/a | yes |
| <a name="input_network_services"></a> [network\_services](#input\_network\_services) | List of component needing networks. The network size can be 'regular' or 'small'. Small size is useful to host VPC EndPoints, Load Balancers, HSM clusters and so on. | <pre>list(object({<br/>    name         = string<br/>    network_size = string<br/>  }))</pre> | n/a | yes |
| <a name="input_regular_network_mask"></a> [regular\_network\_mask](#input\_regular\_network\_mask) | Number of bits of the network part of the mask for regular networks. | `number` | `22` | no |
| <a name="input_small_network_mask"></a> [small\_network\_mask](#input\_small\_network\_mask) | Number of bits of the network part of the mask for tiny networks. | `number` | `26` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_component_subnets"></a> [component\_subnets](#output\_component\_subnets) | The whole list with all the components and associated CIDRs. |
| <a name="output_regular_subnets"></a> [regular\_subnets](#output\_regular\_subnets) | A list containing the components with a regular size network and it associated CIDRs. |
| <a name="output_small_nets"></a> [small\_nets](#output\_small\_nets) | A list containing the components with small size network and it associated CIDRs. |
<!-- END_TF_DOCS -->
<!-- markdownlint-enable MD033 -->

