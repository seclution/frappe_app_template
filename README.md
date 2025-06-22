
# Frappe App Template

This repository is a starting point for developing custom **Frappe** or **ERPNext**
applications. It bootstraps a local development environment, clones optional
vendor apps and prepares a basic `codex.json` index for use with Codex.

## Quickstart

1. Clone this repository.
2. By default `vendor-repos.txt` contains only Frappe. Run `./setup.sh` to clone
   Frappe and Bench and to generate `codex.json` referencing `apps/`,
   `vendor/frappe/`, `vendor/bench/` and `instructions/`.
3. To add ERPNext, append `https://github.com/frappe/erpnext` to
   `vendor-repos.txt` and rerun `./setup.sh`.
4. Review `init_codex_prompt.md` for the initial prompt used by Codex.
5. See [`prompts.md`](prompts.md) for instructions on adding more templates.

## Adding Vendor Apps

Use `git submodule add <repo> vendor/<name>` to include additional Frappe or
ERPNext apps. After adding a submodule, run `./setup.sh` to update `codex.json`.

## Repository Layout

```
apps/               # Your custom app lives here
vendor/             # Frappe, ERPNext and other apps (cloned or as submodules)
instructions/       # Development guides
codex.json          # Index of sources for Codex
codex_prompt.md     # Main prompt for Codex
setup.sh            # Automated initialization script
```

## Running Tests

Install the dependencies listed in `requirements.txt` and execute the test suite
with `pytest`:

```bash
pip install -r requirements.txt
pytest
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
