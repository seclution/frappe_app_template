# Developer Instructions for Codex

This repository acts as a template for ERPNext extensions and is usually combined with the Frappe app template. Codex follows these rules when working with the project.

## Setup

1. Include this repository as a submodule of the Frappe template.
2. Optional template repositories can be added to `template-repos.txt`.
3. Set the desired ERPNext tag in `apps.json`.
4. Trigger the **Update Vendor Apps** workflow in the Frappe template (or run `./setup.sh` there) to fetch ERPNext and rebuild `codex.json`.
5. The CI workflow in this repo executes the same script on each push.
6. Place reference payloads or API docs in `sample_data/`.

## Repository Layout

- `apps/` – custom ERPNext apps created in this project.
- `instructions/` – ERPNext development notes.
- `sample_data/` – example payloads and docs.
- `template-repos.txt` – list of additional templates.
- `apps.json` – ERPNext repository and tag.

## Testing

Install the dependencies from `requirements.txt` and run:

```bash
pip install -r requirements.txt
pytest -q
```
