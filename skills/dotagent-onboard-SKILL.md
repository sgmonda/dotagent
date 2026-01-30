---
name: dotagent-onboard
description: Analyzes an existing project and generates a complete briefing to orient the agent. Use at the start of each session or when encountering an unknown project.
---

# DOTAGENT-ONBOARD

Skill for orienting agents in existing projects following DOTAGENT.

## When to Use

- Session start on an unknown project
- User asks "understand this project", "onboard", "orient yourself"
- Before making significant changes to a new project
- When the agent lacks project context

## Onboarding Process

### Phase 1: Structure Detection

Search in priority order:

```
1. .agent/config.yaml      → Complete project configuration
2. AGENTS.md               → Rules and patterns
3. README.md               → General description
4. docs/architecture/      → Architectural decisions
5. docs/invariants/        → Inviolable rules
```

If `.agent/config.yaml` exists, the project follows DOTAGENT.
If it doesn't exist, infer information from standard files.

### Phase 2: Project Analysis

Run these checks:

```bash
# 1. Directory structure
ls -la
find . -type f -name "*.md" | head -20

# 2. Detect language/stack
# Look for characteristic configuration files:
# - package.json → Node/JS/TS
# - pyproject.toml, requirements.txt → Python
# - go.mod → Go
# - Cargo.toml → Rust
# - pom.xml, build.gradle → Java
# - Gemfile → Ruby

# 3. Test status
# Run the project's test command (if known)

# 4. Git status
git log --oneline -5
git status --short
git branch --list
```

### Phase 3: Documentation Reading

Read in this order (if they exist):

1. **`.agent/config.yaml`**: Extract stack, commands, boundaries
2. **`AGENTS.md`**: Extract mandatory patterns and restrictions
3. **`docs/architecture/INDEX.md`**: List active ADRs
4. **`docs/invariants/INVARIANTS.md`**: Identify critical rules
5. **Per-module AGENTS.md**: If working on a specific module

### Phase 4: Generate Briefing

---

## Briefing Format

```markdown
# Project Briefing

## Identity
- **Name**: {project name}
- **Description**: {brief description}
- **Stack**: {language} + {framework} + {database}

## Structure
```
{main directory tree, max 15 lines}
```

## Available Commands
```bash
{build_command}    # Build
{test_command}     # Tests
{lint_command}     # Lint
{format_command}   # Format
```

## Main Modules
| Module | Purpose | Tests |
|--------|---------|-------|
| {module} | {purpose} | ✅/❌ |

## Current Status
- **Branch**: {current branch}
- **Last commit**: {last commit message}
- **Pending changes**: {modified files}
- **Tests**: {X passing, Y failing}

## Architectural Decisions
| ID | Topic |
|----|-------|
| ADR-0001 | {topic} |
| ADR-0002 | {topic} |

## Critical Invariants
- 🔴 {critical invariant 1}
- 🔴 {critical invariant 2}

## Restrictions
- NEVER: {restriction 1}
- NEVER: {restriction 2}
- Confirm before modifying: {protected files}

## Alerts
{if there are failing tests, uncommitted changes, critical TODOs, etc.}

---
✅ Onboarding complete. Ready to work.
```

---

## Stack Detection (without config.yaml)

If `.agent/config.yaml` doesn't exist, infer from the project:

### Node.js / TypeScript
```
Detect: package.json
Read:
  - name, description
  - scripts (build, test, lint)
  - main dependencies
```

### Python
```
Detect: pyproject.toml, setup.py, requirements.txt
Read:
  - [project] name, description
  - [tool.pytest], [tool.ruff]
  - dependencies
```

### Go
```
Detect: go.mod
Read:
  - module name
  - go version
  - require (dependencies)
```

### Rust
```
Detect: Cargo.toml
Read:
  - [package] name, description
  - [dependencies]
```

### Java
```
Detect: pom.xml, build.gradle
Read:
  - groupId, artifactId
  - dependencies
```

---

## Inferred Commands by Stack

If there is no explicit config, use defaults:

| Stack | Test | Lint | Build |
|-------|------|------|-------|
| Node (npm) | `npm test` | `npm run lint` | `npm run build` |
| Node (pnpm) | `pnpm test` | `pnpm lint` | `pnpm build` |
| Python (pytest) | `pytest` | `ruff check .` | `pip install -e .` |
| Python (poetry) | `poetry run pytest` | `poetry run ruff check .` | `poetry build` |
| Go | `go test ./...` | `golangci-lint run` | `go build ./...` |
| Rust | `cargo test` | `cargo clippy` | `cargo build` |
| Java (Maven) | `mvn test` | `mvn checkstyle:check` | `mvn package` |
| Java (Gradle) | `./gradlew test` | `./gradlew check` | `./gradlew build` |

---

## Module Analysis

For each directory in `src/`:

1. **Count files** of code vs tests
2. **Detect local AGENTS.md** (if it exists)
3. **Identify main exports**
4. **Verify test coverage**

```markdown
## Modules

| Module | Files | Tests | Coverage | AGENTS.md |
|--------|-------|-------|----------|-----------|
| users | 5 | 4 | 80% | ✅ |
| tasks | 8 | 6 | 75% | ✅ |
| notifications | 3 | 1 | 33% | ❌ |
```

---

## Problem Detection

Alert on:

### 🔴 Critical
- Failing tests
- Environment files (.env) in git
- Secrets in code (search patterns: API_KEY, password, token)
- Pending migrations

### 🟠 Important
- Test coverage < 50%
- TODOs/FIXMEs in code
- Outdated dependencies (if detectable)
- Very large files (> 500 lines)

### 🟡 Informational
- Local branches without merge
- Uncommitted changes
- Outdated documentation (old dates in ADRs)

---

## Minimal Briefing (project without DOTAGENT)

If the project doesn't follow the spec, generate a reduced briefing:

```markdown
# Project Briefing

## Identity
- **Name**: {inferred from config or directory}
- **Stack**: {inferred from config files}

## Structure
```
{basic tree}
```

## Commands (inferred)
```bash
{default stack commands}
```

## Status
- **Branch**: {branch}
- **Last commit**: {commit}

## ⚠️ Project without DOTAGENT

This project does not follow the DOTAGENT specification.
Recommendations:
1. Review README.md to understand the project
2. Look for documentation in /docs if it exists
3. Ask the user about patterns and restrictions
4. Consider running `/dotagent-bootstrap` to structure

---
⚠️ Partial onboarding. Proceed with caution.
```

---

## Session Integration

After the briefing, the agent should:

1. **Remember** the stack and commands during the session
2. **Respect** the identified restrictions
3. **Consult** ADRs before architectural decisions
4. **Verify** invariants before commits

## Refresh Command

If the project changes during the session:

```
/onboard --refresh
```

Regenerates only dynamic sections:
- Git status
- Tests passing/failing
- Pending changes

---

## Output Example

```markdown
# Project Briefing

## Identity
- **Name**: task-manager
- **Description**: REST API for task management with multi-user support
- **Stack**: Python 3.12 + FastAPI + PostgreSQL + SQLAlchemy

## Structure
```
src/
├── users/          # Authentication and user management
├── tasks/          # Task CRUD and assignments
├── notifications/  # Notification system
└── shared/         # Shared utilities
tests/
├── integration/
└── fixtures/
docs/
├── architecture/   # 4 ADRs
└── invariants/
```

## Available Commands
```bash
pytest                    # Tests
pytest src/tasks/         # Module tests
ruff check .              # Lint
ruff format .             # Format
alembic upgrade head      # Migrations
```

## Main Modules
| Module | Files | Tests | AGENTS.md |
|--------|-------|-------|-----------|
| users | 6 | 5 | ✅ |
| tasks | 9 | 8 | ✅ |
| notifications | 4 | 2 | ❌ |
| shared | 3 | 3 | ❌ |

## Current Status
- **Branch**: feature/recurring-tasks
- **Last commit**: feat(tasks): add recurrence field to task model
- **Pending changes**: 2 modified files
- **Tests**: 43 passing, 2 failing

## Architectural Decisions
| ID | Topic |
|----|-------|
| ADR-0001 | Stack: Python + FastAPI |
| ADR-0002 | PostgreSQL for persistence |
| ADR-0003 | JWT for authentication |
| ADR-0004 | Soft delete for all entities |

## Critical Invariants
- 🔴 INV-001: Validate all input with Pydantic
- 🔴 INV-002: Mandatory authentication except /health and /auth
- 🔴 INV-003: Soft delete (never physical DELETE)
- 🔴 INV-004: Transactions for multi-table operations

## Restrictions
- NEVER: Modify alembic/versions/ without a new migration
- NEVER: Hardcode credentials
- Confirm before: pyproject.toml, .github/workflows/

## Alerts
- 🔴 2 tests failing in `src/tasks/recurrence.test.py`
- 🟡 Notifications module with low coverage (50%)

---
✅ Onboarding complete. Ready to work.
```

---

## Implementation Notes

- The briefing should fit in ~1000 tokens to avoid consuming context
- Prioritize actionable information over exhaustiveness
- If the project is very large, show only top-level + relevant module
- Cache the result in memory during the session
