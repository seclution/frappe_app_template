# 📚 Agent Instructions System

Dies ist die zentrale, nie löschbare Anleitungsbasis für agent-gestützte Entwicklung.

## Funktionsweise

- Jedes App-Template enthält ein eigenes `instructions/`-Verzeichnis
- Beim Clonen eines Templates (siehe `vendors.txt`) werden diese nach `instructions/_<slug>/` kopiert
- Beim Entfernen eines Templates wird auch `instructions/_<template-name>/` gelöscht

## Ziel

Anhand dieser Anleitungen kann der Agent automatisch passende Prompt-Ketten generieren, z. B.:

> „Erstelle eine App mit Website zur Eingabe von Projektdaten, die in ERPNext gespeichert werden“

→ Erkennt Schlüsselwörter (`website`, `erpnext`)
→ nutzt passende Inhalte aus:
`_core/`, `_erpnext-website-template/`, `_erpnext-template/`

## Beispielstruktur

```
instructions/
├── _core/                     # Zentrale Hinweise (nie löschen)
├── _erpnext-template/        # Von Template eingebracht
├── _erpnext-website-template/
│   ├── 00_overview.md
│   └── prompts/
│       ├── generate_webform.md
│       └── sync_with_erpnext.md
```

Diese Dateien werden später vom Agent ausgelesen, um automatisch die passenden Entwicklungs-Prompts zu generieren.

Weitere Hinweise zur Verwaltung des Repositorys findest du in [repo_mgmt.md](repo_mgmt.md).
