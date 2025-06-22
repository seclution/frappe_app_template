# Developer Instructions for Codex

This repository uses Codex for automated code generation. These guidelines tell Codex how to work with the project.

## Setup

1. Frappe and Bench are pinned via `apps.json`. Add further framework
   repositories such as ERPNext or HRMS to `vendor-repos.txt`.
2. List additional template repositories in `template-repos.txt`. Their
   instructions will be merged into `codex.json` automatically.
3. The *Update Vendor Apps* workflow clones all repositories from both lists and
   regenerates `codex.json`. Run `./setup.sh` locally for the same effect
   (requires `jq`).
4. The CI workflow executes the same script on every push.
5. Example payloads or external API docs belong in `sample_data/`.

## Repository Layout

- `apps/` – custom apps created in this project.
- `vendor/` – Frappe and other vendor apps managed as submodules.
- `instructions/` – framework notes for Frappe and ERPNext.
- `sample_data/` – reference payloads and docs.
- `vendor-repos.txt` – additional framework repositories to clone.
- `template-repos.txt` – list of additional template repositories.

## Testing

Install dependencies from `requirements.txt` and run `pytest -q`.

```bash
pip install -r requirements.txt
pytest -q
```
