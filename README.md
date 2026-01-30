<img width="1800" height="600" alt="header" src="https://github.com/user-attachments/assets/df8b0c2a-e3ab-4bdf-9dbb-6086684c84da" />

<div align="center">

# DOTAGENT

**A standard for structuring software repositories optimized for AI agent collaboration.**

[![Spec](https://img.shields.io/badge/spec-v1.2-blue?style=flat-square)](doc/DOTAGENT.md)
[![License](https://img.shields.io/badge/license-open%20source-green?style=flat-square)](LICENSE)

</div>

---

## The Problem

Modern development practices — clean code, SOLID, DRY — were designed for **human cognition**: long-term memory, implicit context, and the ability to read between the lines.

AI agents operate under fundamentally different constraints:

- **No memory** between sessions
- **Limited context windows**
- **Strict dependence** on what is explicitly written

DOTAGENT bridges this gap. It defines a repository structure that maximizes agent effectiveness without sacrificing human maintainability.

## What DOTAGENT Defines

| Concept | Description |
|---|---|
| **`.agent/` directory** | Centralized agent configuration: commands, skills, personas, and hooks |
| **`AGENTS.md` hierarchy** | Layered instructions from project-wide rules to module-specific overrides, following a locality principle |
| **ADRs** | Structured capture of the *why* behind decisions — critical for agents that lack cross-session memory |
| **System invariants** | Hard boundaries that must never be violated, with concrete code examples |
| **TDD-first workflow** | Tests as verifiable contracts that anchor agent reasoning and prevent functional hallucinations |
| **Automatic review loop** | After every change, the agent self-reviews and iterates until approved or a max limit is reached |
| **Security boundaries** | Protected files, forbidden patterns, and operational limits |

## Quick Start

Copy the contents of the `skills/` directory into your agent's skills folder (`.agent/skills/`), then use the following skills:

```
/dotagent-bootstrap     # Initialize a new project following the spec
/dotagent-onboard       # Analyze an existing project and generate an agent briefing
/dotagent-upgrade       # Upgrade to the latest spec version (non-destructive)
```

Supported stacks: **Python + FastAPI** · **Go + Gin** · **TypeScript + Node** · **Rust** · **Java + Spring**

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
> curl -fsSL https://raw.githubusercontent.com/sgmonda/dotagent/main/skills/dotagent-upgrade-SKILL.md \
>   -o .agent/skills/dotagent-upgrade-SKILL.md
> # then ask your agent: "run /dotagent-upgrade"
> ```

### Claude Code Setup

Claude Code looks for skills in `.claude/skills/`, not `.agent/skills/`. Create a symlink so both paths resolve:

```bash
mkdir -p .claude
ln -s ../.agent/skills .claude/skills
```

Commit the symlink to the repository.

## Repository Structure

```
dotagent/
├── doc/
│   └── DOTAGENT.md              # Full specification
├── skills/
│   ├── dotagent-bootstrap-SKILL.md
│   ├── dotagent-onboard-SKILL.md
│   └── dotagent-upgrade-SKILL.md
└── .agent/                      # Example agent configuration
```

## Documentation

The complete specification is available at [`doc/DOTAGENT.md`](doc/DOTAGENT.md). It covers directory structure, agent configuration, documentation standards, testing strategy, TDD enforcement, automatic review loops, and security boundaries.

## License

This project is open source. See [LICENSE](LICENSE) for details.
