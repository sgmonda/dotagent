<img width="1800" height="600" alt="header" src="https://github.com/user-attachments/assets/df8b0c2a-e3ab-4bdf-9dbb-6086684c84da" />

# DOTAGENT

**Specification v1.0** — A standard for structuring software repositories optimized for AI agent collaboration.

---

## The Problem

Modern development practices — clean code, SOLID, DRY — were designed for human cognition: long-term memory, implicit context, and the ability to read between the lines. AI agents operate under fundamentally different constraints: no memory between sessions, limited context windows, and a strict dependence on what is explicitly written.

DOTAGENT bridges this gap. It defines a repository structure that maximizes agent effectiveness without sacrificing human maintainability.

## What DOTAGENT Defines

- **`.agent/` directory** — Centralized agent configuration: commands, skills, personas, and hooks.
- **`AGENTS.md` hierarchy** — Layered instructions from project-wide rules to module-specific overrides, following a locality principle.
- **Architecture Decision Records (ADRs)** — Structured capture of the *why* behind decisions, critical for agents that lack cross-session memory.
- **System invariants** — Hard boundaries that must never be violated, with concrete code examples.
- **TDD-first workflow** — Tests as verifiable contracts that anchor agent reasoning and prevent functional hallucinations.
- **Security boundaries** — Protected files, forbidden patterns, and operational limits.

## Getting Started

Copy the contents of the `skills/` directory into your agent's skills folder, then:

- **`/dotagent-bootstrap`** (*"use dotagent skill to bootstrap a project"*) — Initialize a new project following the specification. Supports Python+FastAPI, Go+Gin, TypeScript+Node, Rust, and Java+Spring.
- **`/dotagent-onboard`** (*"use dotagent skill to onboard this project"*) — Analyze an existing project and generate a structured agent briefing.

> [!NOTE]
> The `/dotagent-onboard` skill may be automatically loaded by your agent on startup or when addressing a complex task. It can also be invoked manually at any time.

## Repository Structure

```
dotagent/
├── doc/
│   └── DOTAGENT.md          # Full specification (~1077 lines)
├── skills/
│   ├── dotagent-bootstrap-SKILL.md
│   └── dotagent-onboard-SKILL.md
└── .agent/                   # Example agent configuration
```

## Documentation

The complete specification is available at [`doc/DOTAGENT.md`](doc/DOTAGENT.md). It covers directory structure, agent configuration, documentation standards, testing strategy, TDD enforcement, and security boundaries.

The complete specification is written in English.

## License

This project is open source. See [LICENSE](LICENSE) for details.
