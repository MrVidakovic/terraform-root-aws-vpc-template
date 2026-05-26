For any Terraform work in this repository, follow `docs/terraform-standards.md`.

For Terraform root modules, also follow `docs/terraform-root-module-standards.md`.

This includes `.tf`, `.tfvars`, Terraform modules, root modules, `variables.tf`, `outputs.tf`, `versions.tf`, Terraform-related `README.md` changes, and Terraform repository support files such as `.editorconfig`, `.gitignore`, and `.pre-commit-config.yaml`.

Treat `docs/terraform-standards.md` as the baseline canonical source of truth for naming, file layout, variable and output conventions, comment style, required repository files, and validation workflow.

Treat `docs/terraform-root-module-standards.md` as the canonical source of truth for root-module-specific conventions.

Before finishing Terraform changes, run the relevant checks from `docs/terraform-standards.md` when the tools are available.
