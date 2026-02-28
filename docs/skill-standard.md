# Skill standard (deerflow-skills)

This document defines the repository contract for skills. It exists to optimize for:
- maintainability (primary)
- fast shipping (secondary)

## Required structure (minimum)
For each `skills/<skill-name>/`:

- `README.md`
- `Dockerfile`
- `skill.yaml`
- `tests/`

Optional (recommended):
- `mcp-server/`
- `examples/`

## README.md required sections
- Purpose / When to use
- How to build and run (Docker)
- Tools exposed (names + what they do)
- Required env vars (names only; no secrets)
- Troubleshooting / limitations

## skill.yaml (minimal schema)
At minimum:
- `name`
- `version`
- `tools` (list of tool names and short descriptions)
- `runtime` (docker image tag, ports)
- `env` (names only)
- `mounts` (expected mounts, if any)

## Contract tests
Each skill MUST have a runnable contract test suite.

Minimum expectations:
- tests can run in Docker (preferred)
- tests validate:
  - the server starts
  - each tool endpoint can be invoked with a minimal request
  - basic error handling works (invalid input produces expected error)

## Submodule requirement (auditability)

Every skill (except `_template`) **must** be tracked as a
[git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) pointing
to its own repository. This guarantees:

- Full commit history and provenance for every skill.
- Reproducible checkouts — each commit of this repo produces the exact same
  skill sources.
- Clear separation of ownership — skill authors iterate in their own repo.

See [adding-a-skill.md](adding-a-skill.md) for the step-by-step workflow.

A CI check (`validate-submodules`) runs on every PR to enforce this rule.

## Skill completeness score (SCS)
A skill is considered “shippable” when:
- all required files exist
- the skill is added as a git submodule (not committed directly)
- README required sections are present
- tests run successfully
- a corresponding `memory:skill` issue exists in `8r4n/deerflow-ops` with verification evidence