# Agent Instructions

`agent.md` files define guidelines for the automation agent. A file placed in a directory applies to all files below that path. Nested files override parent instructions.

Common use cases:

- coding conventions or formatting rules
- test commands that must run before commits
- repository specific tips

The workflow `generate-agent-index` collects these documents and builds `instructions/_INDEX.md`. Adjust or add `agent.md` files whenever the project layout changes.
