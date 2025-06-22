# Prompt Sequence

Diese Beispiel-Promptabfolge zeigt, wie du mit Codex ein ERPNext-Projekt auf Basis des Frappe-App-Templates aufsetzt.

---

## Prompt 1: Grundkonfiguration

"Bitte füge das Repository `erpnext_app_template` als Submodul hinzu und führe das Update-Vendor-Apps-Workflow im Frappe-Template aus."

Codex führt `setup.sh` des Frappe-Templates aus und generiert `codex.json`.

---

## Prompt 2: App Scaffold

"Lege in `apps/my_custom_app` ein Grundgerüst für ein ERPNext-Modul an."

Codex erstellt die Verzeichnisse und eine Beispiel-DocType.

---

## Prompt 3: Erweiterung

"Füge einen Hook hinzu, der bei `on_submit` einer Sales Invoice ausgeführt wird."

Codex passt `hooks.py` und die zugehörige Python-Datei an.

---
