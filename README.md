# 🚀 Frappe App Template (Codex-Optimiert)

Dieses Repository ist das **zentrale Master-Template** zur Entwicklung Codex-unterstützter Frappe-Apps. Es beinhaltet alle Werkzeuge, Strukturen, Konventionen und Workflows, um neue Projekte effizient aufzusetzen, kontextoptimiert mit OpenAI Codex zu entwickeln und gezielt externe Inhalte (z. B. ERPNext) einzubinden.

## 📂 Strukturtyp

Dies ist ein **`template_base`**-Repository.

* Es wird **nicht selbst gepublished** (`publish_enabled: false`)
* Dient als Submodul in App-Repos
* Enthält: Setup-Tools, Referenz-App, globale Instructions, Indexing-Mechanismen, Workflow-Templates

## 📁 Projektstruktur

```plaintext
frappe_app_template/
├── app/
│   └── frappe_template_core/           # Referenz-App: UI, Doctypes, Layouts etc.
│
├── instructions/
│   └── _core/                          # zentrale Codex-Anleitungen (niemals löschen)
│       ├── frappe.md
│       ├── erpnext.md
│       ├── prompts.md
│       └── ...
│
├── scripts/                            # Setup- & Sync-Werkzeuge
│   ├── bootstrap_project.sh            # initialisiert neues App-Repo
│   ├── update_vendors.sh               # synchronisiert vendors.txt → apps.json → Submodule
│   ├── update_templates.sh
│   └── ...
│
├── vendor_profiles/                    # zentrale Vendordefinitionen (z. B. erpnext, raven)
│   └── integration_profiles.json       # Zuordnung von Slug → Git-URL + Tag/Branch
│
├── sample_data/
│   └── example_payload.json
│
├── tests/
│   └── test_update_templates.py
│
├── workflow_templates/
│   ├── init_new_app_repo.yml
│   ├── publish.yml
│   ├── create-app-folder.yml
│   └── ...
│
├── .github/
│   ├── workflows/
│   │   ├── generate_codex_index.yml
│   │   ├── validate_commits.yml
│   │   └── ci.yml
│   └── workflows_readme/
│       └── template_maintenance/
│
├── .incoming/                          # Snapshots von Codex-Wissen aus App-Repos
│   └── codex_snapshots/
│       └── my_app.json
│
├── setup.sh
├── requirements.txt
├── requirements-dev.txt
├── apps.json                           # generiert: enth. aktive Submodule/Vendoren
├── codex.json                          # Codex-Datei-Index (autogeneriert)
├── .codex_gitlog.json                  # Commit-Historie mit #codex:-Tags
├── vendors.txt                         # aktive Vendor-Slugs (z. B. erpnext, website)
├── project_meta.yml                    # Steuerung des Repo-Typs etc.
└── README.md
```

## 📜 `project_meta.yml`

```yaml
repo_type: template_base
publish_enabled: false
codex_tracked: true
```

Alle Workflows orientieren sich an dieser Datei. Templates werden niemals gepublished.

## 💡 Codex-Prinzipien

* Nur **ein Git-Repo** als aktiver Kontext
* Externe Tools (ERPNext, Raven ...) werden als Submodule in `vendor/` eingebunden
* Zu jedem Submodul gibt es begleitende Anleitungen in `instructions/_<slug>/`
* Codex liest aus: `instructions/`, `vendor/`, `app/`, relevante `scripts/` & Workflows

## 🔄 Submodule & Versionierung

Die Datei `integration_profiles.json` definiert zentralseitig:

```json
{
  "erpnext": {
    "url": "https://github.com/frappe/erpnext.git",
    "branch": "version-15"
  },
  "raven": {
    "url": "https://github.com/myorg/raven.git",
    "branch": "main"
  }
}
```

Diese Daten werden verwendet, um bei neuen App-Repos Submodule korrekt einzurichten.

## 🔁 Wissen aus App-Repos zurückführen

App-Repos können neue Erkenntnisse lokal ablegen:

```json
codex_feedback.json
{
  "vendor": "erpnext",
  "context_improvement": [
    {
      "file": "instructions/_erpnext/project_logic.md",
      "comment": "Beispiel für ERP-Modulstruktur ergänzt"
    }
  ]
}
```

Ein Cronjob oder CI-Sync-Skript überträgt regelmäßig Inhalte aus `my_app/instructions/` und `codex.json` zurück nach `.incoming/` in dieses Repo.

## 🧰 Commit-Konventionen (Codex-optimiert)

```bash
feat(ui): Add layout hooks #codex:index
refactor(sync): simplify vendor loader #codex:infra
```

Workflows wie `validate_commits.yml` prüfen auf Einhaltung.

## 📜 Beispiel: Neues App-Repo

```bash
# Projekt initialisieren
git init -b develop my_app && cd my_app

git submodule add https://github.com/your-org/frappe_app_template
./frappe_app_template/setup.sh

nano vendors.txt
# z. B. erpnext, website
./scripts/update_vendors.sh

# Pushen
git add . && git commit -m "chore: setup"
git remote add origin ... && git push -u origin develop
```

## ✨ Fazit

Dieses Repository ist das zentrale Fundament zur Entwicklung modularer, wartbarer und kontextoptimierter Frappe-Projekte. Alle Submodule, Anleitungssysteme und Automatisierungen zielen auf einen sauberen Codex-Kontext ab. Neue Erkenntnisse können strukturiert in `.incoming/` zur Verfügung gestellt werden – ganz ohne Submodule pushen zu müssen.

**Dieses Template ist das Gehirn – jede App ist ein Ausdruck davon.**

**Happy prompting!**
