#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# DOTAGENT installer
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/sgmonda/dotagent/main/install.sh | bash
#
# First run:  installs everything + scaffolds project files
# Later runs: only updates skills and agent config
# ─────────────────────────────────────────────────────────────

DOTAGENT_REPO="${DOTAGENT_REPO:-https://github.com/sgmonda/dotagent}"
DOTAGENT_BRANCH="${DOTAGENT_BRANCH:-main}"
DOTAGENT_DIR=".dotagent"

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      echo "Usage: install.sh"
      echo ""
      echo "First run installs DOTAGENT and scaffolds project template files."
      echo "Subsequent runs only update skills and agent configuration."
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

# Auto-detect: first install vs update
if [ -d "$DOTAGENT_DIR" ]; then
  IS_UPDATE=true
else
  IS_UPDATE=false
fi

TMPDIR=$(mktemp -d)
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "Fetching DOTAGENT from $DOTAGENT_REPO ($DOTAGENT_BRANCH)..."
git clone --depth 1 --branch "$DOTAGENT_BRANCH" "$DOTAGENT_REPO" "$TMPDIR" 2>/dev/null

VERSION=$(cat "$TMPDIR/VERSION")

# ── Create .dotagent/ directory ──────────────────────────────

mkdir -p "$DOTAGENT_DIR/skills"
mkdir -p "$DOTAGENT_DIR/agent"

# Copy skills (each skill is a directory with SKILL.md inside)
for skill_dir in "$TMPDIR"/skills/*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$DOTAGENT_DIR/skills/$skill_name"
  cp -r "$skill_dir"* "$DOTAGENT_DIR/skills/$skill_name/"
done

# Copy agent configuration template (only if not already present)
if [ ! -f "$DOTAGENT_DIR/agent/config.yaml" ]; then
  cp -r "$TMPDIR"/templates/.agent/* "$DOTAGENT_DIR/agent/"
else
  echo "Agent config already exists, skipping (only updating skills)."
fi

# Copy update script (install.sh doubles as update script)
SELF="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)/$(basename "${BASH_SOURCE[0]:-$0}")"
TARGET="$(cd "$(dirname "$DOTAGENT_DIR/update.sh")" && pwd)/update.sh"
if [ -f "$TMPDIR/install.sh" ]; then
  cp "$TMPDIR/install.sh" "$DOTAGENT_DIR/update.sh"
elif [ "$SELF" != "$TARGET" ]; then
  cp "$SELF" "$DOTAGENT_DIR/update.sh"
fi
chmod +x "$DOTAGENT_DIR/update.sh"

# Write version
echo "$VERSION" > "$DOTAGENT_DIR/VERSION"

# ── Create symlinks ──────────────────────────────────────────

# .agent → .dotagent/agent
if [ -L ".agent" ]; then
  rm ".agent"
elif [ -d ".agent" ]; then
  echo "Warning: .agent/ is a real directory, not a symlink. Skipping symlink creation."
  echo "         If you want the symlink, rename or remove .agent/ first."
fi
if [ ! -e ".agent" ]; then
  ln -s "$DOTAGENT_DIR/agent" .agent
  echo "Created symlink: .agent → $DOTAGENT_DIR/agent"
fi

# .claude/skills → ../.dotagent/skills (for Claude Code)
mkdir -p .claude
if [ -L ".claude/skills" ]; then
  rm ".claude/skills"
fi
if [ ! -e ".claude/skills" ]; then
  ln -s "../$DOTAGENT_DIR/skills" .claude/skills
  echo "Created symlink: .claude/skills → $DOTAGENT_DIR/skills"
fi

# ── Scaffold project template files (first install only) ─────

if [ "$IS_UPDATE" = false ]; then
  # AGENTS.md → .dotagent/AGENTS.md
  if [ ! -f "$DOTAGENT_DIR/AGENTS.md" ]; then
    cp "$TMPDIR/templates/AGENTS.md" "$DOTAGENT_DIR/AGENTS.md"
  fi
  if [ -L "AGENTS.md" ]; then
    rm "AGENTS.md"
  fi
  if [ ! -e "AGENTS.md" ]; then
    ln -s "$DOTAGENT_DIR/AGENTS.md" AGENTS.md
    echo "Created symlink: AGENTS.md → $DOTAGENT_DIR/AGENTS.md"
  fi

  # docs/ → .dotagent/docs/
  if [ ! -d "$DOTAGENT_DIR/docs/architecture" ]; then
    mkdir -p "$DOTAGENT_DIR/docs/architecture"
    cp "$TMPDIR"/templates/docs/architecture/* "$DOTAGENT_DIR/docs/architecture/"
  fi
  if [ ! -d "$DOTAGENT_DIR/docs/invariants" ]; then
    mkdir -p "$DOTAGENT_DIR/docs/invariants"
    cp "$TMPDIR"/templates/docs/invariants/* "$DOTAGENT_DIR/docs/invariants/"
  fi
  if [ -L "docs" ]; then
    rm "docs"
  fi
  if [ ! -e "docs" ]; then
    ln -s "$DOTAGENT_DIR/docs" docs
    echo "Created symlink: docs → $DOTAGENT_DIR/docs"
  fi

  # Module-level AGENTS.md example
  if [ -d "src" ] && [ ! -f "src/AGENTS.md" ]; then
    mkdir -p src
    cp "$TMPDIR/templates/src/_module_/AGENTS.md" src/AGENTS.md
    echo "Created src/AGENTS.md"
  fi
fi

# ── Summary ──────────────────────────────────────────────────

echo ""
if [ "$IS_UPDATE" = true ]; then
  echo "DOTAGENT updated to v$VERSION."
  echo ""
  echo "Ask your agent to run /dotagent-upgrade to apply spec changes."
else
  echo "DOTAGENT v$VERSION installed."
  echo ""
  echo "  .dotagent/           All DOTAGENT files"
  echo "  .agent → symlink     For agent tools"
  echo "  .claude/skills → symlink  For Claude Code"
  echo ""
  echo "Next steps:"
  echo "  1. Ask your agent to run /dotagent-bootstrap (new project)"
  echo "     or /dotagent-onboard (existing project)"
  echo "  2. To update later: bash .dotagent/update.sh"
fi
echo ""
