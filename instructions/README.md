# Development Instructions

This directory contains additional notes for Frappe and ERPNext. For the
automation guidelines used by Codex see `../DEV_INSTRUCTIONS.md`.

1. List additional vendor repositories in `vendor-repos.txt`.
2. Run `../setup.sh` to clone them and update `codex.json`.
3. The `CI` workflow executes the same script on every push or via manual trigger.
4. Store JSON example files and API docs in `../sample_data` when needed.

Refer to the following guides for framework-specific tips:

- [Frappe Notes](./frappe.md)
- [ERPNext Notes](./erpnext.md)
