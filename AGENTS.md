For any Terraform work in this repository, follow `docs/terraform-standards.md`.

For Terraform root modules, also follow `docs/terraform-root-module-standards.md`.

In opencode, use the `terraform-standards` skill for any Terraform task, including changes to `.tf`, `.tfvars`, `README.md`, `.pre-commit-config.yaml`, `.editorconfig`, and `.gitignore` when they are part of Terraform module or root-module maintenance.

In opencode, also use the `terraform-root-module-standards` skill when the task is specific to Terraform root modules.

Treat `docs/terraform-standards.md` as the baseline canonical source of truth for naming, variable and output structure, comment style, required repository files, and Terraform validation workflow.

Treat `docs/terraform-root-module-standards.md` as the canonical source of truth for root-module-only conventions such as `terraform_config.tf`, component-based file splitting, variable-driven deployments, IAM policy document style, community module preference, and root-module tagging.

Before finishing Terraform changes, run the checks required by `docs/terraform-standards.md` when the relevant tools are available.
