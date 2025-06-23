# Developer Instructions for Codex

This repository uses Codex for automated code generation. These guidelines tell Codex how to work with the project.

## Setup

1. Versions for Frappe and Bench are defined in `apps.json`. Add optional
   vendor repositories to `custom_vendors.json`.
2. List additional template repositories in `templates.txt`. Their
    instructions, any `custom_vendors.json` files and potential `apps.json`
    definitions are merged automatically.
3. The *clone-vendors* workflow clones all repositories from the merged
    lists and regenerates `apps.json`. Run `./setup.sh` locally for the same
    effect (requires `jq`).
4. The CI workflow only installs dependencies and runs tests. It no longer
   runs `./setup.sh` automatically.
5. Example payloads or external API docs belong in `sample_data/`.

## Repository Layout

- `apps/` – custom apps created in this project.
- `vendor/` – Frappe and other vendor apps managed as submodules.
- `instructions/` – framework notes for Frappe and ERPNext.
- `sample_data/` – reference payloads and docs.
- `custom_vendors.json` – additional vendor repositories.
- `templates.txt` – list of additional template repositories.
- `apps.json` – default vendor apps and their versions.
