# ERPNext Development Notes

* Diese App erweitert ERPNext und sollte in einer Bench-Umgebung installiert sein.
* Lege eigene Module unter `apps/my_custom_app` an und verbinde sie über Hooks.
* Nutze die bestehenden ERPNext-Doctypes wie `Sales Invoice` oder `Customer` als Vorlage für eigene Erweiterungen.
* Exportiere Customizations mit Fixtures, damit sie versionskontrolliert bleiben.
* Über `hooks.py` kannst du Events wie `on_submit` abfangen und zusätzliche Logik implementieren.
* Eigene REST-API-Endpunkte lassen sich über Whitelist-Methoden bereitstellen.
* Für tiefergehende Anpassungen siehe die ERPNext-Dokumentation.

Binde das ERPNext-Template als Submodul ein. Das Update-Vendor-Apps-Workflow sammelt dessen `vendor-repos.txt` ein und klont ERPNext automatisch.
