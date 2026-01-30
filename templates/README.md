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
```bash
{SETUP_COMMANDS}
```

### Commands
```bash
{BUILD_COMMAND}    # Build
{TEST_COMMAND}     # Tests
{LINT_COMMAND}     # Lint
```

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
