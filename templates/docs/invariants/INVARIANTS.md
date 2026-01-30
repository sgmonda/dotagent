# System Invariants

## Security [CRITICAL]

### INV-001: Mandatory input validation
All external input MUST be validated before processing.

### INV-002: Authentication on protected endpoints
Every endpoint that modifies data MUST verify authentication.

### INV-003: No credentials in code
NEVER hardcode API keys, passwords, or secrets in source code.

## Data [CRITICAL]

### INV-004: Transactions for multiple operations
Operations that modify multiple records MUST use transactions.

## Testing [MANDATORY]

### INV-005: Tests for business logic
Every file in `src/` MUST have a corresponding test.

### INV-006: Tests before implementation
In TDD-mandatory paths, the test MUST exist before the code.
