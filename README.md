
# Frappe App Template

This repository is a starting point for developing custom **Frappe** or **ERPNext**
applications. It bootstraps a local development environment, clones optional
vendor apps and prepares a basic `codex.json` index for use with Codex.

## Quickstart

1. Clone this repository.
2. Edit `vendor-repos.txt` to list the Frappe/ERPNext apps you want cloned.
3. Run `./setup.sh` from the repository root. It clones the apps listed in
   `vendor-repos.txt` and generates `codex.json` referencing `apps/`,
   `vendor/frappe/`, `vendor/bench/` and `instructions/`.
4. Review `init_codex_prompt.md` for the initial prompt used by Codex.

## Adding Vendor Apps

Each line in `vendor-repos.txt` should contain the HTTPS URL of a Frappe or
ERPNext app repository. Re-run `./setup.sh` whenever you change this file to
fetch the new apps.

## Repository Layout

```
apps/               # Your custom app lives here
vendor/             # Frappe, ERPNext and other apps (cloned or as submodules)
instructions/       # Development guides
codex.json          # Index of sources for Codex
codex_prompt.md     # Main prompt for Codex
setup.sh            # Automated initialization script
```

## Further References

More information is available in the `instructions/` folder:

- [`instructions/frappe.md`](instructions/frappe.md) – details on installing
  Bench, creating new apps, definieren eines `<appname>_Globals` Doctypes sowie
  den Einsatz von Hooks, Fixtures und API-Aufrufen.
- [`instructions/erpnext.md`](instructions/erpnext.md) – Tipps zum Erweitern
  von ERPNext-Modulen, Registrieren eigener Hooks und Exportieren von
  Customizations.
