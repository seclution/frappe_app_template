
# Frappe App Template

**Important:** This project keeps its documentation in two separate files. This
`README.md` is written for human developers who want to build on top of the
template with Codex. Detailed instructions for the Codex automation live in
`DEV_INSTRUCTIONS.md`.

## TL;DR – Using Codex

1. **Clone this repo** or fork it for your own project and work in a local copy.
2. **Add required framework repos** (Frappe/ERPNext/HRMS) to `vendor-repos.txt`.
3. **Add optional template repos** to `template-repos.txt` when you want to
   include additional instructions.
4. **Commit and push to a fresh repository** once your lists are complete.

   ```bash
   git add vendor-repos.txt template-repos.txt
   git commit -m "chore: configure vendor apps"
   git remote add origin <new-repo-url>
   git push -u origin main
   ```

5. Trigger the **Update Vendor Apps** workflow (and any *Update Template* flow)
   on GitHub to clone the repositories and generate `codex.json`. You can still
   run `./setup.sh` locally if needed (requires `jq`).
6. **Create a Codex environment** and connect it with your new repository.
7. **Start developing your app** inside this environment. The `CI` workflow
   runs the same setup and tests automatically.
8. **Optional sample data** for external integrations lives in `sample_data/`.

This repository is a starting point for developing custom **Frappe** applications. ERPNext can be added manually if required. It bootstraps a local development environment, clones optional vendor apps and prepares a basic `codex.json` index for use with Codex. Sample payloads or interface documentation can be stored in the `sample_data/` folder.

## Quickstart

1. Clone this repository.
2. By default `vendor-repos.txt` contains only Frappe. The *Update Vendor Apps*
   workflow clones these repositories and regenerates `codex.json`. Run
   `./setup.sh` locally if you want to mirror the process (requires `jq`).
3. Optional development templates can be listed in `template-repos.txt`.
   They will be cloned alongside the framework repos and their instructions are
   added to Codex automatically.
4. To add ERPNext, append `https://github.com/frappe/erpnext` to
   `vendor-repos.txt` and trigger the workflow or run `./setup.sh` manually
   (requires `jq`).
5. Review `codex_prompt.md` for the default guidelines Codex follows.
6. See [`prompts.md`](prompts.md) for instructions on adding more templates.
7. Place any example payloads or external API docs under `sample_data/` for
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

1. `vendor-repos.txt` – reference repositories for the framework itself such as
   Frappe, ERPNext or HRMS.
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
vendor-repos.txt    # Framework repositories like Frappe
template-repos.txt  # Additional templates with instructions
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
