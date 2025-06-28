# Developer Instructions for Codex

This repository uses Codex for automated code generation. These guidelines tell Codex how to work with the project.

## Setup

1. Versions for Frappe and Bench are defined in `apps.json`. Add optional
   vendor repositories to `custom_vendors.json`.
2. List additional template repositories in `templates.txt`. Their
    instructions, any `custom_vendors.json` files and potential `apps.json`
    definitions are merged automatically.
3. The *update-vendors* workflow clones all repositories from the merged
    lists and regenerates `apps.json`. Run `./setup.sh` locally for the same
    effect (requires `jq`).
4. The CI workflow only installs dependencies and runs tests. It no longer
   runs `./setup.sh` automatically.
5. Example payloads or external API docs belong in `sample_data/`.
6. If you include template repositories (such as `template_frappe` or
   `template_erpnext`), also consult their respective `DEV_INSTRUCTIONS.md`
   files. Combine those guidelines with the instructions here.

## Repository Layout

- `app/` – custom app created in this project.
- `vendor/` – Frappe and other vendor apps managed as submodules.
- `instructions/` – framework notes for Frappe and ERPNext.
- `sample_data/` – reference payloads and docs.
- `custom_vendors.json` – additional vendor repositories.
- `templates.txt` – list of additional template repositories.
- `apps.json` – default vendor apps and their versions.

## Additional Guidelines

The following tips keep all custom apps consistent:

- **App location**: place your app inside the `app/` folder.
- **Required content**: every app must include a README and a DocType named `<appname>_Globals`.
- **Documentation**: reference the notes in the `instructions/` directory for Frappe and ERPNext specifics.
- **Vendor submodules**: Add Frappe and any other framework apps under `vendor/`. The update workflow merges `custom_vendors.json` from all templates automatically.

See `instructions/prompts.md` for an example prompt sequence that explains how to initialise and extend a project with Codex.
