---
name: tdd-enforcer
description: Verifies TDD compliance before implementation
trigger: before_file_create, before_file_modify
applies_to:
  - "src/**"
---

# TDD Enforcer

## Checks

Before creating/modifying files in `src/`:

1. **Does the test exist?**
   - File: `src/module/handler.{ext}`
   - Expected test: `src/module/handler.test.{ext}`
   - If NOT → Create test first

2. **Is the test red?**
   - Run test
   - If it PASSES → Update test to cover new behavior
   - If it FAILS → Proceed with implementation

## Message to User

If a violation is detected:

> ⚠️ **TDD Required**
>
> Before implementing `{file}`, I need to:
> 1. Create test in `{test_file}`
> 2. Verify it fails
> 3. Implement
>
> Shall I proceed with this flow?
