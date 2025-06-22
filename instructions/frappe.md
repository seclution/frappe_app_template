# Frappe Development Notes

- Standard App Struktur in `apps/`
- Verwende `bench new-app` zum Erstellen neuer Apps
- Siehe die Frappe Dokumentation für Details zu DocTypes, Hooks und REST API

## Prerequisites

- Python 3.10 oder neuer
- Node.js und Yarn
- Redis
- MariaDB
- Installiere `bench` entweder mit `pip install frappe-bench` oder durch Klonen des [Bench](https://github.com/frappe/bench) Repositorys

### Optionale Umgebungseinrichtung

- Eine virtuelle Umgebung vor der Installation anlegen und aktivieren
- Mit `bench init <verzeichnis>` ein Bench-Verzeichnis erstellen

### Frappe auf den neuesten Stable-Tag aktualisieren

1. Wechsle in dein Bench-Verzeichnis
2. Führe `bench switch-to-branch version-<x.x.x> frappe --upgrade` aus
3. Danach `bench update --patch` ausführen

