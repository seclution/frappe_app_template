
# Frappe App Template

This repository is a starting point for developing custom **Frappe** or **ERPNext**
applications. It bootstraps a local development environment, clones optional
vendor apps and prepares a basic `codex.json` index for use with Codex.

## Quickstart

1. Clone this repository.
2. Run `git submodule update --init --recursive` to fetch Frappe and ERPNext.
3. Execute `./setup.sh` from the repository root to generate `codex.json`.
4. Review `init_codex_prompt.md` for the initial prompt used by Codex.

## Adding Vendor Apps

Use `git submodule add <repo> vendor/<name>` to include additional Frappe or
ERPNext apps. After adding a submodule, run `./setup.sh` to update `codex.json`.

## Repository Layout

```
apps/               # Your custom app lives here
vendor/             # Frappe, ERPNext and other apps (cloned or as submodules)
instructions/       # Development guides
codex.json          # Index of sources for Codex
init_codex_prompt.md# Starting prompt for Codex
setup.sh            # Automated initialization script
```

## Further References

More information is available in the `instructions/` folder:

- [`instructions/frappe.md`](instructions/frappe.md) – notes on creating new
  Frappe apps and useful links to the documentation.
- [`instructions/erpnext.md`](instructions/erpnext.md) – guidelines for working
  with ERPNext modules and doctypes.
