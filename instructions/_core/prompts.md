# Prompt Sequence

Diese Beispiel-Promptabfolge kannst du nutzen, um dein Projekt mit dem Agenten zu initialisieren und schrittweise auszubauen.

---

## Prompt 1: Grundkonfiguration

"Ich möchte eine ERPNext-Erweiterung entwickeln. Bitte klone die folgenden Repos und generiere das Grundgerüst."

```
Repos:
- https://github.com/frappe/erpnext
- https://github.com/xyz/hrms
```

Der Agent führt `setup.sh` aus, um die Verzeichnisse und `apps.json` zu erzeugen.
In GitHub steht dafür das Workflow **update-vendors** bereit.

---

## Prompt 2: App Scaffold

"Erzeuge in `app/my_custom_app` ein Grundgerüst für eine Frappe App mit DocType `Project` und einfachem List View."

Der Agent legt entsprechende Dateien in der App an.

---

## Prompt 3: Erweiterung

"Füge einen Server-Side Scripting Hook hinzu, der bei `on_submit` einer Sales Invoice ausgeführt wird." 

Der Agent aktualisiert die `hooks.py` und erstellt eine neue Python-Funktion unter `app/my_custom_app/my_custom_app/sales_invoice.py`.

---

Diese Schritte lassen sich beliebig fortführen, um weitere Doctypes, REST-Endpoints oder Integrationen aufzubauen.

---

## Prompt 4: Submodule Setup

"Initialisiere das Template mit Frappe und Bench als Git-Submodule. Führe die entsprechenden `git submodule add` Befehle aus."

Der Agent bindet beide Repositories als Submodule ein und aktualisiert `.gitmodules`.

---

## Prompt 5: Zusätzliche App-Templates

"Füge die folgenden app-template Repositories als Submodule hinzu."

```
Repos:
- https://github.com/example/app-template-a
- https://github.com/example/app-template-b
```

Der Agent legt die Submodule unter `vendor/` an.

---

## Prompt 6: Frappe aktualisieren

"Aktualisiere das Frappe-Submodule auf eine neuere Version."

Der Agent führt `git submodule update --remote vendor/frappe` aus und commitet die Änderungen.

---

## Prompt 7: Frappe-only Initialisierung

"Starte das Projekt ausschließlich mit Frappe. Entferne ERPNext aus `vendors.txt`, behalte Frappe und Bench und führe `./setup.sh` aus oder triggere das Workflow **update-vendors**."

Der Agent aktualisiert `vendors.txt`, klont nur Frappe und Bench und erzeugt eine neue `apps.json`.

---

## Prompt 8: ERPNext nachträglich hinzufügen

"Füge ERPNext jetzt hinzu. Trage `erpnext` in `vendors.txt` ein und rufe erneut `./setup.sh` auf oder starte das Workflow **update-vendors**."

Der Agent modifiziert `vendors.txt`, klont ERPNext unter `vendor/` und aktualisiert `apps.json`.

---

## Prompt 9: Weitere App-Templates integrieren

"Erweitere das Projekt mit diesen App-Templates. Trage sie in `vendors.txt` ein und starte danach `./setup.sh` neu oder triggere das Workflow **update-vendors**."

```
Repos:
- https://github.com/example/app-template-c
- https://github.com/example/app-template-d
```

Der Agent ergänzt `vendors.txt`, führt `setup.sh` erneut aus und holt die neuen Repositories nach `vendor/`.

---

## Prompt 10: GitHub Workflows prüfen

"Nach dem ersten Push an GitHub ist `publish` nicht gelaufen. Überprüfe, ob der Branch `develop` heißt und die Workflow-Rechte auf **Read and write** stehen. Das App-Verzeichnis wird jetzt bereits lokal durch `setup.sh` erzeugt."

Der Agent stellt sicher, dass auf `develop` gepusht wurde und weist darauf hin, die Berechtigungen unter *Settings → Actions → General* zu aktivieren.
