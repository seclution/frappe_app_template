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
