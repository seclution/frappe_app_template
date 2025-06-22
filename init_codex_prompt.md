# Codex Setup Options

Select the environment you want to initialize:

1. **Frappe-only app** – build a standalone app using the Frappe framework.
2. **ERPNext extension** – create a custom app that extends ERPNext.
3. **Multi-app setup** – ERPNext together with additional apps.

If you need vendor repositories, mention them in your prompt. Example:

```
ERPNext extension.
Repos:
- https://github.com/frappe/erpnext
- https://github.com/example/hrms
```

Codex will clone the listed repositories into `vendor/` and update `codex.json` automatically.
