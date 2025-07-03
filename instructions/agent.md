# Agent Usage Overview

This template is optimized for the new agent-based workflow replacing the former Codex setup.
The agent reads all files under `instructions/`, vendor directories and the app code to build its context.

Key points:
- Use `setup.sh` and `scripts/update_vendors.sh` to manage vendor apps.
- Keep guidance in the `instructions/` folder up to date; the indexing workflow reads these files automatically.
- Tests reside in `tests/` and should pass via `pytest`.

For general information about this template see [PROJECT.md](../PROJECT.md).
