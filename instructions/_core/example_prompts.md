# Example Prompt Sequence


Use these prompts to set up and extend a Frappe project with the automation agent. Replace URLs and app names to fit your own repository.


---

## Prompt 1: Initialise Repositories

"Clone Frappe and Bench using the versions from `apps.json`. Afterwards run `setup.sh`."

The agent runs the update-vendors workflow or executes the script locally to generate `vendor/` and an updated `apps.json`.

---

## Prompt 2: Scaffold a Custom App

"Create `app/my_new_app` with a basic DocType named `Project` and include a README."

The agent creates the Frappe app structure inside `app/` and commits the new files.

---

## Prompt 3: Add Business Logic

"Hook into the `on_submit` event of `Sales Invoice` and send a notification." 

The agent updates `hooks.py` and adds the corresponding Python code under the app module.

---

## Prompt 4: Manage Submodules

"Add `erpnext` to `vendors.txt` and trigger the update-vendors workflow."

The agent adds the submodule under `vendor/` and refreshes the configuration.

---

## Prompt 5: Update Frappe

"Pull the latest stable Frappe tag and commit the submodule update." 

The agent executes `git submodule update --remote vendor/frappe` and commits the change.
