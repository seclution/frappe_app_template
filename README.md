# Frappe App Template

This repository acts as the base for building custom Frappe apps with **Codex**.  It is meant to be used as a Git submodule inside your own project.  All automation logic for Codex lives in `DEV_INSTRUCTIONS.md` while this README explains the manual steps.

## Getting Started

1. **Create a new repository** for your app and initialise it locally.
2. **Add this template as a submodule**:
   ```bash
   git submodule add https://github.com/seclution/frappe_app_template template
   ```
3. **Run the setup script** inside the submodule:
   ```bash
   cd template
   ./setup.sh
   cd ..
   ```
   The script copies the available GitHub workflows to your repository root and creates two configuration files with commented examples:
   - `custom_vendors.json`
   - `templates.txt`
4. **Edit the configuration** files if needed:
   - `templates.txt` lists additional template repositories.
   - `custom_vendors.json` can reference vendor apps directly.
   - Adjust Frappe or Bench versions in `apps.json` if required.
   - Place optional payloads under `sample_data/`.
5. **Commit everything** and push the repository to GitHub.

## Workflows

The following GitHub workflows orchestrate the environment after pushing:

- **clone-templates** – clones or updates all template repositories defined in `templates.txt`.
- **clone-vendors** – pulls vendor apps from each template `apps.json` and from `custom_vendors.json`. It generates a consolidated `apps.json` in your repo root.
- **create-app-repo** – creates the app structure without Bench. The workflow mimics `bench new-app`, writes the used framework versions and requirements into an app README and then removes that file after confirmation.
- **publish** – prepares a clean `published` branch by removing development artifacts (`.git*`, `template*`, `vendor/`, `apps.json`, `DEV_INSTRUCTIONS.md`, `custom_vendors.json`). Use this branch to distribute the final app.

After the **publish** workflow you can clone the `published` branch to install and test the app in a standard Frappe environment.

## Directory Layout

```
apps/               # Custom apps
vendor/             # Vendor apps and templates
instructions/       # Development notes
codex.json          # Index for Codex
custom_vendors.json # Optional vendor definitions
templates.txt       # Optional template list
sample_data/        # Example payloads
apps.json           # Generated list of all vendor apps
```

For framework specific hints see the files in `instructions/`. Execute the tests with `pytest -q` whenever you update the environment.
