# DOTAGENT v1.0

## Specification for AI Agent-Managed Repositories

---

## Prologue: The Paradigm Shift

For decades, software development practices have optimized for a specific reader: the human brain. Clean code, SOLID, DRY, design patterns... all assume a developer with long-term memory, intuition, implicit context, and the ability to "read between the lines".

AI agents operate under radically different constraints:

| Human | Agent |
|-------|-------|
| Persistent memory across sessions | No memory between sessions |
| Accumulated implicit context | Only knows what is written |
| Intuition to infer intentions | Requires explicit specification |
| Cognitive cost when repeating work | Can regenerate trivial code at no cost |
| Limited by time and fatigue | Limited by tokens and context |

This specification defines how to structure repositories that maximize the effectiveness of agents like Claude Code, Cursor, Copilot, Aider, and others, without sacrificing human maintainability.

---

## 1. Directory Structure

### 1.1 Project Root

```
project/
├── .agent/                    # Agent configuration (see section 2)
├── docs/
│   ├── architecture/          # ADRs and architectural documentation
│   ├── invariants/            # System invariants
│   └── runbooks/              # Operational procedures
├── src/                       # Source code
├── tests/                     # Integration and e2e tests
├── scripts/                   # Automation scripts
├── AGENTS.md                  # Main instructions for agents
├── README.md                  # Documentation for humans
└── CHANGELOG.md               # Change history
```

### 1.2 Locality Principle

Agents work best when relevant context is close to the code they modify. Each significant directory may contain:

```
src/payments/
├── AGENTS.md                  # Module-specific rules
├── INVARIANTS.md              # Invariants that must never be violated
├── handlers/
├── models/
└── *.test.*                   # Unit tests alongside code
```

The agent reads the nearest `AGENTS.md` to the file being modified, enabling hierarchical rules that override from general to specific.

---

## 2. The `.agent/` Directory

Dedicated configuration for AI agents:

```
.agent/
├── config.yaml                # Global project configuration
├── commands/                  # Custom slash commands
│   ├── deploy.md
│   ├── test-module.md
│   └── review.md
├── skills/                    # Specialized knowledge
│   ├── database/SKILL.md
│   ├── authentication/SKILL.md
│   └── api-design/SKILL.md
├── personas/                  # Specialized agents
│   ├── code-reviewer.md
│   ├── security-auditor.md
│   └── tdd-enforcer.md
└── hooks/                     # Automations
    ├── pre-commit.md
    └── post-change.md
```

### 2.1 Main Configuration File

The `.agent/config.yaml` file defines the project configuration in a structured way:

```yaml
version: "1.0"

project:
  name: "<project name>"
  type: "<web-application|api|library|cli|mobile|other>"
  primary_language: "<primary language>"

stack:
  # Define project technologies
  runtime: "<runtime and version>"
  framework: "<framework and version>"
  database: "<database if applicable>"
  orm: "<ORM/query builder if applicable>"
  testing: "<testing framework>"

commands:
  # Commands the agent can execute
  build: "<build command>"
  test: "<command to run tests>"
  test_single: "<command for individual test with placeholder {file}>"
  lint: "<linting command>"
  format: "<formatting command>"
  type_check: "<type checking command if applicable>"

paths:
  # Important project locations
  source: "<source code directory>"
  tests: "<integration/e2e test directory>"
  # Add project-specific paths

conventions:
  naming:
    files: "<kebab-case|snake_case|camelCase>"
    components: "<PascalCase|camelCase>"
    functions: "<camelCase|snake_case>"
    constants: "<SCREAMING_SNAKE_CASE|camelCase>"

  imports:
    order: ["<categories in priority order>"]
    alias: "<import alias if any>"

boundaries:
  never_modify:
    # Files that must NEVER be modified without human intervention
    - ".env*"
    - "*.lock"
    - "<migration files>"

  ask_before_modifying:
    # Files that require confirmation
    - "<critical configuration files>"
    - "<CI/CD workflows>"

  safe_to_modify:
    # File patterns safe to modify
    - "src/**/*.<extension>"
    - "tests/**/*.test.*"
```

---

## 3. AGENTS.md: The Project Constitution

The `AGENTS.md` file is the most critical document. It is what the agent reads at the start of every session.

### 3.1 Writing Principles

1. **Extreme conciseness**: Every instruction consumes tokens. Eliminate redundancies.
2. **Positive instructions**: "Use X" is better than "Don't use Y" (agents ignore negations more frequently).
3. **Examples over explanations**: Showing correct code > describing what to do.
4. **Visual prioritization**: Most important things first.

### 3.2 Recommended Structure

```markdown
# AGENTS.md

> **SESSION START**
>
> Before any task, run:
> ```bash
> git status --short && git log --oneline -1
> ```
> - If there are pending changes → inform the user
> - If there are failing tests → inform before starting
> - If the task is complex or the project is unknown → run full dotagent-onboard skill

## Project Identity
<Brief description: what it is, main stack>

## Critical Commands
```bash
<test command>              # Run all tests
<single test command>       # Specific test
<check command>             # Check types/lint
<other key commands>
```

## Architecture
```
src/
├── <folder>/     # <purpose>
├── <folder>/     # <purpose>
└── <folder>/     # <purpose>
```

## Mandatory Patterns

### <Area 1: e.g. Data Access>
```<language>
// ✅ Correct: <description>
<correct code>

// ❌ Incorrect: <description>
<incorrect code>
```

### <Area 2: e.g. Error Handling>
```<language>
// ✅ Correct
<correct code>

// ❌ Incorrect
<incorrect code>
```

## Absolute Restrictions
- NEVER <forbidden action 1>
- NEVER <forbidden action 2>
- NEVER <forbidden action 3>

## When Something Fails
1. <Diagnostic step 1>
2. <Diagnostic step 2>
3. Review `docs/architecture/` to understand previous decisions
```

### 3.3 Anti-patterns to Avoid

| Anti-pattern | Why it's bad | Alternative |
|--------------|--------------|-------------|
| Extensive style guides | Uses tokens, the linter does it better | Configure linting tools |
| "Never do X" without alternative | The agent gets stuck | "Prefer Y over X" |
| Documenting the obvious | Wastes context | Only document exceptions |
| AGENTS.md > 2000 tokens | Degrades response quality | Split into per-module files |

---

## 4. Architecture Decision Records (ADRs)

ADRs are critical for agents because they capture the **why** behind decisions — information that doesn't exist in code.

### 4.1 Location and Format

```
docs/architecture/
├── INDEX.md                          # Decision index
├── 0001-<decision-1>.md
├── 0002-<decision-2>.md
├── 0003-<decision-3>.md
└── template.md
```

### 4.2 Agent-Optimized Template

```markdown
# ADR-<number>: <Decision title>

## Status
<Proposed|Accepted|Deprecated|Superseded> | <date>

## Context
<Description of the problem or need motivating the decision>

## Decision
<The decision made, in clear terms>

## Consequences

### Positive
- <Benefit 1>
- <Benefit 2>

### Negative
- <Cost or limitation 1>
- <Cost or limitation 2>

### Code Restrictions
- <Rule that must be followed in code>
- <Mandatory pattern>
- <Forbidden pattern>

## Alternatives Considered
- **<Alternative 1>**: <Why it was discarded>
- **<Alternative 2>**: <Why it was discarded>
```

### 4.3 ADR Index for Agents

Maintain an index the agent can quickly consult:

```markdown
# docs/architecture/INDEX.md

## Active Decisions

| ID | Topic | Impact | File |
|----|-------|--------|------|
| 0001 | <Topic> | High | [0001-topic.md](./0001-topic.md) |
| 0002 | <Topic> | High | [0002-topic.md](./0002-topic.md) |

## Search by Area
- **Frontend**: 0001, 0005, 0008
- **Database**: 0002, 0006
- **Infrastructure**: 0004, 0007
```

---

## 5. System Invariants

Invariants are rules that **must never be violated**. They are especially important for agents because they define hard boundaries.

### 5.1 Global Invariants File

`docs/invariants/INVARIANTS.md`:

```markdown
# System Invariants

## Security [CRITICAL]

### INV-001: <Invariant name>
<Rule description>
```<language>
// ✅ Correct
<code that satisfies the invariant>

// ❌ Violates invariant
<code that violates the invariant>
```

### INV-002: <Invariant name>
<Rule description>

## Data Consistency [CRITICAL]

### INV-003: <Invariant name>
<Rule description>

## Testing [MANDATORY]

### INV-004: <Invariant name>
<Rule description>
```

### 5.2 Per-Module Invariants

Each critical module can have its own invariants:

```markdown
# src/<module>/INVARIANTS.md

## <MODULE>-001: <Name>
<Description and code examples>

## <MODULE>-002: <Name>
<Description and code examples>
```

---

## 6. Dependency Metadata

Agents need to understand relationships between modules to make coherent changes.

### 6.1 Dependency Graph

`docs/architecture/dependencies.yaml`:

```yaml
modules:
  <module-1>:
    path: "src/<module-1>/"
    depends_on: ["<module-2>"]
    depended_by: ["<module-3>", "<module-4>"]
    exports:
      - "<exported function or class>"

  <module-2>:
    path: "src/<module-2>/"
    depends_on: ["<module-1>"]
    depended_by: ["<module-5>"]
    external_dependencies:
      - name: "<external library>"
        version: "<version>"
        docs: "<documentation URL>"

change_impact:
  # If you change X, review Y
  "<file or pattern>":
    - "<required action 1>"
    - "<required action 2>"
```

### 6.2 Impact Map

For high-risk changes, explicitly document what can break:

```markdown
# docs/architecture/impact-map.md

## Changes to <Critical Area>

### <Change type 1>
1. <Required step>
2. <Required step>
3. <Verification>

### <Change type 2>
⚠️ REQUIRES <special precaution>
1. <Required step>
2. <Required step>
```

---

## 7. Executable Documentation

Code that documents itself and can be verified automatically.

### 7.1 Verifiable Contracts

Use the language/framework's validation system to define contracts:

```
// Conceptual example - adapt to specific stack

/**
 * Contract: <OperationName>
 *
 * @invariant <Rule that must hold>
 * @invariant <Another rule>
 */
<schema/type definition with validations>
```

### 7.2 Examples as Specification

```
// src/<module>/examples.<extension>

/**
 * Canonical examples for the module.
 * These examples are run as tests and serve as documentation.
 */

export const examples = {
  /** <Case description> */
  <caseName>: {
    input: { /* input data */ },
    expectedOutput: { /* expected result */ }
  },

  /** <Another case description> */
  <anotherCase>: {
    input: { /* input data */ },
    expectedOutput: { /* expected result */ }
  }
}
```

---

## 8. Testing for Agents

Tests are the primary verification mechanism. Without tests, the agent operates blind.

### 8.1 Test Structure: Hybrid Colocation

Unit tests go **alongside the code they test**. Integration and e2e tests go in a separate directory.

#### Why unit tests alongside code

| Benefit | Impact for the agent |
|---------|---------------------|
| Locality | Sees test + code in a single directory listing |
| Discovery | Impossible to miss that the test exists |
| Refactoring | Moving a file = moving the test automatically |
| Context | Test and code share nearby context tokens |

#### Recommended structure

```
src/
├── <module-1>/
│   ├── handler.<ext>
│   ├── handler.test.<ext>        # ✅ Unit test alongside code
│   ├── service.<ext>
│   ├── service.test.<ext>        # ✅ Unit test alongside code
│   └── types.<ext>
├── <module-2>/
│   ├── client.<ext>
│   ├── client.test.<ext>         # ✅ Unit test alongside code
│   └── utils.<ext>

tests/
├── integration/                   # Tests that cross modules
│   ├── <flow-1>.test.<ext>
│   └── <flow-2>.test.<ext>
├── e2e/                           # Full system tests
│   ├── <scenario-1>.test.<ext>
│   └── <scenario-2>.test.<ext>
├── fixtures/                      # Shared test data
│   └── <entity>.fixtures.<ext>
└── helpers/                       # Testing utilities
    └── <helper>.<ext>
```

#### Configuration

Exclude tests from the production build and configure the test runner to find tests in both locations:

```yaml
# Pseudo-configuration - adapt to stack
test:
  include:
    - "src/**/*.test.*"        # Unit tests alongside code
    - "tests/**/*.test.*"      # Integration/e2e tests
  exclude:
    - "node_modules"
    - "dist"
    - "build"

build:
  exclude:
    - "**/*.test.*"
```

### 8.2 Conventions for Agent-Friendly Tests

```
// src/<module>/<file>.test.<ext>

/**
 * Tests for <function/module>
 *
 * @module <module>
 * @function <function>
 * @dependencies <dependencies>
 */
describe("<function/module>", () => {
  // ============================================
  // SETUP - Shared context
  // ============================================
  // Data and mock preparation

  // ============================================
  // SUCCESS CASES
  // ============================================
  describe("when data is valid", () => {
    it("<expected behavior description>", () => {
      // Arrange - input data
      // Act - execute function
      // Assert - verify result
    })
  })

  // ============================================
  // ERROR CASES
  // ============================================
  describe("when data is invalid", () => {
    it("<expected error description>", () => {
      // Arrange, Act, Assert
    })
  })

  // ============================================
  // EDGE CASES
  // ============================================
  describe("edge cases", () => {
    it("<edge case description>", () => {
      // Arrange, Act, Assert
    })
  })
})
```

### 8.3 Agent Indicators

Add metadata to help the agent understand which tests to run:

```
/**
 * @tags critical, <area>
 * @runWith <command to run these tests>
 * @relatedFiles <related files>
 * @runBefore <setup commands if needed>
 */
```

---

## 9. Test-Driven Development (TDD)

Agents work best with verifiable contracts defined *before* implementation. TDD is not just a good practice: it is the mechanism that anchors agent reasoning and prevents functional hallucinations.

### 9.1 Why TDD is Critical for Agents

| Without TDD | With TDD |
|-------------|----------|
| The agent implements and "hopes it works" | The agent knows exactly what should happen |
| Errors are discovered late or never | Immediate feedback on every cycle |
| Tests written after justify the code | Tests written before specify the behavior |
| The agent can hallucinate behaviors | The test anchors the expected reality |

### 9.2 Levels of Obligation

Not all code requires strict TDD. Define levels based on risk:

```yaml
# .agent/config.yaml

testing:
  tdd:
    # Level 1: MANDATORY - tests before implementation
    required_for:
      - "src/<business-logic>/**"
      - "src/<shared-utilities>/**"
      - "src/<domain>/**"

    # Level 2: RECOMMENDED - tests before unless justified
    recommended_for:
      - "src/<components>/**"
      - "src/<hooks-or-helpers>/**"

    # Level 3: OPTIONAL - tests after or none
    optional_for:
      - "src/<pages-or-views>/**"
      - "scripts/**"
      - "**/*.config.*"
```

### 9.3 The TDD Cycle for Agents

Document the cycle explicitly in `AGENTS.md`:

```markdown
## Testing: TDD by Default

For files in TDD-mandatory paths:

### Mandatory Cycle

1. **TEST FIRST**: Write the test describing the expected behavior
2. **RED**: Run the test - it MUST fail
3. **IMPLEMENT**: Write the minimum code to make it pass
4. **GREEN**: Run the test - it MUST pass
5. **REFACTOR**: Improve the code while keeping tests green
6. **REPEAT**: Next test case

### Allowed Exceptions

You may skip strict TDD if:
- It's an **exploratory spike** → Mark with `// SPIKE: remove or test before merge`
- It's **pure configuration** with no conditional logic
- The user **explicitly requests it** with justification
- It's **automatically generated** code
```

### 9.4 Automatic Enforcement

#### TDD Enforcer Persona

`.agent/personas/tdd-enforcer.md`:

```markdown
---
name: tdd-enforcer
description: Verifies TDD compliance before implementation
trigger: before_file_create, before_file_modify
applies_to: <TDD-mandatory paths>
---

# TDD Enforcer

Before creating or modifying files in TDD-mandatory paths:

## Checks

1. **Does a corresponding test exist?**
   - If NOT → Create test first

2. **Does the test cover the planned change?**
   - If it's a new function → Test must exist and fail
   - If it's a modification → Test must cover the modified case

3. **Is the test red?**
   - If it PASSES → The test doesn't specify the new behavior
   - If it FAILS → Proceed with implementation

## Decision Flow

```
Is the file in a TDD-mandatory path?
    │
    ├─ NO → Proceed normally
    │
    └─ YES → Does a corresponding test exist?
              │
              ├─ NO → CREATE TEST FIRST
              │        └─ Run test (must fail)
              │             └─ Implement
              │
              └─ YES → Does the test cover the change?
                        │
                        ├─ NO → UPDATE TEST FIRST
                        │
                        └─ YES → Implement and verify
```
```

### 9.5 TDD Metrics

```yaml
# .agent/config.yaml

testing:
  tdd:
    metrics:
      track: true
      report_path: ".agent/logs/tdd-metrics.md"

    thresholds:
      # Minimum percentage of TDD-mandatory files with tests
      coverage_required: 95
      # Tests must exist before code (measured by git timestamps)
      test_first_ratio: 80
```

---

## 10. Commands and Scripts

### 10.1 Documented Scripts

Define standard commands the agent can use:

```yaml
# Example structure in package.json, Makefile, or equivalent

commands:
  dev: "<start development>"
  build: "<compile for production>"
  test: "<run all tests>"
  test:unit: "<run unit tests>"
  test:integration: "<run integration tests>"
  test:e2e: "<run end-to-end tests>"
  lint: "<check code style>"
  lint:fix: "<auto-fix style>"
  format: "<format code>"
  type-check: "<check types if applicable>"
  validate: "<lint + types + test combined>"
```

### 10.2 Custom Slash Commands

`.agent/commands/test-module.md`:

```markdown
---
name: test-module
description: Run tests for a specific module
---

# Instructions

When the user asks to test a module:

1. Identify the module
2. Run unit tests: `<command> src/{module}/**/*.test.*`
3. If there are failures, analyze and fix
4. Run related integration tests
5. Report results
```

---

## 11. Version Control for Agents

### 11.1 Commit Convention

`.agent/commands/commit.md`:

```markdown
---
name: commit
description: Create commit following conventions
---

# Commit Format

```
<type>(<scope>): <description>

[body]

[footer]
```

## Types
- feat: New feature
- fix: Bug fix
- refactor: Refactoring without functional change
- test: Add or modify tests
- docs: Documentation
- chore: Maintenance

## Example

```
feat(orders): add discount validation

- Validate discount codes against database
- Check expiration and usage limits
- Return clear error messages

Closes #123
```
```

### 11.2 Branching Strategy

```markdown
# docs/architecture/git-workflow.md

## Branches

- `main`: Production, always deployable
- `develop`: Integration (if using GitFlow)
- `feature/*`: New features
- `fix/*`: Bug fixes

## Workflow for Agents

1. Create branch from base: `git checkout -b feature/<ticket>-<description>`
2. Make incremental changes with atomic commits
3. Run validation before each commit
4. Create PR when ready
```

---

## 12. Security and Boundaries

### 12.1 Protected Files

```yaml
# .agent/config.yaml

security:
  # Files that must NEVER be modified without human confirmation
  protected_files:
    - ".env*"
    - "*.pem"
    - "*.key"
    - "<migration directory>/**"
    - "<CI/CD workflows>/**"
    - "<lock files>"

  # Patterns that must never appear in code
  forbidden_patterns:
    - pattern: "<dangerous pattern 1>"
      message: "<explanation>"
    - pattern: "<dangerous pattern 2>"
      message: "<explanation>"

  # Operational limits
  limits:
    max_file_changes_per_commit: 20
    max_lines_per_file: 500
    require_tests_for: ["<critical paths>"]
```

### 12.2 Automatic Security Review

`.agent/personas/security-auditor.md`:

```markdown
---
name: security-auditor
description: Reviews changes for security vulnerabilities
trigger: pre-commit
---

# Security Auditor

Before each commit, verify:

## Checklist

1. **Secrets**: Are there hardcoded credentials?
2. **Injection**: Do queries use parameters?
3. **XSS**: Is user input sanitized?
4. **Auth**: Do protected routes verify authentication?
5. **Validation**: Is all external input validated?

## Severities

- 🔴 CRITICAL: Blocks the commit
- 🟠 HIGH: Requires justification
- 🟡 MEDIUM: Warning, proceed with caution
```

---

## 13. Automatic Review Loop

After an agent makes changes, a review cycle runs automatically until the code is approved. This ensures every change meets quality standards without human intervention at every step.

### 13.1 How the Loop Works

```
Agent makes changes
       │
       ▼
┌─────────────────────┐
│  Run validations     │ ← tests, lint, type-check
│  (automated checks)  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Code Reviewer       │ ← agent switches to reviewer persona
│  analyzes changes    │
└──────────┬──────────┘
           │
     ┌─────┴─────┐
     │            │
  APPROVED    CHANGES REQUESTED
     │            │
     ▼            ▼
  Continue    Agent applies
  (commit     feedback and
   or next    returns to top
   task)      of loop
              (max N iterations)
```

The loop has a configurable maximum number of iterations to prevent infinite cycles. If the reviewer still finds issues after the maximum, the agent stops and asks the human for guidance.

### 13.2 Configuration

```yaml
# .agent/config.yaml

review_loop:
  enabled: true
  max_iterations: 3

  # Automated checks that run before the reviewer persona
  pre_review_checks:
    - command: "<test command>"
      name: "tests"
      required: true          # Blocks review if failing
    - command: "<lint command>"
      name: "lint"
      required: true
    - command: "<type-check command>"
      name: "type-check"
      required: false         # Warning only

  # What the reviewer evaluates
  review_criteria:
    - "Correctness: does the code do what was requested?"
    - "Tests: are new behaviors covered by tests?"
    - "Invariants: are system invariants respected?"
    - "Patterns: does the code follow project patterns from AGENTS.md?"
    - "Security: are there obvious vulnerabilities?"

  # What the reviewer ignores (to avoid nitpicking loops)
  review_ignores:
    - "Formatting and style (handled by linter)"
    - "Minor naming preferences"
    - "Comment wording"

  # When to skip the loop entirely
  skip_for:
    - "docs/**"
    - "*.md"
    - "*.config.*"
```

### 13.3 Code Reviewer Persona

`.agent/personas/code-reviewer.md`:

```markdown
---
name: code-reviewer
description: Reviews changes for correctness, patterns, and quality
trigger: post-change
---

# Code Reviewer

You are reviewing changes made by another agent (or yourself in a previous step).
Your goal is to approve or request concrete improvements.

## Review Process

1. **Read the diff**: Understand what changed and why
2. **Run checks**: Verify tests pass, lint is clean, types are correct
3. **Evaluate against criteria**: Check each item from `review_criteria`
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

### 13.4 Post-Change Hook

`.agent/hooks/post-change.md`:

```markdown
---
name: post-change-review
description: Triggers the review loop after code changes
trigger: after_file_modify, after_file_create
applies_to: "<source paths>"
excludes: "<paths from review_loop.skip_for>"
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

### 13.5 Documenting in AGENTS.md

Add this block to the project's `AGENTS.md`:

```markdown
## Review Loop

After completing changes, switch to the `code-reviewer` persona and review your own work.
Iterate until approved or max iterations (3) reached.

### Cycle
1. Make changes
2. Run: `<test command> && <lint command>`
3. Self-review as code-reviewer persona
4. If issues found → fix and go to step 2
5. If approved → commit

### Review Criteria
- Correctness, test coverage, invariants, project patterns, security
- Ignore: formatting, style, naming preferences (linter handles these)
```

---

## 14. Monitoring and Feedback

### 13.1 Session Logging

```yaml
# .agent/config.yaml

feedback:
  log_sessions: true
  log_path: ".agent/logs/"

  # Common error patterns to document
  common_errors:
    - pattern: "<frequent error 1>"
      solution: "<solution>"
    - pattern: "<frequent error 2>"
      solution: "<solution>"
```

### 13.2 Effectiveness Metrics

```markdown
# .agent/logs/metrics.md

## Last Week

| Metric | Value |
|--------|-------|
| Tasks completed | X |
| Successful commits | X |
| Tests added | X |
| Bugs introduced | X |

## Frequent Errors
1. <Error 1> (X occurrences)
2. <Error 2> (X occurrences)

## Suggested Improvements
- <Improvement based on detected errors>
```

---

## 15. Implementation Checklist

### 15.1 Minimum Viable (Day 1)

- [ ] Create `AGENTS.md` with basic commands and patterns
- [ ] Document technology stack
- [ ] List protected files
- [ ] Add examples of correct vs incorrect code
- [ ] Define TDD-mandatory paths in config

### 15.2 Foundations (Week 1)

- [ ] Create `.agent/` structure
- [ ] Write 3-5 ADRs for main decisions
- [ ] Document critical invariants
- [ ] Configure basic slash commands
- [ ] Document TDD cycle in AGENTS.md
- [ ] Create `tdd-enforcer` persona

### 15.3 Optimization (Month 1)

- [ ] Add per-module AGENTS.md
- [ ] Create specialized personas
- [ ] Document dependency graph
- [ ] Implement effectiveness metrics
- [ ] Configure pre-commit hook for TDD
- [ ] Establish TDD compliance metrics

### 15.4 Maturity (Quarter 1)

- [ ] Tests as executable specification
- [ ] Automated pre-commit hooks
- [ ] Configure automatic review loop
- [ ] Continuous improvement feedback loop
- [ ] Automatically generated documentation
- [ ] 95%+ sustained TDD compliance

---

## 16. Complete Example

Reference repository with this specification implemented:

```
example-dotagent-repo/
├── .agent/
│   ├── config.yaml
│   ├── commands/
│   │   ├── commit.md
│   │   ├── test-module.md
│   │   └── deploy.md
│   ├── skills/
│   │   └── <area>/SKILL.md
│   ├── personas/
│   │   ├── code-reviewer.md
│   │   ├── security-auditor.md
│   │   └── tdd-enforcer.md
│   ├── hooks/
│   │   ├── pre-commit-tdd.md
│   │   └── post-change-review.md
│   └── logs/
│       └── tdd-metrics.md
├── docs/
│   ├── architecture/
│   │   ├── INDEX.md
│   │   ├── 0001-<decision>.md
│   │   ├── 0002-<decision>.md
│   │   └── dependencies.yaml
│   └── invariants/
│       ├── INVARIANTS.md
│       └── <module>.invariants.md
├── src/
│   ├── <module-1>/
│   │   ├── AGENTS.md
│   │   ├── INVARIANTS.md
│   │   ├── handler.ext
│   │   ├── handler.test.ext
│   │   └── examples.ext
│   └── <module-2>/
│       ├── AGENTS.md
│       └── ...
├── tests/
│   ├── integration/
│   ├── e2e/
│   └── fixtures/
├── AGENTS.md
├── README.md
└── <project config>
```

---

## Appendix A: Glossary

| Term | Definition |
|------|------------|
| **ADR** | Architecture Decision Record. A document that captures an architectural decision and its context. |
| **Invariant** | A condition that must remain true at all times in the system. |
| **Slash Command** | A custom command invocable with `/name` in agents. |
| **Skill** | Specialized knowledge packaged for an agent. |
| **Persona** | A configuration that gives the agent a specialized role. |
| **Token** | A unit of text processed by the model (~4 characters). |
| **Context** | Information available to the agent in a session. |
| **TDD** | Test-Driven Development. Writing tests before implementation. |
| **Review Loop** | Automatic cycle where the agent reviews its own changes, fixes issues, and re-reviews until approved or max iterations reached. |

---

## Appendix B: Resources

- [AGENTS.md Standard](https://agentsmd.io)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Architecture Decision Records](https://adr.github.io/)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code)

---

## Appendix C: Implementation Example

For a concrete example of this specification applied to a specific stack (TypeScript + Node.js), see the reference repository or request the generation of a template for your particular stack.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial version (stack-agnostic) |
| 1.1 | 2026-01-30 | Added automatic review loop (section 13) |

---

*This specification is designed to be adapted to any technology stack. The principles are universal; implementation details vary by language and framework.*
