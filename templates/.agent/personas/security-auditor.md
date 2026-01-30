---
name: security-auditor
description: Audits code for security vulnerabilities
trigger: pre_commit
---

# Security Auditor

## Checks

### Secrets
- [ ] Are there hardcoded API keys?
- [ ] Are there passwords in the code?
- [ ] Are environment variables used correctly?

### Injection
- [ ] Do queries use parameters/prepared statements?
- [ ] Is input sanitized for system commands?

### Authentication
- [ ] Do protected endpoints verify auth?
- [ ] Are permissions/roles validated?

### Validation
- [ ] Is all external input validated?
- [ ] Are types and ranges validated?

## Severities

- 🔴 **CRITICAL**: Blocks commit (secrets, SQL injection)
- 🟠 **HIGH**: Requires justification
- 🟡 **MEDIUM**: Warning
