
# Frappe App Template

**Important:** This project keeps its documentation in two separate files. This
`README.md` is written for human developers who want to build on top of the
template with Codex. Detailed instructions for the Codex automation live in
`DEV_INSTRUCTIONS.md`.

## TL;DR – Using Codex

1. **Clone this repo** or fork it for your own project and work in a local copy.
2. **Adjust vendor versions** in `apps.json` if you need different tags for
   Frappe or Bench. Add further frameworks to `vendor-repos.txt`.
3. **Add optional template repos** to `template-repos.txt` when you want to include additional instructions. Templates may also ship an `apps.json` that pins their vendor apps.
4. **Optional sample data** for external integrations lives in `sample_data/`.
5. **Commit and push to a fresh repository** once your lists are complete.

   ```bash
   git add vendor-repos.txt template-repos.txt
   git commit -m "chore: configure vendor apps"
   git remote add origin <new-repo-url>
   git push -u origin main
   ```

6. Trigger the **Update Vendor Apps** workflow (and any *Update Template* flow)
   on GitHub to clone the repositories and generate `codex.json`. You can still
   run `./setup.sh` locally if needed (requires `jq`).
7. **Create a Codex environment** and connect it with your new repository.
8. **Start developing your app** inside this environment. The `CI` workflow
   runs the same setup and tests automatically.

This repository is a starting point for developing custom **Frappe** applications. Additional frameworks like ERPNext can be included through template repositories. It bootstraps a local development environment, clones optional vendor apps and prepares a basic `codex.json` index for use with Codex. Sample payloads or interface documentation can be stored in the `sample_data/` folder.

## Quickstart

1. Clone this repository.
2. Frappe and Bench are already included using the tags defined in `apps.json`.
   The *Update Vendor Apps* workflow clones them and rebuilds `codex.json`.
   Run `./setup.sh` locally if you want to mirror the process (requires `jq`).
3. Optional development templates can be listed in `template-repos.txt`.
    They will be cloned alongside the framework repos and their instructions are
    added to Codex automatically.
4. Template repositories may ship their own `apps.json` and `vendor-repos.txt`.
    The update workflow processes these files recursively so every required
    vendor app is cloned in the specified version automatically.
5. Review `codex_prompt.md` for the default guidelines Codex follows.
6. See [`prompts.md`](prompts.md) for instructions on adding more templates.
7. Place any example payloads or external API docs under `sample_data/` for
   reference. The directory is indexed in `codex.json` when present.

## Adding Vendor Apps

Use `git submodule add <repo> vendor/<name>` to include further Frappe apps.
After adding a repository trigger the *Update Vendor Apps* workflow or run
`./setup.sh` locally (requires `jq`). Template repositories may carry their own
`vendor-repos.txt`; the workflow merges these lists so every required app is
cloned automatically.

## Vendor Repository Types

Three files keep track of external sources:

1. `apps.json` – default vendor apps like Frappe and Bench with their tag
   versions. Template repositories may ship their own `apps.json` files to pin
   additional vendor projects.
2. `vendor-repos.txt` – additional framework repositories (e.g. ERPNext).
3. `template-repos.txt` – optional templates that include their own development
   instructions.

The update workflow clones repositories from these lists and also processes any
`apps.json` found inside the templates. All vendor apps are checked out at the
specified tag and `instructions/` folders are merged into `codex.json`. Follow
those instructions together with this document when developing your app.

## Using `apps.json`

The file `apps.json` defines the default versions for the core Frappe stack.
Each entry specifies a repository URL and the tag that will be checked out
by the update workflow. Adjust these tags when you need a newer or older
release of Frappe or Bench. Any template repositories are scanned for their own
`apps.json` files which are processed in the same way:

```json
{
  "bench": { "repo": "https://github.com/frappe/bench", "tag": "v5.2.1" },
  "frappe": { "repo": "https://github.com/frappe/frappe", "tag": "v13.3.0" }
}
```

Changing the values and re-running the **Update Vendor Apps** workflow (or
`./setup.sh`) pulls the requested versions and regenerates `codex.json`.
Only framework repositories managed through `apps.json` should be edited here;
additional Frappe apps belong in `vendor-repos.txt` or as submodules under the
`vendor/` directory.

## Repository Layout

```
apps/               # Your custom app lives here
vendor/             # Frappe apps and additional frameworks
instructions/       # Development guides
codex.json          # Index of sources for Codex
codex_prompt.md     # Main prompt for Codex
setup.sh            # Automated initialization script
vendor-repos.txt    # Framework repositories like Frappe
template-repos.txt  # Additional templates with instructions
sample_data/        # Example payloads and external API documentation
apps.json           # Default vendor apps and their versions
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
