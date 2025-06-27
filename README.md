
This repository acts as the base for building custom Frappe apps with **Codex**. Use it as a Git submodule inside your own project. Development guidelines live in `DEV_INSTRUCTIONS.md` while this README focuses on the manual setup.

## Quick Start (Terminal)

1. **Create a repository**
   - Start locally:
     ```bash
     git init <appname>
     cd <appname>
     ```
   - or clone an empty repo created on GitHub:
     ```bash
     git clone https://github.com/<user>/<appname>.git
     cd <appname>
     ```
2. **Add this template as submodule and run the setup**
   ```bash
   git submodule add https://github.com/<thisRepo> frappe_app_template
   cd frappe_app_template && ./setup.sh && cd ..
   ```
   The script copies workflow files and configuration templates to your repo and creates `sample_data/` in the project root and under `/root`.
3. **Adjust the configuration** if needed:
   - `templates.txt` for additional templates.
   - `custom_vendors.json` for vendor apps. The **clone-vendors** workflow
     updates `vendor/` whenever this file, `templates.txt` or any `apps.json`
     changes.
     updates `vendor/` and regenerates `apps.json` whenever this file,
     `templates.txt` or any `apps.json` changes. Removed entries are pruned
     automatically.
   - `apps.json` to pin Frappe or Bench versions.
4. **Commit your changes**
   ```bash
   git add .
   git commit -m "chore: initial setup"
   ```

5. **Create the GitHub repository** (no push yet)
   ```bash
   gh repo create <user>/<appname> --private --source=. --remote=origin
   ```

6. **Enable workflow permissions**
   - Open the repository on GitHub.
   - Go to **Settings → Actions → General** and set **Workflow permissions** to **Read and write**.

7. **Push and initialise**
   ```bash
   git push -u origin HEAD
   ```

   GitHub automatically runs **init_new_app_repo**, which sequentially triggers **clone-templates**, **clone-vendors**, **create-app-folder** and finally **publish**. The setup script isn't executed again here—you already ran it locally. Wait for the workflow to finish before continuing.

Future commits trigger these workflows individually whenever their respective files change.

## Directory Layout

```
app/                # Custom app
vendor/             # Vendor apps and templates
instructions/       # Development notes
codex.json          # Index for Codex
custom_vendors.json # Optional vendor definitions
templates.txt       # Optional template list
sample_data/        # Example payloads
apps.json           # Generated list of all vendor apps
```

For framework specific hints see the files in `instructions/`. When the **publish** workflow runs, everything inside `app/` is moved to the root of the `published` branch.
