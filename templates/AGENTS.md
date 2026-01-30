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
```bash
{TEST_COMMAND}              # All tests
{TEST_SINGLE_COMMAND}       # Specific test
{LINT_COMMAND}              # Check code
{FORMAT_COMMAND}            # Format code
```

## Architecture
```
src/
├── {MODULE}/       # {PURPOSE}
└── ...
```

## Patterns

### Error Handling
```{LANGUAGE}
// ✅ Correct: return typed result
{CORRECT_ERROR_EXAMPLE}

// ❌ Incorrect: uncontrolled exceptions
{INCORRECT_ERROR_EXAMPLE}
```

### Data Access
```{LANGUAGE}
// ✅ Correct: use centralized client/repository
{CORRECT_DATA_EXAMPLE}

// ❌ Incorrect: direct connections
{INCORRECT_DATA_EXAMPLE}
```

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
