<img width="1800" height="600" alt="header" src="https://github.com/user-attachments/assets/df8b0c2a-e3ab-4bdf-9dbb-6086684c84da" />

# DOTAGENT

A standard for structuring software repositories optimized for AI agent collaboration.

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
- **Automatic review loop** — After every change, the agent self-reviews as a code reviewer persona, iterating until the code is approved or a max iteration limit is reached.
- **Security boundaries** — Protected files, forbidden patterns, and operational limits.

## Getting Started

Copy the contents of the `skills/` directory into your agent's skills folder (`.agent/skills/`), then:

- **`/dotagent-bootstrap`** (*"use dotagent skill to bootstrap a project"*) — Initialize a new project following the specification. Supports Python+FastAPI, Go+Gin, TypeScript+Node, Rust, and Java+Spring.
- **`/dotagent-onboard`** (*"use dotagent skill to onboard this project"*) — Analyze an existing project and generate a structured agent briefing.
- **`/dotagent-upgrade`** (*"use dotagent skill to upgrade this project"*) — Upgrade an existing DOTAGENT project to the latest spec version. Non-destructive: only adds what's missing, never overwrites customizations.

> [!NOTE]
> The `/dotagent-onboard` skill may be automatically loaded by your agent on startup or when addressing a complex task. It can also be invoked manually at any time.

> [!TIP]
> **Updating existing projects:** Every bootstrapped project includes a `scripts/dotagent-update.sh` script that fetches the latest skills from this repository. Run it, then ask your agent to run `/dotagent-upgrade`:
> ```bash
> bash scripts/dotagent-update.sh
> # then ask your agent: "run /dotagent-upgrade"
> ```
> If your project was created before this mechanism existed, just download the script manually:
> ```bash
> curl -fsSL https://raw.githubusercontent.com/sgmonda/dotagent/main/skills/dotagent-upgrade-SKILL.md -o .agent/skills/dotagent-upgrade-SKILL.md
> # then ask your agent: "run /dotagent-upgrade"
> ```

### Claude Code Setup

Claude Code looks for skills in `.claude/skills/`, not `.agent/skills/`. Create a symlink so both paths point to the same place:

```bash
mkdir -p .claude
ln -s ../.agent/skills .claude/skills
```

This way skills are maintained in `.agent/skills/` (the DOTAGENT standard location) and Claude Code picks them up automatically. The symlink should be committed to the repository.

## Repository Structure

```
dotagent/
├── doc/
│   └── DOTAGENT.md          # Full specification (~1077 lines)
├── skills/
│   ├── dotagent-bootstrap-SKILL.md
│   ├── dotagent-onboard-SKILL.md
│   └── dotagent-upgrade-SKILL.md
└── .agent/                   # Example agent configuration
```

## Documentation

The complete specification is available at [`doc/DOTAGENT.md`](doc/DOTAGENT.md). It covers directory structure, agent configuration, documentation standards, testing strategy, TDD enforcement, automatic review loops, and security boundaries.

The complete specification is written in English.

## License

This project is open source. See [LICENSE](LICENSE) for details.
