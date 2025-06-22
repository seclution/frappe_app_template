# Development Instructions

This directory collects notes for working with ERPNext. The root `DEV_INSTRUCTIONS.md` describes how Codex sets up the project.

1. Optional templates are listed in `template-repos.txt`.
2. Run `../setup.sh` from the Frappe template or trigger its **Update Vendor Apps** workflow to fetch ERPNext and rebuild `codex.json`.
3. The `CI` workflow runs the same script automatically.
4. Place any example payloads or API docs in `../sample_data`.

Refer to the following guide for framework-specific tips:

- [ERPNext Notes](./erpnext.md)
