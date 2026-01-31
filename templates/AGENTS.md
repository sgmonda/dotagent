# AGENTS.md

<!-- DOTAGENT:BEGIN — managed by dotagent, do not edit manually -->

> **SESSION START — Read this entire file carefully before doing anything.**
>
> You MUST follow ALL rules in this file for every task. Key obligations:
> - **TDD is mandatory**: write tests before implementation (see Mandatory TDD section)
> - **Review loop is mandatory**: after every code change, run the review loop (see Review Loop section below)
>
> Before your first task, run your project's test command and check git status.
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

## ⚠️ Review Loop — MANDATORY, DO NOT SKIP

**CRITICAL INSTRUCTION**: After completing ANY code change, you MUST run this review loop BEFORE telling the user the task is done. This is not optional. Do not ask permission. Do not skip it. Execute it every single time.

**Tell the user you are starting the review loop** by printing: `🔄 Starting review loop (iteration 1/3)...`

### Steps
1. **Run validations**: execute the project's test and lint commands (see Commands section above).
   If any check fails → fix the issue, print `🔄 Review loop iteration N/3...`, and re-run.

2. **Review your own diff** (`git diff`) and evaluate:
   - **Correctness**: does the code do what was requested?
   - **Tests**: are new behaviors covered by tests?
   - **Invariants**: are rules in `docs/invariants/INVARIANTS.md` respected?
   - **Patterns**: does the code follow patterns defined in this file and module-level AGENTS.md files?
   - **Security**: are there obvious vulnerabilities?
   - **IGNORE**: formatting, style, naming preferences (the linter handles these)

3. If you find real issues (bugs, missing tests, violated invariants, security problems) → fix them and go back to step 1.

4. When the loop is done, print: `✅ Review loop passed` and then report to the user.

**Max iterations: 3.** If after 3 iterations there are still issues, print `⚠️ Review loop: issues remain after 3 iterations` and report them to the user.

## Restrictions
- NEVER commit credentials or .env
- NEVER modify critical infrastructure files without confirmation
- NEVER delete passing tests

## Diagnostics
1. Run the project's lint command
2. Run the project's test command
3. Review `docs/architecture/` if there are design questions

<!-- DOTAGENT:END -->
