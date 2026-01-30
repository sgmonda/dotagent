---
name: dotagent-upgrade
description: Upgrades an existing DOTAGENT project to the latest specification version. Detects what's missing or outdated and applies incremental changes without overwriting customizations.
---

# DOTAGENT-UPGRADE

Skill for upgrading existing projects to the latest DOTAGENT specification.

## When to Use

- User asks to upgrade or update the DOTAGENT setup
- User mentions a new spec version or feature they want
- Keywords: "upgrade", "update dotagent", "sync agent config", "new spec version"

## Design Principles

1. **Non-destructive**: Never overwrite user customizations. Only add what's missing or update structural elements.
2. **Idempotent**: Running the upgrade twice produces the same result as running it once.
3. **Transparent**: Report every change before and after applying it.
4. **Incremental**: Apply only the delta between current state and target spec version.

---

## Upgrade Process

### Step 1: Detect Current Version

Read `.agent/config.yaml` and check the `version` field:

```yaml
# Current state — read version from the project's .agent/config.yaml
version: "{CURRENT_VERSION}"
```

If `.agent/config.yaml` does not exist, abort and suggest running `dotagent-bootstrap` instead.

### Step 2: Audit Current Structure

Check for the presence and completeness of each expected element. Build an audit report:

```
## DOTAGENT Upgrade Audit

Project: {name}
Current version: {current}
Target version: {target}

### Config (.agent/config.yaml)
- [x] project section
- [x] stack section
- [x] commands section
- [ ] review_loop section          ← MISSING

### Personas (.agent/personas/)
- [x] tdd-enforcer.md
- [x] security-auditor.md
- [ ] code-reviewer.md             ← OUTDATED (missing review loop format)

### Hooks (.agent/hooks/)
- [x] pre-commit.md
- [ ] post-change-review.md        ← MISSING

### AGENTS.md
- [x] Session start block
- [x] Commands section
- [x] TDD section
- [ ] Review Loop section          ← MISSING

### Status: {N} items to update
```

### Step 3: Present Plan

Show the user what will be changed:

```
## Upgrade Plan: v{current} → v{target}

### New files to create
1. `.agent/hooks/post-change-review.md` — Automatic review loop hook

### Files to update (additions only, no overwrites)
2. `.agent/config.yaml` — Add `review_loop` section
3. `.agent/personas/code-reviewer.md` — Update to review loop format
4. `AGENTS.md` — Add "Review Loop" section

### No changes needed
- .agent/personas/tdd-enforcer.md (up to date)
- .agent/personas/security-auditor.md (up to date)
- docs/invariants/INVARIANTS.md (up to date)

Proceed? (y/n)
```

### Step 4: Apply Changes

For each item in the plan:

#### New files
Create them using the templates from the current spec version. Use the project's existing `config.yaml` values to fill placeholders (test command, lint command, etc.).

#### Config additions
Append new sections to `config.yaml` without modifying existing sections. Example:

```
# Adding review_loop to config.yaml:
# - Read current file
# - Verify review_loop section does not already exist
# - Append the section at the end
```

#### Persona updates
When a persona needs updating (e.g., `code-reviewer.md` gaining review loop support):

1. Read the current file
2. Check if it already contains the new elements (e.g., "Review Verdict" format)
3. If NOT present → replace with the new template, preserving any custom review criteria the user added
4. If already present → skip

#### AGENTS.md additions
Append new sections to the project's `AGENTS.md` without modifying existing content:

1. Read current `AGENTS.md`
2. Check if the section already exists (search for the section header)
3. If NOT present → append before "## Restrictions" (or at the end if no restrictions section)
4. If already present → skip

### Step 5: Update Version

Update the version in `.agent/config.yaml`:

```yaml
version: "{TARGET_VERSION}"
```

### Step 6: Report

```
## Upgrade Complete: v{current} → v{target}

### Changes Applied
- ✅ Created `.agent/hooks/post-change-review.md`
- ✅ Added `review_loop` section to `.agent/config.yaml`
- ✅ Updated `.agent/personas/code-reviewer.md`
- ✅ Added "Review Loop" section to `AGENTS.md`
- ✅ Updated version to {target}

### Skipped (already up to date)
- ⏭️ `.agent/personas/tdd-enforcer.md`
- ⏭️ `docs/invariants/INVARIANTS.md`

### Recommended Next Steps
1. Review the changes: `git diff`
2. Run tests to verify nothing broke: `{TEST_COMMAND}`
3. Commit: `git commit -am "chore: upgrade dotagent to v{target}"`
```

---

## Version Upgrade Map

This section defines what each version upgrade adds. The agent uses this to determine what's missing.

### v1.0 → v1.1

| Element | Type | Action |
|---------|------|--------|
| `review_loop` in config.yaml | config section | Add if missing |
| `.agent/hooks/post-change-review.md` | new file | Create if missing |
| `.agent/personas/code-reviewer.md` | persona | Update to review loop format if outdated |
| "Review Loop" in AGENTS.md | section | Add if missing |

### Detection Rules for v1.1

To determine if a project already has v1.1 features:

```
review_loop present in config.yaml?
  AND post-change-review.md exists in .agent/hooks/?
  AND code-reviewer.md contains "Review Verdict"?
  AND AGENTS.md contains "## Review Loop"?
→ All true = already at v1.1
→ Any false = needs upgrade
```

---

## Handling Customizations

### Custom review criteria
If the user has added custom criteria to `code-reviewer.md`, preserve them by appending the default criteria that are missing rather than replacing the file.

### Custom hooks
Never remove or modify hooks the user created. Only add new hooks defined by the spec.

### Custom config sections
Never remove or modify existing config sections. Only add new sections defined by the spec.

### Custom AGENTS.md content
Never remove or reorder existing sections. Only append new sections in the appropriate location.

---

## Edge Cases

### Project has no `.agent/` directory
→ Abort. Suggest `dotagent-bootstrap` instead.

### Project is already at target version
→ Run audit anyway to check completeness (files may have been deleted). Report and offer to restore missing elements.

### Project has a higher version than the skill knows
→ Warn the user and abort. The skill needs updating.

### User declines the plan
→ Abort gracefully. No changes made.
