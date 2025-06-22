# Codex Prompt

The following guidelines help keep custom apps consistent:

- **App location**: place each app under `apps/<appname>`.
- **Required content**: every app must include a README and a DocType named `<appname>_Globals`.
- **Documentation**: reference the notes in the `instructions/` directory for Frappe and ERPNext specifics.
- **Vendor submodules**: Add Frappe and any other framework apps under `vendor/`. The update workflow merges `vendor-repos.txt` from all templates automatically.
