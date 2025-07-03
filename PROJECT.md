# Projektkonzept

## Ziel
Dieses Template liefert das Fundament für Frappe-Projekte. Es soll eine klare Struktur bieten und wiederverwendbare Workflows bereitstellen.

## Technologien
- Python
- Frappe Framework
- Bench CLI

## Prioritäten
1. Einfaches Setup neuer Apps
2. Saubere Einbindung von Vendor-Abhängigkeiten
3. Durchgängiger Agent-Kontext für alle Projekte

## Developer Guide

Diese Hinweise fassen die ehemaligen Dateien `DEV_INSTRUCTIONS.md`, `instructions/_core/DEV_GUIDE.md` und `AGENTS.md` zusammen.

### Setup

1. Die Standardversionen für Frappe und Bench liegen in `apps.json`.
2. Aktive Vendor-Slugs stehen in `vendors.txt`. Für jeden Slug existiert eine passende JSON-Datei unter `vendor_profiles/<kategorie>/<slug>.json`. Die **update-vendors**-Action oder `./setup.sh` klonen diese Repositories und aktualisieren `apps.json`.
3. Installiere die Entwickler-Abhängigkeiten und führe Tests aus:

   ```bash
   pip install -r requirements-dev.txt
   pytest
   ```

4. Beispielpayloads und externe API-Dokumente gehören in `sample_data/`.
5. Die CI-Workflows installieren nur Abhängigkeiten und starten Tests. Setup-Skripte laufen dort nicht automatisch.

### Repository Layout

- `app/` – eigene App dieses Projekts
- `vendor/` – Submodule für Frappe und andere Vendoren
- `instructions/` – zentrale Hinweise für Frappe, ERPNext und Templates
- `sample_data/` – Beispieldaten und Dokumentationen
- `vendors.txt` – aktive Vendor-Slugs
- `vendor_profiles/` – JSON-Profile der Vendoren
- `apps.json` – Liste der Vendor-Apps mit Versionen

### Zusätzliche Hinweise

- Lege deine App immer im Ordner `app/` an. Jede App enthält eine README und einen DocType `<appname>_Globals`.
- Synchronisiere Vendor-Submodule über `vendors.txt` und `scripts/update_vendors.sh`.
- Details zu Frappe und ERPNext findest du in `instructions/_core/frappe.md` und `instructions/_core/erpnext.md`. Weitere Tipps liefern `instructions/_core/submodule_usage.md` und `instructions/_core/repo_mgmt.md`.
- `instructions/_core/prompts.md` zeigt Beispiel-Prompts, um neue Apps zu starten oder zu erweitern.
- Dieses Repository dient standardmäßig als App-Template für den Agent.

### Index Generation

`scripts/generate_index.py` baut `instructions/_INDEX.md` anhand der Tags in dieser Datei und der Vendoren auf. Starte das Skript, wenn sich die Tags oder Vendors ändern.

## Tags
app-template, frappe, doctype, customization, workflow, permissions, automation, script_report, print_format, email_template, website, webpage, webform, portal, html, jinja, clientscript, frappe_ui, frappe_call, frappe_api, serverscript, api, controller, scheduler, hook, app_structure, module, git, instructions, unittest, testdata, bench, sandbox, barcode, fileupload, assets, export, print, webhook

