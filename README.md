
# Frappe App Template

**Important:** This project keeps its documentation in two separate files. This
`README.md` is written for human developers who want to build on top of the
template with Codex. Detailed instructions for the Codex automation live in
`DEV_INSTRUCTIONS.md`.

## TL;DR – Using Codex

1. **Clone this repo** or fork it for your own project.
2. **Frappe** and **Bench** are included as submodules using the versions
   specified in `apps.json`.
3. **Add additional framework repos** (ERPNext/HRMS) to `vendor-repos.txt` when
   needed.
4. **Add optional template repos** to `template-repos.txt` when you want to
   include additional instructions.
5. The *Update Vendor Apps* workflow clones the listed repositories and
   generates `codex.json`. You can still run `./setup.sh` locally if needed
   (make sure `jq` is installed).
6. **Start your project** by editing `vendor-repos.txt` (for extra apps) and
   `template-repos.txt` to include all external repositories you need.
   Run the *Update Vendor Apps* workflow or `./setup.sh` to clone them and
   rebuild `codex.json`.
7. The `CI` workflow runs the same setup and tests automatically.
8. **Optional sample data** for external integrations lives in `sample_data/`.

This repository is a starting point for developing custom **Frappe** applications. ERPNext can be added manually if required. It bootstraps a local development environment, clones optional vendor apps and prepares a basic `codex.json` index for use with Codex. Sample payloads or interface documentation can be stored in the `sample_data/` folder.

## Quickstart

1. Clone this repository.
2. Default versions for Frappe and Bench are defined in `apps.json` and
   already checked out as submodules.
3. `vendor-repos.txt` starts empty. Frappe and Bench are already checked out via
   `apps.json`. The *Update Vendor Apps* workflow clones any listed repositories
   and regenerates `codex.json`. Run `./setup.sh` locally if you want to mirror
   the process (requires `jq`).
4. Optional development templates can be listed in `template-repos.txt`.
   They will be cloned alongside the framework repos and their instructions are
   added to Codex automatically.
5. To add ERPNext, append `https://github.com/frappe/erpnext` to
   `vendor-repos.txt` and trigger the workflow or run `./setup.sh` manually
   (requires `jq`).
6. Review `codex_prompt.md` for the default guidelines Codex follows.
7. See [`prompts.md`](prompts.md) for instructions on adding more templates.
8. Place any example payloads or external API docs under `sample_data/` for
   reference. The directory is indexed in `codex.json` when present.

## Adding Vendor Apps

Use `git submodule add <repo> vendor/<name>` to include additional Frappe apps.
After adding a repository trigger the *Update Vendor Apps* workflow or run
`./setup.sh` locally (requires `jq`). To add ERPNext manually:

```bash
git submodule add https://github.com/frappe/erpnext vendor/erpnext
./setup.sh   # optional when working locally; requires jq
```

This clones ERPNext into `vendor/` and updates `codex.json`.

## Vendor Repository Types

Two lists keep track of external sources:

1. `vendor-repos.txt` – additional framework apps such as ERPNext or HRMS.
   Frappe and Bench are already pinned in `apps.json`.
2. `template-repos.txt` – additional templates that include their own
   development instructions.

The update workflow clones both lists and adds any `instructions/` directories
from the templates to `codex.json`. Follow those instructions together with this
document when developing your app.

## Repository Layout

```
apps/               # Your custom app lives here
vendor/             # Frappe apps (ERPNext can be added manually)
instructions/       # Development guides
codex.json          # Index of sources for Codex
codex_prompt.md     # Main prompt for Codex
setup.sh            # Automated initialization script
vendor-repos.txt    # Additional framework repositories
template-repos.txt  # Additional templates with instructions
apps.json           # Pinned versions for Frappe and Bench
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
