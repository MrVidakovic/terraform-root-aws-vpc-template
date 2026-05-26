# Terraform Standards

Use these standards for any Terraform work, including `.tf`, `.tfvars`, Terraform modules, root modules, Terraform repository maintenance, and Terraform validation and documentation workflows.

These rules apply to both module code and root-module code unless the task explicitly requires a deviation.

## Core Behavior

- Prefer minimal changes that fit the existing structure.
- Keep naming and file layout consistent with the existing codebase unless that conflicts with these standards.
- When adding or changing Terraform code, update related files such as `variables.tf`, `outputs.tf`, `versions.tf`, and `README.md` when needed.
- Before finishing Terraform work, run the relevant validation and formatting commands when the tools are available.

## Naming Conventions

### General

- Use `snake_case` for resource names, data source names, locals, variables, and outputs.

### Resource And Data Source Arguments

- Do not repeat the resource type in the resource or data source name.
- Use singular nouns for names.
- Use kebab-case for user-facing argument values such as DNS names, instance names, and similar identifiers.
- Put `count` or `for_each` at the top of the block, followed by one empty line.
- If a block supports `tags`, place `tags` as the last real argument.
- After `tags`, place `depends_on` and `lifecycle` only if needed, each separated by one empty line.
- When writing conditions for `count` or `for_each`, prefer direct boolean logic over length-based or similar indirect expressions.

## Variables

- Every variable must include `description`.
- Reuse upstream provider or Terraform documentation wording when that wording is accurate.
- Order arguments in each variable block as: `description`, `type`, `default`, `validation`.
- Use plural names for variables whose type is `list(...)` or `map(...)`.
- Prefer simple types such as `number`, `string`, `list(...)`, `map(...)`, and `any`.
- Use `object(...)` only when strict per-key constraints are actually needed.
- Use more specific nested map types such as `map(map(string))` when all elements share the same shape and type.
- Use `any` when validation should stop beyond a certain depth or when multiple value types must be accepted.
- Use `tomap(...)` when you need a map from `{}` input because `{}` can otherwise be treated as an object.
- Avoid double negatives in variable names. Prefer positive names such as `encryption_enabled` over `encryption_disabled`.
- For variables that must never be `null`, set `nullable = false`.
- If `null` is acceptable, omit `nullable` or set it to `true`.

## Outputs

- Every output must include `description`.
- Output names must make the returned property clear outside the local file or module.
- Prefer output names in the form `{name}_{type}_{attribute}`.
- In that structure, `{name}` is the resource or data source name.
- In that structure, `{type}` is the resource or data source type without the provider prefix.
- In that structure, `{attribute}` is the exported attribute.
- Use plural output names when the returned value is a list.
- Prefer `try()` over legacy patterns like `element(concat(...))`.

## Comment Style

- Use `#` comments only.
- Do not use `//` comments.
- Do not use block comments.
- Use `# -----` to delimit section headers in Terraform code when section markers help readability.

## Required Terraform Files

Unless the related content is genuinely absent, Terraform code should include:

- `variables.tf` for variable declarations used by the code.
- `outputs.tf` for outputs produced by the code.
- `versions.tf` for Terraform and provider version requirements.

## Required Repository Files

Terraform repositories should include these root-level files for consistency:

- `.editorconfig`
- `.gitignore`
- `.pre-commit-config.yaml`
- `README.md`

## Standard `.editorconfig`

Root-level `.editorconfig` content should be:

```ini
# EditorConfig is awesome: https://editorconfig.org

# top-most EditorConfig file
root = true

# Unix-style newlines without a newline ending every file
[*]
charset = utf-8
end_of_line = lf
trim_trailing_whitespace = true

[*.{tf,tfvars}]
indent_style = space
indent_size = 2

[*.{md,mkdn,txt}]
indent_style = space
trim_trailing_whitespace = false
```

## Standard `.gitignore`

Root-level `.gitignore` should include at least:

```gitignore
# -------------------
# | Terraform files |
# -------------------
# Local .terraform directories
**/.terraform/*

# Terraform state files
*.tfstate
*.tfstate.*

# Variables files
*.tfvars
*.tfvars.json

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Terraform CLI configuration
.terraformrc
terraform.rc

# Execution plan files
*.tfplan

# Don't include temporal plan file created by ansible
apply_plan

# -----------------------
# | Task file overrides |
# -----------------------
Taskfile.yml
taskfile.yml
Taskfile.yaml
taskfile.yaml

# ---------------------------
# | IDE configuration files |
# ---------------------------
# VS Code
.vscode/

# IntelliJ IDEA
.idea/
*.iml

# Eclipse
.project
.classpath
.settings/

# Sublime Text
*.sublime-project
*.sublime-workspace

# ---------------
# | Misc. files |
# ---------------
# Log files
# For example crash log files
*.log

# Lambda build artifacts
builds/
__pycache__/
*.zip
.tox

# Local macos file
.DS_Store
```

## Standard Pre-Commit Configuration

Root-level `.pre-commit-config.yaml` should include at least:

```yaml
repos:
- repo: https://github.com/antonbabenko/pre-commit-terraform
  rev: v1.105.0
  hooks:
    - id: terraform_fmt
    - id: terraform_validate
    - id: terraform_tflint
    - id: terraform_docs
```

## README Standard

Each Terraform repository should include a `README.md` with at least:

```markdown
# <MODULE_NAME>

General description of the Terraform module or root module explaining
the main functionalities, peculiarities, special requirements and
things to keep in mind.

Feel free to add subsections if needed to expand information and
explanations regarding the functionality and/or corner cases.

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
```

The `terraform-docs` tool is expected to populate the section between the markers.

## Validation Workflow

Before considering Terraform work complete, run the relevant checks when the tools are available:

- `terraform fmt`
- `terraform validate`
- `tflint`
- `terraform-docs`

If one of these tools is unavailable or cannot run in the current environment, report that clearly.

## Practical Editing Checklist

- Ensure new variables and outputs have descriptions.
- Ensure list and map names are plural.
- Ensure output names clearly describe the returned value.
- Ensure comments use `#` style only.
- Ensure block ordering and spacing follow these conventions.
- Ensure supporting files stay in sync with Terraform changes.
- Ensure README docs markers remain intact when using `terraform-docs`.
