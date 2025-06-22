# Development Instructions

This directory contains additional notes for Frappe and ERPNext. For the
automation guidelines used by Codex see `../DEV_INSTRUCTIONS.md`.

1. List additional vendor repositories in `vendor-repos.txt`.
2. The *Update Vendor Apps* workflow clones them and refreshes `codex.json`. Run
   `../setup.sh` locally if you want to perform the same steps manually.
3. The `CI` workflow executes the same script on every push.
4. Store JSON example files and API docs in `../sample_data` when needed.

Refer to the following guides for framework-specific tips:

- [Frappe Notes](./frappe.md)
- [ERPNext Notes](./erpnext.md)
