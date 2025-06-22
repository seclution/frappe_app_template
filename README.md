
# Frappe App Template

**Important:** This project keeps its documentation in two separate files. This
`README.md` is written for human developers who want to build on top of the
template with Codex. Detailed instructions for the Codex automation live in
`DEV_INSTRUCTIONS.md`.

## TL;DR – Using Codex

1. **Clone this repo** or fork it for your own project.
2. **Add required vendor apps** to `vendor-repos.txt`.
3. **Run `./setup.sh`** to clone the listed repositories and generate `codex.json`.
4. **Start Codex** with the prompt in `init_codex_prompt.md`.
5. The `CI` workflow runs the same setup and tests automatically.
6. **Optional sample data** for external integrations lives in `sample_data/`.

This repository is a starting point for developing custom **Frappe** applications. ERPNext can be added manually if required. It bootstraps a local development environment, clones optional vendor apps and prepares a basic `codex.json` index for use with Codex. Sample payloads or interface documentation can be stored in the `sample_data/` folder.

## Quickstart

1. Clone this repository.
2. By default `vendor-repos.txt` contains only Frappe. Run `./setup.sh` to clone
   Frappe and Bench and to generate `codex.json` referencing `apps/`,
   `vendor/frappe/`, `vendor/bench/` and `instructions/`.
3. To add ERPNext, append `https://github.com/frappe/erpnext` to
   `vendor-repos.txt` and rerun `./setup.sh`.
4. Review `init_codex_prompt.md` for the initial prompt used by Codex.
5. See [`prompts.md`](prompts.md) for instructions on adding more templates.
6. Place any example payloads or external API docs under `sample_data/` for
   reference.

## Adding Vendor Apps

Use `git submodule add <repo> vendor/<name>` to include additional Frappe apps.
To add ERPNext manually, run:

```bash
git submodule add https://github.com/frappe/erpnext vendor/erpnext
./setup.sh
```

This clones ERPNext into `vendor/` and updates `codex.json`.

## Repository Layout

```
apps/               # Your custom app lives here
vendor/             # Frappe apps (ERPNext can be added manually)
instructions/       # Development guides
codex.json          # Index of sources for Codex
codex_prompt.md     # Main prompt for Codex
setup.sh            # Automated initialization script
sample_data/        # Example payloads and external API documentation
```

## Running Tests

Install the dependencies listed in `requirements.txt` and then execute the test suite with `pytest -q`:

```bash
pip install -r requirements.txt
pytest -q
```

The included sample test file is located in `tests/basic_integration_test.py`.

## Further References

More information is available in the `instructions/` folder:

- [`instructions/frappe.md`](instructions/frappe.md) – notes on creating new
  Frappe apps and useful links to the documentation.
- [`instructions/erpnext.md`](instructions/erpnext.md) – guidelines for working
  with ERPNext modules and doctypes.
