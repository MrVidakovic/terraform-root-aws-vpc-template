# Terraform Root Module Standards

Use these standards in addition to `docs/terraform-standards.md` when working on Terraform root modules.

These rules are specific to root modules and should not be applied to reusable Terraform modules unless the task explicitly asks for that.

## Trigger Conditions

Apply this standard when the task involves any of the following:

- a Terraform root module
- environment-specific deployments such as production, stage, dev, or sandbox
- root-module file layout and component boundaries
- root-module provider or Terraform configuration
- adding AWS infrastructure components to a root module

## Root Module File Rules

- In root modules, place Terraform core configuration and provider configuration in `terraform_config.tf`.
- Do not use `versions.tf` for Terraform core configuration or provider configuration in root modules.
- Reserve `versions.tf` for reusable Terraform modules.

## Environment Flexibility

- Write root-module Terraform so different deployments can be achieved by changing input variables rather than editing Terraform code.
- Prefer parameterized values, feature flags, maps, lists, and environment-specific variable inputs over branching the codebase per environment.
- Avoid hardcoding environment-specific values when they can reasonably be expressed as variables.

## File Splitting Strategy

- Split root-module Terraform into multiple files for maintainability.
- Each file should represent one infrastructure component.
- Typical component files include things like autoscaling groups, RDS, ECS cluster, ECS task definitions, EKS cluster, cache, CDN, networking, or observability resources.
- Related resources may stay in the same file when they primarily support that component.
- Supporting resources can include security groups, IAM roles, IAM policies, CloudWatch resources, and similar component-local dependencies.
- If resources are shared across multiple component files, place them in a common file with a name that reflects the shared purpose.
- Examples of shared resources include common IAM policies, shared security groups, shared locals, or resources used by multiple related deployments such as primary and replica databases or multiple ECS tasks.

## Variables Placement

- Declare variables only in `variables.tf`.
- Do not spread variable declarations across component files.
- Organize variables in `variables.tf` using dedicated sections with clear comment headers.

## AWS Policy Documents

- Prefer writing AWS IAM policy documents in HCL with the `aws_iam_policy_document` data source.
- Do not hand-write IAM policies as inline JSON unless there is a strong reason the data source cannot express the policy.
- Use the provider documentation as the reference: `https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document`.

## AWS Community Modules

- When adding a new infrastructure component, prefer the AWS community modules from `terraform-aws-modules` over manually creating the equivalent resources.
- Evaluate whether a community module is a good fit before building the resources directly.
- Common examples include EKS, RDS, ECS, CloudFront, and security group modules.

Examples:

- `terraform-aws-modules/eks/aws`
- `terraform-aws-modules/rds/aws`
- `terraform-aws-modules/ecs/aws`
- `terraform-aws-modules/cloudfront/aws`
- `terraform-aws-modules/security-group/aws`

## Module Version Pinning

- Pin community module versions to the latest intended major version while allowing minor and patch updates.
- Prefer pessimistic constraints such as `~> 6.0`.
- Do not leave module versions unpinned.

## Root Module Tagging

- In addition to default provider tags, define a local map for component-specific tags and merge it into each Terraform resource created in the root module.
- The local map must include `cluster_component` and `service`.
- `cluster_component` describes the infrastructure category being created.
- Example values for `cluster_component` include `db`, `cache`, `cdn`, `server`, and `ecs-task`.
- `service` describes the logical application component.
- Example values for `service` include `api`, `frontend`, and `worker`.
- Keep tag values user-facing and stable. Prefer lowercase kebab-case unless an existing convention in the root module requires something else.

## Root Module Checklist

- Place Terraform and provider configuration in `terraform_config.tf`.
- Keep variable declarations in `variables.tf` only.
- Split files by infrastructure component.
- Put shared resources in clearly named common files when they span multiple components.
- Prefer `aws_iam_policy_document` over JSON IAM policies.
- Prefer `terraform-aws-modules` community modules for new components.
- Pin module versions with a pessimistic major-version constraint such as `~> 6.0`.
- Add `cluster_component` and `service` tags through a local tag map merged into each created resource.
- Ensure deployment differences are driven by variables rather than code edits.
