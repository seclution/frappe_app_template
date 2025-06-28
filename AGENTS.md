# AGENTS Setup

This repository is prepared for Codex driven development. Always load the documents under `instructions/` as the primary context for any prompt about this project. They contain all notes for Frappe and ERPNext as well as template specific guides.

Key points:

- Follow the setup steps and guidelines in `README.md` and `DEV_INSTRUCTIONS.md`.
- `instructions/_core/` provides essential development notes. Additional folders under `instructions/_*/` come from templates and expand on these basics.
- When modifying code, install developer requirements and run the test suite:
  ```bash
  pip install -r requirements-dev.txt
  pytest
  ```
- Use `./setup.sh` or the **update-vendors** workflow to sync vendor apps when configuration files change.

By default, Codex should treat this repository as an app template for Frappe based projects. Use the example prompts in `instructions/_core/prompts.md` to bootstrap or extend apps.
