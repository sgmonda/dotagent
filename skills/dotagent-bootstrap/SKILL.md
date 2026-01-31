---
name: dotagent-bootstrap
description: Initializes a new project following DOTAGENT (see VERSION file). Creates directory structure, agent configuration, architectural documentation, and an example module with TDD.
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
├── AGENTS.md
├── README.md
├── .gitignore
└── <project-config-file>
```

---

## Templates

All file templates are stored as individual files in the `templates/` directory, mirroring the structure of the generated project:

```
templates/
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
│       └── post-change-review.md
├── docs/
│   ├── architecture/
│   │   ├── INDEX.md
│   │   └── 0001-stack-selection.md
│   └── invariants/
│       └── INVARIANTS.md
├── src/
│   └── _module_/
│       └── AGENTS.md
├── AGENTS.md
└── README.md
```

Read each template file, replace `{PLACEHOLDER}` values with the project-specific information, and write the result to the corresponding path in the generated project.

**IMPORTANT**: The `AGENTS.md` template contains `<!-- DOTAGENT:BEGIN -->` and `<!-- DOTAGENT:END -->` markers. You MUST preserve these markers in the generated file. The content between them is managed by dotagent and will be updated automatically on future upgrades. Users can add custom content outside the markers.

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

### Deno + Fresh
```yaml
commands:
  build: "deno task build"
  test: "deno test"
  test_single: "deno test {file}"
  lint: "deno lint"
  format: "deno fmt"
  type_check: "deno check src/"
conventions:
  naming:
    files: "kebab-case"
    functions: "camelCase"
    constants: "SCREAMING_SNAKE_CASE"
```

---

## Generation Process

1. **Read version** from the `VERSION` file at the repository root (`{DOTAGENT_VERSION}`)
2. **Receive parameters** (stack, domain, name)
3. **Select mapping** based on stack
4. **Create directories** in order
5. **Generate files** replacing placeholders (including `{DOTAGENT_VERSION}`)
5. **Copy DOTAGENT skills** into `.agent/skills/` for future upgrades
6. **Create example module** with test
8. **Verify** generated structure
9. **Report** created files

## Expected Output

```
✅ Project {name} created with DOTAGENT v{DOTAGENT_VERSION}

Generated files:
- .agent/config.yaml
- .agent/commands/*.md
- .agent/personas/*.md
- .agent/hooks/post-change-review.md
- .agent/skills/*.md
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

To update DOTAGENT in the future:
  bash .dotagent/update.sh && ask agent to run /dotagent-upgrade
```
