# Example Prompt Sequence

Use these prompts to set up and extend a Frappe project with Codex. Replace URLs and app names to fit your own repository.

---

## Prompt 1: Initialise Repositories

"Clone Frappe and Bench using the versions from `apps.json`. Afterwards run `setup.sh`."

Codex runs the update-vendors workflow or executes the script locally to generate `vendor/` and an updated `apps.json`.

---

## Prompt 2: Scaffold a Custom App

"Create `app/my_new_app` with a basic DocType named `Project` and include a README."

Codex creates the Frappe app structure inside `app/` and commits the new files.

---

## Prompt 3: Add Business Logic

"Hook into the `on_submit` event of `Sales Invoice` and send a notification." 

Codex updates `hooks.py` and adds the corresponding Python code under the app module.

---

## Prompt 4: Manage Submodules

"Add `erpnext` to `vendors.txt` and trigger the update-vendors workflow."

Codex adds the submodule under `vendor/` and refreshes the configuration.

---

## Prompt 5: Update Frappe

"Pull the latest stable Frappe tag and commit the submodule update." 

Codex executes `git submodule update --remote vendor/frappe` and commits the change.
