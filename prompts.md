# Prompt Sequence

Diese Beispiel-Promptabfolge kannst du nutzen, um dein Projekt mit Codex zu initialisieren und schrittweise auszubauen.

---

## Prompt 1: Grundkonfiguration

"Ich möchte eine ERPNext-Erweiterung entwickeln. Bitte klone die folgenden Repos und generiere das Grundgerüst."

```
Repos:
- https://github.com/frappe/erpnext
- https://github.com/xyz/hrms
```

Codex führt `setup.sh` aus, um die Verzeichnisse und `codex.json` zu erzeugen.

---

## Prompt 2: App Scaffold

"Erzeuge in `apps/my_custom_app` ein Grundgerüst für eine Frappe App mit DocType `Project` und einfachem List View."

Codex legt entsprechende Dateien in der App an.

---

## Prompt 3: Erweiterung

"Füge einen Server-Side Scripting Hook hinzu, der bei `on_submit` einer Sales Invoice ausgeführt wird." 

Codex aktualisiert die `hooks.py` und erstellt eine neue Python-Funktion unter `apps/my_custom_app/my_custom_app/sales_invoice.py`.

---

Diese Schritte lassen sich beliebig fortführen, um weitere Doctypes, REST-Endpoints oder Integrationen aufzubauen.

---

## Prompt 4: Submodule Setup

"Initialisiere das Template mit Frappe und Bench als Git-Submodule. Führe die entsprechenden `git submodule add` Befehle aus."

Codex bindet beide Repositories als Submodule ein und aktualisiert `.gitmodules`.

---

## Prompt 5: Zusätzliche App-Templates

"Füge die folgenden app-template Repositories als Submodule hinzu."

```
Repos:
- https://github.com/example/app-template-a
- https://github.com/example/app-template-b
```

Codex legt die Submodule unter `apps/` an.

---

## Prompt 6: Frappe aktualisieren

"Aktualisiere das Frappe-Submodule auf eine neuere Version."

Codex führt `git submodule update --remote apps/frappe` aus und commitet die Änderungen.

---

## Prompt 7: Frappe-only Initialisierung

"Starte das Projekt ausschließlich mit Frappe. Entferne ERPNext aus `vendor-repos.txt`, behalte Frappe und Bench, und führe `./setup.sh` aus."

Codex aktualisiert `vendor-repos.txt`, klont nur Frappe und Bench und erzeugt eine neue `codex.json`.

---

## Prompt 8: ERPNext nachträglich hinzufügen

"Füge ERPNext jetzt hinzu. Trage `https://github.com/frappe/erpnext` in `vendor-repos.txt` ein und rufe erneut `./setup.sh` auf."

Codex modifiziert `vendor-repos.txt`, klont ERPNext unter `vendor/` und aktualisiert `codex.json`.

---

## Prompt 9: Weitere App-Templates integrieren

"Erweitere das Projekt mit diesen App-Templates. Trage sie in `vendor-repos.txt` ein und starte danach `./setup.sh` neu."

```
Repos:
- https://github.com/example/app-template-c
- https://github.com/example/app-template-d
```

Codex ergänzt `vendor-repos.txt`, führt `setup.sh` erneut aus und holt die neuen Repositories nach `vendor/`.
