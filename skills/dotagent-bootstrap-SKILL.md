---
name: dotagent-bootstrap
description: Initializes a new project following DOTAGENT v1.0. Creates directory structure, agent configuration, architectural documentation, and an example module with TDD.
---

# DOTAGENT-BOOTSTRAP

Skill for initializing projects optimized for development with AI agents.

## When to Use

- User asks to create a new project
- User wants to structure an existing project for agents
- Keywords: "new project", "initialize", "bootstrap", "create project", "setup"

## Required Information

Before generating, you need to know:

1. **Technology stack**:
   - Language and version
   - Main framework
   - Database (if applicable)
   - ORM/query builder (if applicable)
   - Testing framework

2. **Domain/purpose** of the project

3. **Project name**

If the user does not provide this information, ask concisely:

```
To create the project I need:
- Stack: Language + framework + DB?
- Domain: What problem does it solve?
- Name: What is the project called?
```

---

## Structure to Generate

```
<project>/
├── .agent/
│   ├── config.yaml
│   ├── commands/
│   │   ├── commit.md
│   │   └── test-module.md
│   ├── personas/
│   │   ├── code-reviewer.md
│   │   ├── security-auditor.md
│   │   └── tdd-enforcer.md
│   └── hooks/
│       ├── pre-commit.md
│       └── post-change-review.md
├── docs/
│   ├── architecture/
│   │   ├── INDEX.md
│   │   └── 0001-stack-selection.md
│   └── invariants/
│       └── INVARIANTS.md
├── src/
│   └── <example-module>/
│       ├── AGENTS.md
│       ├── handler.<ext>
│       └── handler.test.<ext>
├── tests/
│   ├── integration/
│   │   └── .gitkeep
│   ├── fixtures/
│   │   └── .gitkeep
│   └── helpers/
│       └── .gitkeep
├── scripts/
│   └── .gitkeep
├── AGENTS.md
├── README.md
├── .gitignore
└── <project-config-file>
```

---

## Templates by File

### .agent/config.yaml

```yaml
version: "1.0"

project:
  name: "{PROJECT_NAME}"
  type: "{TYPE: web-application|api|library|cli|mobile}"
  primary_language: "{LANGUAGE}"

stack:
  runtime: "{RUNTIME_VERSION}"
  framework: "{FRAMEWORK_VERSION}"
  database: "{DATABASE_VERSION}"
  orm: "{ORM}"
  testing: "{TEST_FRAMEWORK}"

commands:
  build: "{BUILD_COMMAND}"
  test: "{TEST_COMMAND}"
  test_single: "{TEST_SINGLE_COMMAND}"
  lint: "{LINT_COMMAND}"
  format: "{FORMAT_COMMAND}"
  type_check: "{TYPE_CHECK_COMMAND}"

paths:
  source: "src/"
  tests: "tests/"

conventions:
  naming:
    files: "{FILE_CONVENTION}"
    functions: "{FUNCTION_CONVENTION}"
    constants: "{CONSTANT_CONVENTION}"

  imports:
    order: ["{IMPORT_ORDER}"]

testing:
  tdd:
    required_for:
      - "src/**"
    recommended_for: []
    optional_for:
      - "scripts/**"

    thresholds:
      coverage_required: 80
      test_first_ratio: 80

boundaries:
  never_modify:
    - ".env*"
    - "*.lock"
    - "{PROTECTED_FILES}"

  ask_before_modifying:
    - "{MAIN_CONFIG}"
    - ".github/workflows/**"

  safe_to_modify:
    - "src/**"
    - "tests/**"

security:
  forbidden_patterns:
    - pattern: "{DANGEROUS_PATTERN_1}"
      message: "{MESSAGE_1}"

review_loop:
  enabled: true
  max_iterations: 3
  pre_review_checks:
    - command: "{TEST_COMMAND}"
      name: "tests"
      required: true
    - command: "{LINT_COMMAND}"
      name: "lint"
      required: true
    - command: "{TYPE_CHECK_COMMAND}"
      name: "type-check"
      required: false
  review_criteria:
    - "Correctness: does the code do what was requested?"
    - "Tests: are new behaviors covered by tests?"
    - "Invariants: are system invariants respected?"
    - "Patterns: does the code follow project patterns from AGENTS.md?"
    - "Security: are there obvious vulnerabilities?"
  review_ignores:
    - "Formatting and style (handled by linter)"
    - "Minor naming preferences"
    - "Comment wording"
  skip_for:
    - "docs/**"
    - "*.md"
    - "*.config.*"
```

### AGENTS.md (root)

```markdown
# AGENTS.md

> **SESSION START**
>
> Before any task, run:
> ```bash
> git status --short && git log --oneline -1
> {TEST_COMMAND} 2>&1 | tail -3
> ```
> - If there are pending changes → inform the user
> - If there are failing tests → inform before starting
> - If the task is complex or the project is unknown → run `dotagent-onboard` skill

## Identity
{PROJECT_NAME}: {BRIEF_DESCRIPTION}
Stack: {STACK_SUMMARY}

## Commands
\`\`\`bash
{TEST_COMMAND}              # All tests
{TEST_SINGLE_COMMAND}       # Specific test
{LINT_COMMAND}              # Check code
{FORMAT_COMMAND}            # Format code
\`\`\`

## Architecture
\`\`\`
src/
├── {MODULE}/       # {PURPOSE}
└── ...
\`\`\`

## Patterns

### Error Handling
\`\`\`{LANGUAGE}
// ✅ Correct: return typed result
{CORRECT_ERROR_EXAMPLE}

// ❌ Incorrect: uncontrolled exceptions
{INCORRECT_ERROR_EXAMPLE}
\`\`\`

### Data Access
\`\`\`{LANGUAGE}
// ✅ Correct: use centralized client/repository
{CORRECT_DATA_EXAMPLE}

// ❌ Incorrect: direct connections
{INCORRECT_DATA_EXAMPLE}
\`\`\`

## Mandatory TDD

For all code in `src/`:
1. Write test first
2. Verify it fails
3. Implement minimum to make it pass
4. Refactor

## Review Loop

After completing changes, switch to the `code-reviewer` persona and review your own work.
Iterate until approved or max iterations (3) reached.

### Cycle
1. Make changes
2. Run: `{TEST_COMMAND} && {LINT_COMMAND}`
3. Self-review as code-reviewer persona
4. If issues found → fix and go to step 2
5. If approved → commit

### Review Criteria
- Correctness, test coverage, invariants, project patterns, security
- Ignore: formatting, style, naming preferences (linter handles these)

## Restrictions
- NEVER commit credentials or .env
- NEVER modify {CRITICAL_FILES} without confirmation
- NEVER delete passing tests

## Diagnostics
1. Run `{LINT_COMMAND}`
2. Run `{TEST_COMMAND}`
3. Review `docs/architecture/` if there are design questions
```

### docs/architecture/INDEX.md

```markdown
# Architectural Decisions

## Active Decisions

| ID | Topic | Impact | File |
|----|-------|--------|------|
| 0001 | Stack selection | High | [0001-stack-selection.md](./0001-stack-selection.md) |

## By Area
- **Stack**: 0001
```

### docs/architecture/0001-stack-selection.md

```markdown
# ADR-0001: Technology Stack Selection

## Status
Accepted | {DATE}

## Context
{NEED_DESCRIPTION}

## Decision
We use:
- **Language**: {LANGUAGE} - {REASON}
- **Framework**: {FRAMEWORK} - {REASON}
- **Database**: {DATABASE} - {REASON}
- **Testing**: {TEST_FRAMEWORK} - {REASON}

## Consequences

### Positive
- {BENEFIT_1}
- {BENEFIT_2}

### Negative
- {LIMITATION_1}

### Code Restrictions
- {RESTRICTION_1}
- {RESTRICTION_2}

## Alternatives Considered
- **{ALTERNATIVE}**: {WHY_NOT}
```

### docs/invariants/INVARIANTS.md

```markdown
# System Invariants

## Security [CRITICAL]

### INV-001: Mandatory input validation
All external input MUST be validated before processing.

### INV-002: Authentication on protected endpoints
Every endpoint that modifies data MUST verify authentication.

### INV-003: No credentials in code
NEVER hardcode API keys, passwords, or secrets in source code.

## Data [CRITICAL]

### INV-004: Transactions for multiple operations
Operations that modify multiple records MUST use transactions.

## Testing [MANDATORY]

### INV-005: Tests for business logic
Every file in `src/` MUST have a corresponding test.

### INV-006: Tests before implementation
In TDD-mandatory paths, the test MUST exist before the code.
```

### .agent/personas/tdd-enforcer.md

```markdown
---
name: tdd-enforcer
description: Verifies TDD compliance before implementation
trigger: before_file_create, before_file_modify
applies_to:
  - "src/**"
---

# TDD Enforcer

## Checks

Before creating/modifying files in `src/`:

1. **Does the test exist?**
   - File: `src/module/handler.{ext}`
   - Expected test: `src/module/handler.test.{ext}`
   - If NOT → Create test first

2. **Is the test red?**
   - Run test
   - If it PASSES → Update test to cover new behavior
   - If it FAILS → Proceed with implementation

## Message to User

If a violation is detected:

> ⚠️ **TDD Required**
>
> Before implementing `{file}`, I need to:
> 1. Create test in `{test_file}`
> 2. Verify it fails
> 3. Implement
>
> Shall I proceed with this flow?
```

### .agent/personas/code-reviewer.md

```markdown
---
name: code-reviewer
description: Reviews changes for correctness, patterns, and quality. Used automatically in the post-change review loop.
trigger: post-change
---

# Code Reviewer

You are reviewing changes made by another agent (or yourself in a previous step).
Your goal is to approve or request concrete improvements.

## Review Process

1. **Read the diff**: Understand what changed and why
2. **Run checks**: Verify tests pass, lint is clean, types are correct
3. **Evaluate against criteria**: Check each item from `review_criteria` in config
4. **Verify invariants**: Read relevant INVARIANTS.md files for touched modules
5. **Produce verdict**: APPROVED or CHANGES_REQUESTED

## Verdict Format

```
## Review Verdict: <APPROVED|CHANGES_REQUESTED>

### Summary
<One sentence describing the overall quality>

### Issues Found (if any)
1. **[MUST FIX]** <issue description>
   - File: <path>
   - Suggestion: <concrete fix>

2. **[MUST FIX]** <issue description>
   - File: <path>
   - Suggestion: <concrete fix>

### Iteration: <current>/<max>
```

## Rules

- Only use **[MUST FIX]** for real problems: bugs, missing tests, violated invariants, security issues
- NEVER request changes for style, formatting, or preferences already handled by tooling
- Be specific: every issue must include a concrete suggestion
- If all checks pass and code is correct, APPROVE — do not invent problems
- After max iterations, APPROVE with warnings if only minor issues remain
```

### .agent/personas/security-auditor.md

```markdown
---
name: security-auditor
description: Audits code for security vulnerabilities
trigger: pre_commit
---

# Security Auditor

## Checks

### Secrets
- [ ] Are there hardcoded API keys?
- [ ] Are there passwords in the code?
- [ ] Are environment variables used correctly?

### Injection
- [ ] Do queries use parameters/prepared statements?
- [ ] Is input sanitized for system commands?

### Authentication
- [ ] Do protected endpoints verify auth?
- [ ] Are permissions/roles validated?

### Validation
- [ ] Is all external input validated?
- [ ] Are types and ranges validated?

## Severities

- 🔴 **CRITICAL**: Blocks commit (secrets, SQL injection)
- 🟠 **HIGH**: Requires justification
- 🟡 **MEDIUM**: Warning
```

### .agent/commands/commit.md

```markdown
---
name: commit
description: Create commit following conventions
---

# Format

```
<type>(<scope>): <description>

[body]

[footer]
```

## Types
- feat: New feature
- fix: Bug fix
- refactor: Refactoring
- test: Tests
- docs: Documentation
- chore: Maintenance

## Process

1. Verify that tests pass
2. Run lint
3. Create commit with descriptive message
4. Scope = affected module
```

### .agent/commands/test-module.md

```markdown
---
name: test-module
description: Run tests for a specific module
---

# Usage

When the user asks to test a module:

1. Identify the module
2. Run: `{TEST_COMMAND} src/{module}/`
3. Report results
4. If there are failures, offer to fix
```

### .agent/hooks/post-change-review.md

```markdown
---
name: post-change-review
description: Triggers the automatic review loop after code changes
trigger: after_file_modify, after_file_create
applies_to:
  - "src/**"
excludes:
  - "docs/**"
  - "*.md"
  - "*.config.*"
---

# Post-Change Review Hook

After modifying or creating source files:

1. Collect all changed files since the task started
2. Run `pre_review_checks` from config
   - If a required check fails → fix the issue first (counts as a loop iteration)
3. Switch to `code-reviewer` persona
4. Evaluate the changes
5. If CHANGES_REQUESTED:
   - Switch back to implementer role
   - Apply the suggested fixes
   - Increment iteration counter
   - Return to step 2
6. If APPROVED:
   - Proceed to commit or next task
7. If max iterations reached without approval:
   - Stop and report remaining issues to the user
```

### README.md

```markdown
# {PROJECT_NAME}

{DESCRIPTION}

## Stack

- **Language**: {LANGUAGE}
- **Framework**: {FRAMEWORK}
- **Database**: {DATABASE}
- **Testing**: {TEST_FRAMEWORK}

## Development

### Requirements
- {REQUIREMENT_1}
- {REQUIREMENT_2}

### Setup
\`\`\`bash
{SETUP_COMMANDS}
\`\`\`

### Commands
\`\`\`bash
{BUILD_COMMAND}    # Build
{TEST_COMMAND}     # Tests
{LINT_COMMAND}     # Lint
\`\`\`

## Structure

```
src/           # Source code (unit tests alongside code)
tests/         # Integration and e2e tests
docs/          # Documentation
.agent/        # AI agent configuration
```

## Documentation

- [Architectural decisions](./docs/architecture/INDEX.md)
- [System invariants](./docs/invariants/INVARIANTS.md)

---

## DOTAGENT

This project follows [DOTAGENT](https://github.com/...) v1.0, a specification for repositories optimized for AI agent development.

### What does this mean?

The repository is structured so that agents like Claude Code, Cursor, Copilot, and others can:

- **Orient quickly** by reading `AGENTS.md`
- **Understand past decisions** by consulting `docs/architecture/`
- **Respect inviolable rules** defined in `docs/invariants/`
- **Follow consistent patterns** documented with examples
- **Work with TDD** as the default methodology

### Key files for agents

| File | Purpose |
|------|---------|
| `AGENTS.md` | Project rules, commands, and patterns |
| `.agent/config.yaml` | Structured configuration (stack, commands, limits) |
| `docs/architecture/` | ADRs - Why decisions were made |
| `docs/invariants/` | Rules that must never be violated |
| `src/*/AGENTS.md` | Module-specific rules |

### For humans working with agents

1. **Before requesting large changes**, make sure the agent has read `AGENTS.md`
2. **If the agent does something wrong**, it probably needs to be documented in the patterns
3. **Architectural decisions** go in `docs/architecture/`, not in scattered comments
4. **Tests come first** (TDD) - the agent is configured to follow this flow

### For contributors

If you modify the architecture or add new patterns:

1. Create an ADR in `docs/architecture/` explaining why
2. Update `AGENTS.md` with code examples if applicable
3. Add invariants in `docs/invariants/` if there are new rules
4. Future agents (and humans) will thank you
```

### Example Module

Create a basic module that demonstrates the structure:

`src/<module>/AGENTS.md`:
```markdown
# Module: {MODULE}

## Purpose
{MODULE_DESCRIPTION}

## Files
- `handler.{ext}`: Main logic
- `handler.test.{ext}`: Tests

## Specific Patterns
{MODULE_PATTERNS}
```

`src/<module>/handler.{ext}`:
```
// Minimal example implementation
// The agent should expand as needed
```

`src/<module>/handler.test.{ext}`:
```
// Example test following TDD
// Structure: describe > it > arrange/act/assert
```

---

## Stack Mappings

### Python + FastAPI
```yaml
commands:
  build: "pip install -e ."
  test: "pytest"
  test_single: "pytest {file} -v"
  lint: "ruff check ."
  format: "ruff format ."
  type_check: "mypy src/"
conventions:
  naming:
    files: "snake_case"
    functions: "snake_case"
    constants: "SCREAMING_SNAKE_CASE"
```

### Go + Gin
```yaml
commands:
  build: "go build ./..."
  test: "go test ./..."
  test_single: "go test -v {file}"
  lint: "golangci-lint run"
  format: "gofmt -w ."
conventions:
  naming:
    files: "snake_case"
    functions: "camelCase"
    constants: "camelCase"
```

### TypeScript + Node
```yaml
commands:
  build: "npm run build"
  test: "npm test"
  test_single: "npm test -- {file}"
  lint: "npm run lint"
  format: "npm run format"
  type_check: "tsc --noEmit"
conventions:
  naming:
    files: "kebab-case"
    functions: "camelCase"
    constants: "SCREAMING_SNAKE_CASE"
```

### Rust
```yaml
commands:
  build: "cargo build"
  test: "cargo test"
  test_single: "cargo test {name}"
  lint: "cargo clippy"
  format: "cargo fmt"
conventions:
  naming:
    files: "snake_case"
    functions: "snake_case"
    constants: "SCREAMING_SNAKE_CASE"
```

### Java + Spring
```yaml
commands:
  build: "./gradlew build"
  test: "./gradlew test"
  test_single: "./gradlew test --tests {class}"
  lint: "./gradlew checkstyleMain"
  format: "./gradlew spotlessApply"
conventions:
  naming:
    files: "PascalCase"
    functions: "camelCase"
    constants: "SCREAMING_SNAKE_CASE"
```

---

## Generation Process

1. **Receive parameters** (stack, domain, name)
2. **Select mapping** based on stack
3. **Create directories** in order
4. **Generate files** replacing placeholders
5. **Create example module** with test
6. **Verify** generated structure
7. **Report** created files

## Expected Output

```
✅ Project {name} created with DOTAGENT v1.0

Generated files:
- .agent/config.yaml
- .agent/commands/*.md
- .agent/personas/*.md
- .agent/hooks/post-change-review.md
- docs/architecture/INDEX.md
- docs/architecture/0001-stack-selection.md
- docs/invariants/INVARIANTS.md
- src/{module}/handler.{ext}
- src/{module}/handler.test.{ext}
- AGENTS.md
- README.md
- .gitignore

Next steps:
1. Review .agent/config.yaml and adjust if needed
2. Run `{test_command}` to verify setup
3. Start development following TDD
```
