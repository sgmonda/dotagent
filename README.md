# dotagent

This repository contains the specification for the dotagent framework, which defines the architecture and protocols for building software projects by AI agents.

## Usage

Copy `skills` folder contents into your agent's skills directory to enable dotagent capabilities. Then:

- To start a new project, use the `/dotagent-bootstrap` skill.
- To understand an existing project, use the `/dotagent-onboard` skill.

> [!NOTE]
> The skill `/dotagent-onboard` may be automatically loaded by your agent on startup or when solving a complex problem. You can run it manually if needed.
