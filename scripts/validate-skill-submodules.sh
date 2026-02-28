#!/usr/bin/env bash
# validate-skill-submodules.sh
#
# Ensures every skill directory under skills/ (except _template) is registered
# as a git submodule, making skill source code fully auditable.
#
# Exit codes:
#   0 — all skills are valid submodules
#   1 — one or more skills are not submodules

set -euo pipefail

SKILLS_DIR="skills"
ERRORS=0

# Collect registered submodule paths
submodule_paths() {
  git config --file .gitmodules --get-regexp 'submodule\..*\.path' 2>/dev/null \
    | awk '{print $2}' || true
}

REGISTERED=$(submodule_paths)

for dir in "$SKILLS_DIR"/*/; do
  # Strip trailing slash
  dir="${dir%/}"
  name="$(basename "$dir")"

  # _template is an inline reference, not a submodule
  [ "$name" = "_template" ] && continue

  if ! echo "$REGISTERED" | grep -qx "$dir"; then
    echo "ERROR: $dir is not a git submodule. Skills must be added via 'git submodule add'." >&2
    ERRORS=$((ERRORS + 1))
  fi
done

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "Found $ERRORS skill(s) not tracked as submodules."
  echo "See docs/adding-a-skill.md for the correct workflow."
  exit 1
fi

echo "All skills are valid submodules."
