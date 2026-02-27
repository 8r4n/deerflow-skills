# deerflow-skills

This repository contains **skills** (tools/integrations) used by a local DeerFlow-based autonomous assistant.

- Durable memory and run logs live in: https://github.com/8r4n/deerflow-ops
- This repo is for **code artifacts**: MCP wrappers, Dockerfiles, tests, and skill manifests.

## Rules (one folder per skill)

Each skill lives under:

- `skills/<skill-name>/`

Each skill MUST include:
- `README.md` (purpose, how to run, tools exposed, required env vars (names only), troubleshooting)
- `Dockerfile` (build a “blessed” image)
- `skill.yaml` (manifest: name/version/tools/env/ports)
- `tests/` (contract tests runnable in Docker)
- optional:
  - `mcp-server/` (wrapper server code)
  - `examples/` (example tool calls / usage)

## PR expectations
A PR that adds or changes a skill should:
- keep changes limited to one skill folder when possible
- include/adjust contract tests
- update documentation
- be linked from a `memory:skill` issue in `8r4n/deerflow-ops`