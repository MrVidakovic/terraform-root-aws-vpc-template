For any Terraform work in this repository, follow `docs/terraform-standards.md`.

In opencode, use the `terraform-standards` skill for any Terraform task, including changes to `.tf`, `.tfvars`, `README.md`, `.pre-commit-config.yaml`, `.editorconfig`, and `.gitignore` when they are part of Terraform module or root-module maintenance.

Treat `docs/terraform-standards.md` as the canonical source of truth for naming, variable and output structure, comment style, required repository files, and Terraform validation workflow.

Before finishing Terraform changes, run the checks required by `docs/terraform-standards.md` when the relevant tools are available.
