# 🚀 Frappe App Template (Codex-enabled)

This repository acts as the base for building custom Frappe apps with **Codex**.  
It supports modular development via `app-templates`, automatic prompt generation, and reusable instructions for efficient Frappe-based development.

Use this template as a Git submodule in your own project. Development guidelines live in `instructions/`, while this `README` focuses on the manual and Codex-integrated setup.

---

## 📦 Directory Layout

```
app/                # Custom app code
vendor/             # Vendor apps and templates (added via templates.txt)
instructions/       # All Codex instructions (core + per-template)
sample_data/        # Example data payloads
scripts/            # Project management scripts
.github/workflows/  # GitHub automation
setup.sh            # Bootstrap script (run once after adding submodule)
custom_vendors.json # Optional vendor definitions (for clone-vendors)
templates.txt       # Template repo list (for clone-templates)
apps.json           # Generated list of all vendor apps
codex.json          # Index of active templates (Codex references this)
```

---

## ⚡ Quick Start (Terminal)

1. **Create your project repository**
   ```bash
   git init my-app
   cd my-app
   ```

2. **Add this template as submodule and run the setup**
   ```bash
   git submodule add https://github.com/<your-org>/frappe_app_template
   cd frappe_app_template && ./setup.sh && cd ..
   ```

3. **Adjust the configuration**
   - `templates.txt`: Add app templates (see below)
   - `custom_vendors.json`: Add external Frappe apps (e.g. ERPNext)
   - `apps.json`: Will be auto-generated

4. **Commit your setup**
   ```bash
   git add .
   git commit -m "chore: initial Codex setup"
   ```

5. **Create the GitHub repository**
   ```bash
   gh repo create my-org/my-app --private --source=. --remote=origin
   ```

6. **Enable workflow permissions**
   - Go to **GitHub → Settings → Actions → General**
   - Set **Workflow permissions** to **Read and write**

7. **Push and initialize**
   ```bash
   git push -u origin HEAD
   ```

   GitHub will trigger the following workflows:
   - `init_new_app_repo`
   - `clone-templates`
   - `clone-vendors`
   - `create-app-folder`
   - `publish`

---

## Using Template Instructions

When you list template repositories in `templates.txt`, each one brings its own set of development instructions.

These are automatically copied into:

```
instructions/_<template-name>/
```

You can now build Frappe apps by simply prompting Codex, e.g.:

> “Build a Frappe app with a website that stores customer project data in ERPNext.”

Codex will automatically:
- detect relevant templates by keyword (`website`, `erpnext`)
- find matching instructions in `_core/`, `_erpnext-website-template/`, etc.
- generate prompt sequences to scaffold your app

## 🔖 Submodules with Branch or Tag

You can define templates with a specific branch or tag:

```
https://github.com/example/template-a@main
https://github.com/example/template-b@v1.0.2
```

When cloned, each submodule will:
- point to the given branch/tag
- appear in `.gitmodules` under `vendor/<name>`
- check out the correct revision using `git submodule update --remote`

---

## 🪄 Prompting Codex (with Instructions)

Once the setup is complete, you can start using Codex to generate app scaffolding and logic.

Here’s how it works:

1. Codex scans the `instructions/` folder for:
   - `_core/` → your global instructions (never deleted)
   - `_template-name/` → from each submodule
2. Based on your prompt, it matches keywords (e.g. `frappe app`, `website`, `erpnext`)
3. Codex finds corresponding prompt examples inside `instructions/_*/prompts/`
4. Codex builds and executes prompt chains automatically

### 💬 Example

> “Create a Frappe app with a website that records customer projects and syncs them to ERPNext.”

This will trigger:
- `_core/` → for general app setup
- `_erpnext-template/` → for ERP integration
- `_erpnext-website-template/` → for webform generation

---

## 🔁 Managing Templates

### Add a Template

1. Add its repo URL to `templates.txt`
2. Run:
   ```bash
   ./scripts/clone_templates.sh
   ```
3. This will:
   - Clone the repo into `vendor/<name>/`
   - Copy its `instructions/` to `instructions/_<name>/`
   - Add the template to `codex.json.templates[]`

### Remove a Template

Run:
```bash
./scripts/remove_template.sh <template-name>
```

This will:
- Remove the submodule
- Delete its `instructions/_<template-name>/`
- Update `codex.json`

---

## ✅ Testing

This project supports automated testing using `pytest`. After cloning:

```bash
pip install -r requirements-dev.txt
pytest
```

Test coverage includes:
- JSON logic (e.g. codex.json validation)
- Template operations (cloning & removing)
- Bash scripts via subprocess

CI is integrated using GitHub Actions (`.github/workflows/test.yml`)

---

## 🛠️ Development with Codex

Codex can now generate:

- Doctypes
- Hooks
- REST endpoints
- Webforms
- Pages
- ERP integrations
- GitHub workflows
- Prompts for deployment logic

All based on the contents of `instructions/_*/prompts/`.

To contribute more prompts, simply add them to:
```
vendor/<template>/instructions/prompts/*.md
```

They will be picked up automatically on the next sync.

---

## ✅ Final Notes

- `instructions/_core/` must never be deleted. It contains essential instructions.
- All other `instructions/_<template>/` folders are dynamic and come from templates.
- The `setup.sh` script ensures everything is wired up correctly after cloning the template.

Happy prompting!
