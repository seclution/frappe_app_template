# App Skeleton

This folder hosts the Frappe app generated from this template. A minimal setup created via `bench new-app` should include:

- `app_name/__init__.py` with a version string
- `modules.txt` listing the module name
- `hooks.py` defining hooks and metadata
- a DocType named `<appname>_Globals` for global settings

## Running the app

1. Initialize a bench and create a site:
   ```bash
   bench init frappe-bench
   cd frappe-bench
   bench new-site mysite.local
   bench get-app ..
   bench --site mysite.local install-app app_name
   bench start
   ```

For a complete project setup and vendor management steps see the [root README](../README.md).
