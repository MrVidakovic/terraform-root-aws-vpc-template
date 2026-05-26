---
name: terraform-standards
description: Use ONLY for Terraform work: `.tf`, `.tfvars`, Terraform modules, root modules, `terraform fmt`, `terraform validate`, `tflint`, `terraform-docs`, and Terraform repository files like `README.md`, `.editorconfig`, `.gitignore`, and `.pre-commit-config.yaml`.
---

# Terraform Standards

Use this skill whenever working on Terraform code or on repository files that support Terraform development.

Use ONLY when the task involves Terraform code, Terraform validation, Terraform documentation generation, or Terraform repository maintenance.

Typical triggers include:

- editing `.tf` or `.tfvars` files
- adding or changing Terraform modules or root modules
- updating `variables.tf`, `outputs.tf`, or `versions.tf`
- updating Terraform-related `README.md` content
- updating `.editorconfig`, `.gitignore`, or `.pre-commit-config.yaml` for Terraform repository standards
- running or fixing `terraform fmt`, `terraform validate`, `tflint`, or `terraform-docs`

Do not use this skill for non-Terraform application code, general infrastructure discussions without code changes, or unrelated repository housekeeping.

Apply these rules to both module code and root-module code unless the user explicitly asks for something else.

`docs/terraform-standards.md` is the canonical source of truth. Follow it for the full standards and keep any Terraform changes aligned with it.

Before finishing Terraform work:

- read and follow `docs/terraform-standards.md`
- update related Terraform support files when needed
- run the relevant checks from `docs/terraform-standards.md` when the tools are available
