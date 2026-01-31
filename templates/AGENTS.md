# AGENTS.md

<!-- DOTAGENT:BEGIN — managed by dotagent, do not edit manually -->

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

## Review Loop (MANDATORY)

After completing ANY code change in `src/`, you MUST execute this loop before reporting the task as done. Do NOT skip this. Do NOT ask the user whether to run it. Just do it.

### Steps
1. Run validations:
   ```bash
   {TEST_COMMAND} && {LINT_COMMAND}
   ```
   If any required check fails → fix the issue and re-run. This counts as one iteration.

2. Review your own changes by reading the diff (`git diff`) and evaluating:
   - **Correctness**: does the code do what was requested?
   - **Tests**: are new behaviors covered by tests?
   - **Invariants**: are rules in `docs/invariants/INVARIANTS.md` respected?
   - **Patterns**: does the code follow patterns defined in this file and module-level AGENTS.md files?
   - **Security**: are there obvious vulnerabilities?
   - **IGNORE**: formatting, style, naming preferences (the linter handles these)

3. If you find real issues (bugs, missing tests, violated invariants, security problems) → fix them and go back to step 1.

4. If no real issues remain → the loop is done. Proceed to report or commit.

**Max iterations: 3.** If after 3 iterations there are still issues, stop and report them to the user.

## Restrictions
- NEVER commit credentials or .env
- NEVER modify {CRITICAL_FILES} without confirmation
- NEVER delete passing tests

## Diagnostics
1. Run `{LINT_COMMAND}`
2. Run `{TEST_COMMAND}`
3. Review `docs/architecture/` if there are design questions

<!-- DOTAGENT:END -->
