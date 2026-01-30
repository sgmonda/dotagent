# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DOTAGENT is a specification and reference framework (v1.0) that defines how to structure software repositories for effective AI agent collaboration. It is not an application — it contains no executable code, no build system, and no tests. The repository holds markdown specifications, reusable agent skills, and reference templates.

The specification is written in English.

## Repository Structure

- `doc/DOTAGENT.md` — The core specification (~1077 lines), covering directory structure, agent configuration, documentation standards, testing strategy, and security boundaries for agent-optimized projects.
- `skills/dotagent-bootstrap-SKILL.md` — Skill for initializing new projects following the spec (supports Python+FastAPI, Go+Gin, TypeScript+Node, Rust, Java+Spring).
- `skills/dotagent-onboard-SKILL.md` — Skill for analyzing existing projects and generating agent briefings.
- `.agent/` — Example agent configuration directory.

## Key Concepts

- **`.agent/` directory**: Per-project agent configuration holding `config.yaml`, custom commands, personas, skills, and hooks.
- **`AGENTS.md` hierarchy**: Root-level sets project-wide rules; module-level files override locally. Must stay under 2000 tokens.
- **ADRs** (`docs/architecture/ADR-*.md`): Capture architectural decisions with context, consequences, and alternatives — critical since agents lack cross-session memory.
- **Invariants** (`docs/invariants/INVARIANTS.md`): Rules that must never be violated, with concrete examples.
- **TDD-first**: Tests define contracts before implementation; the spec treats this as mandatory for agent-assisted development.
- **Locality principle**: Documentation and rules are placed near the code they govern; nearest AGENTS.md wins.

## Working in This Repository

There are no build, test, or lint commands. All content is markdown and JSON configuration. Changes should maintain consistency with the specification structure.
