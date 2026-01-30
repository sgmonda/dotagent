---
name: commit
description: Create commit following conventions
---

# Format

```
<type>(<scope>): <description>

[body]

[footer]
```

## Types
- feat: New feature
- fix: Bug fix
- refactor: Refactoring
- test: Tests
- docs: Documentation
- chore: Maintenance

## Process

1. Verify that tests pass
2. Run lint
3. Create commit with descriptive message
4. Scope = affected module
