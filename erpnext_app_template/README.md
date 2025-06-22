# ERPNext App Template

**Important:** This template complements the Frappe app template. It contains only ERPNext specific instructions so it can be used as a submodule. See `DEV_INSTRUCTIONS.md` for automation details.

## TL;DR – Using Codex

1. **Clone this repo** or include it as a submodule of your Frappe based project.
2. **Optional template repos** go into `template-repos.txt`.
3. **Sample data** can be placed in `sample_data/`.
4. **Commit and push** your customised repository.

Trigger the **Update Vendor Apps** workflow in the Frappe template (or run `./setup.sh` there) to clone ERPNext and generate `codex.json`. Afterwards create a Codex environment and start developing your extensions.

This repository serves as a starting point for custom **ERPNext** modules. Frappe itself is provided by the main template.

## Repository Layout

```
apps/               # Place your ERPNext extension apps here
instructions/       # Development guides
codex.json          # Index of sources for Codex
codex_prompt.md     # Main prompt for Codex
setup.sh            # Initialization script
template-repos.txt  # Additional templates
sample_data/        # Example payloads and API docs
```

## Running Tests

Install dependencies from `requirements.txt` and run the suite with `pytest -q`:

```bash
pip install -r requirements.txt
pytest -q
```

Further notes can be found inside the `instructions/` folder.
