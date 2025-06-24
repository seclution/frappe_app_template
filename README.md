# Frappe App Template

This repository acts as the base for building custom Frappe apps with **Codex**.  It is meant to be used as a Git submodule inside your own project.  All automation logic for Codex lives in `DEV_INSTRUCTIONS.md` while this README explains the manual steps.

## Getting Started

1. **Create a new repository** for your app and initialise it locally:
   ```bash
   git init <appname>
   cd <appname>
   # optional: create and push a remote repository
   # gh repo create <user>/<appname> --private --source=. --remote=origin --push
   ```
2. **Add this template as a submodule**:
   ```bash
   git submodule add https://github.com/seclution/frappe_app_template frappe_app_template
   ```
3. **Run the setup script** inside the submodule:
   ```bash
   cd template
   ./setup.sh
   cd ..
   ```
   The script copies the available GitHub workflows, the `requirements.txt` file and the entire `scripts/` directory to your repository root. It also creates three configuration files with commented examples:
   - `custom_vendors.json`
   - `templates.txt`
   - `codex.json`
   - `scripts/sync_templates.sh` – synchronises template repositories as Git submodules

4. **Edit the configuration** files if needed:
   - `templates.txt` lists additional template repositories.
   - `custom_vendors.json` can reference vendor apps directly.
   - Adjust Frappe or Bench versions in `apps.json` if required.
   - Place optional payloads under `sample_data/`.
   When you include templates, look at their `DEV_INSTRUCTIONS.md` files and
   combine those notes with this repository's instructions.
5. **Synchronise template repositories as submodules** if you added any URLs to `templates.txt`:
   ```bash
   ./scripts/sync_templates.sh

   ```
6. **Commit everything** and push the repository to GitHub.
   ```bash
   git add .
   git commit -m "Initial setup"
   git push -u origin main
   ```

## Workflows

The following GitHub workflows orchestrate the environment after pushing:

- **clone-templates** – clones or updates all template repositories defined in `templates.txt`.
- **clone-vendors** – pulls vendor apps from each template `apps.json` and from `custom_vendors.json`. It generates a consolidated `apps.json` in your repo root.
- **update-vendor** – refreshes vendor apps on a schedule or when configuration files change.
- **create-app-repo** – scaffolds a new app without using Bench. It records the framework versions and requirements in a temporary README and deletes itself after completion so the workflow can only run once.
- **publish** – prepares a clean `published` branch by removing development artifacts (`.git*`, `template*`, `vendor/`, `apps.json`, `DEV_INSTRUCTIONS.md`, `custom_vendors.json`) and all submodule metadata. The workflow removes any remaining template directories such as `frappe_app_template` or `erpnext_app_template` and deletes submodule folders listed in `.gitmodules` before purging the metadata. Use this branch to distribute the final app.

After the **publish** workflow you can clone the `published` branch to install the app in a standard Frappe environment.

## Directory Layout

```
apps/               # Custom apps
vendor/             # Vendor apps and templates
template_frappe/    # optional base template for Frappe
template_erpnext/   # optional ERPNext template
instructions/       # Development notes
codex.json          # Index for Codex
custom_vendors.json # Optional vendor definitions
templates.txt       # Optional template list
sample_data/        # Example payloads
apps.json           # Generated list of all vendor apps
```

For framework specific hints see the files in `instructions/`.
