---
name: post-change-review
description: Triggers the automatic review loop after code changes
trigger: after_file_modify, after_file_create
applies_to:
  - "src/**"
excludes:
  - "docs/**"
  - "*.md"
  - "*.config.*"
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
