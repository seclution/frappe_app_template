# Frappe App Template

This repository provides a starting point for developing custom Frappe or ERPNext applications.
It helps you bootstrap a development environment with optional vendor apps and a Codex index.

## Quickstart

1. Clone this repository.
2. Optionally edit `vendor-repos.txt` to list additional apps you want to clone.
3. Run `./setup.sh` to create the directory structure, clone vendor apps and generate `codex.json`.
4. Review `init_codex_prompt.md` for the initial prompt used by Codex.

## Repository Layout

```
apps/               # Your custom app lives here
vendor/             # Frappe, ERPNext and other apps (cloned or as submodules)
instructions/       # Development guides
codex.json          # Index of sources for Codex
init_codex_prompt.md# Starting prompt for Codex
setup.sh            # Automated initialization script
```

See the files in `instructions/` for framework-specific notes.
