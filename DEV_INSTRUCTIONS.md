# Developer Instructions for Codex

This repository uses Codex for automated code generation. These guidelines tell Codex how to work with the project.

## Setup

1. Add any vendor repositories to `vendor-repos.txt`.
2. The *Update Vendor Apps* workflow clones vendor apps and regenerates
   `codex.json`. Run `./setup.sh` locally for the same effect.
3. The CI workflow executes the same script on every push.
4. Example payloads or external API docs belong in `sample_data/`.

## Repository Layout

- `apps/` – custom apps created in this project.
- `vendor/` – Frappe and other vendor apps managed as submodules.
- `instructions/` – framework notes for Frappe and ERPNext.
- `sample_data/` – reference payloads and docs.

## Testing

Install dependencies from `requirements.txt` and run `pytest -q`.

```bash
pip install -r requirements.txt
pytest -q
```
