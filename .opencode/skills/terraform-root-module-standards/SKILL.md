---
name: terraform-root-module-standards
description: Use ONLY for Terraform root modules: environment-specific deployments, `terraform_config.tf`, root-module file layout, AWS component files, IAM policy documents, community modules, and root-module tagging conventions.
---

# Terraform Root Module Standards

Use this skill only for Terraform root-module work.

Typical triggers include:

- editing a Terraform root module
- adding production, stage, dev, or sandbox deployment support
- changing root-module provider or Terraform configuration
- deciding between `terraform_config.tf` and `versions.tf`
- splitting root-module code by infrastructure component
- adding ECS, EKS, RDS, CloudFront, security groups, or similar AWS components to a root module
- choosing between manual AWS resources and `terraform-aws-modules` community modules

Do not use this skill for reusable Terraform modules unless the task explicitly asks for root-module conventions there.

`docs/terraform-root-module-standards.md` is the canonical source of truth. Follow it together with `docs/terraform-standards.md`.

Before finishing root-module work:

- read and follow `docs/terraform-root-module-standards.md`
- also follow the baseline rules in `docs/terraform-standards.md`
- keep environment differences variable-driven
- keep variables declared in `variables.tf`
- run the relevant Terraform checks required by `docs/terraform-standards.md` when the tools are available
