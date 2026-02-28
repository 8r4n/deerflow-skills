# deerflow-skills

This repository contains **skills** (tools/integrations) used by a local DeerFlow-based autonomous assistant.

- Durable memory and run logs live in: https://github.com/8r4n/deerflow-ops
- This repo is for **code artifacts**: MCP wrappers, Dockerfiles, tests, and skill manifests.

## Rules (one folder per skill)

Each skill lives under:

- `skills/<skill-name>/`

Skills **must** be added as **git submodules** pointing to their own repository
(the `_template` directory is the only exception — it is kept inline as a
reference). This ensures the source code of every acquired skill is fully
auditable: each skill pins to an exact commit SHA with full history and
provenance. See [docs/adding-a-skill.md](docs/adding-a-skill.md) for the
step-by-step workflow.

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
- add the skill as a git submodule (`git submodule add …`)
- keep changes limited to one skill folder when possible
- include/adjust contract tests
- update documentation
- be linked from a `memory:skill` issue in `8r4n/deerflow-ops`