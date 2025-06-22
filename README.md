
# Frappe App Template

This repository is a starting point for developing custom **Frappe** or **ERPNext**
applications. It bootstraps a local development environment, clones optional
vendor apps and prepares a basic `codex.json` index for use with Codex.

## Quickstart

1. Clone this repository.
2. Edit `vendor-repos.txt` to list the Frappe/ERPNext apps you want cloned.
3. Run `./setup.sh` from the repository root. It clones the apps listed in
   `vendor-repos.txt` and generates `codex.json`.
4. Review `init_codex_prompt.md` for the initial prompt used by Codex.

## Adding Vendor Apps

Each line in `vendor-repos.txt` should contain the HTTPS URL of a Frappe or
ERPNext app repository. Re-run `./setup.sh` whenever you change this file to
fetch the new apps.

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

## Running Tests

This repository uses [pytest](https://pytest.org) for tests. To run the test suite:

```bash
pytest -q
```

The included sample test file is located in `tests/basic_integration_test.py`.
