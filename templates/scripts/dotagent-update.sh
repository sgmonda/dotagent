#!/usr/bin/env bash
set -euo pipefail

# Updates DOTAGENT skills from the source repository.
# Run this to get the latest skills, then use /dotagent-upgrade
# to apply spec changes to the project.

DOTAGENT_SOURCE="${DOTAGENT_SOURCE:-https://github.com/sgmonda/dotagent}"
DOTAGENT_BRANCH="${DOTAGENT_BRANCH:-main}"
SKILLS_DIR=".agent/skills"
TMPDIR=$(mktemp -d)

cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "Fetching DOTAGENT from $DOTAGENT_SOURCE ($DOTAGENT_BRANCH)..."
git clone --depth 1 --branch "$DOTAGENT_BRANCH" "$DOTAGENT_SOURCE" "$TMPDIR" 2>/dev/null

mkdir -p "$SKILLS_DIR"
cp "$TMPDIR"/skills/*.md "$SKILLS_DIR/"

echo ""
echo "Updated skills:"
ls -1 "$SKILLS_DIR"/*.md
echo ""
echo "Done. Now ask your agent to run /dotagent-upgrade"
