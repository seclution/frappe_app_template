# Frappe Development Notes

* Standard-App-Struktur in `apps/`.
* Verwende `bench new-app` zum Erstellen neuer Apps.
* Lege einen DocType `<appname>_Globals` für globale Einstellungen an.
* Registriere Events und Scheduler-Tasks über `hooks.py`.
* Exportiere Custom Fields oder Doctypes mit Fixtures via `bench export-fixtures`.
* API-Aufrufe erfolgen über Whitelist-Methoden oder die REST API.
* Weitere Details findest du in der offiziellen Frappe-Dokumentation.

Um weitere Frappe-Apps einzubinden, ergänze `vendor-repos.txt` und rufe `../setup.sh` auf.

## Prerequisites

- Empfohlen wird Python 3.10.
- Node.js und Yarn
- Redis
- MariaDB
- Installiere Bench mit `pip install frappe-bench` oder klone das [Bench](https://github.com/frappe/bench) Repository.

### Optionale Umgebungseinrichtung

- Eine virtuelle Umgebung vor der Installation anlegen und aktivieren.
- Mit `bench init <verzeichnis>` ein Bench-Verzeichnis erstellen.

### Frappe auf den neuesten Stable-Tag aktualisieren

1. Wechsle in dein Bench-Verzeichnis.
2. Führe `bench switch-to-branch version-<x.x.x> frappe --upgrade` aus.
3. Danach `bench update --patch` ausführen.
