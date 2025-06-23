# Developer Instructions for Codex

This repository uses Codex for automated code generation. These guidelines tell Codex how to work with the project.

## Setup

1. Versions for Frappe and Bench are defined in `apps.json`. Add additional
   framework repositories to `vendor-repos.txt`.
2. List additional template repositories in `templates.txt`. Their
    instructions, any `vendor-repos.txt` files and potential `apps.json`
    definitions are merged automatically.
3. The *Update Vendor Apps* workflow clones all repositories from the merged
    lists and regenerates `codex.json`. Run `./setup.sh` locally for the same
    effect (requires `jq`).
4. The CI workflow executes the same script on every push.
5. Example payloads or external API docs belong in `sample_data/`.

## Repository Layout

- `apps/` – custom apps created in this project.
- `vendor/` – Frappe and other vendor apps managed as submodules.
- `instructions/` – framework notes for Frappe and ERPNext.
- `sample_data/` – reference payloads and docs.
- `vendor-repos.txt` – list of framework repositories.
- `templates.txt` – list of additional template repositories.
- `apps.json` – default vendor apps and their versions.

## Testing

Install dependencies from `requirements.txt` and run `pytest -q`.

```bash
pip install -r requirements.txt
pytest -q
```
