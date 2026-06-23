---
name: pre-push
description: Runs a final check before pushing to GitHub. Invoke 
after pre-commit and end-session are complete and you are ready 
to push. Never auto-invokes.
disable-model-invocation: true
---

# Pre-Push

This skill runs a lightweight check before pushing to GitHub. 
It confirms what will be pushed, runs a final sensitive data 
scan, and waits for explicit user approval before pushing.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- Never push without explicit user approval
- Never push directly to the default branch 
  (e.g., main or master)
- If any check fails, stop and surface the issue clearly 
  before proceeding
- Never approve a push on the user's behalf

## Step 1 — Confirm branch
State which branch you are about to push and to which remote.
If on the default branch (e.g., main or master), 
stop immediately.
Wait for user instruction before doing anything else.

## Step 2 — Summarise commits
List all commits that will be pushed to GitHub.
For each commit state:
- Commit hash (short)
- Commit message
- Files changed
- One-line plain English summary of what this 
  commit does

Present this summary and ask the user to confirm 
this is the correct set of commits before proceeding.

## Step 3 — Final sensitive data check
Run a final scan across all commits being pushed 
for any sensitive data that may have been missed 
in the pre-commit check:
- API keys, tokens, or credentials
- Passwords or secrets
- Hardcoded values that belong in .env
- Any .env files accidentally staged

If anything is found, stop immediately and flag it 
clearly before proceeding.
Never push sensitive data under any circumstances.

## Step 4 — Push
After user confirms the commit summary is correct:
- State exactly what branch is being pushed 
  and to which remote (origin)
- Wait for final explicit user confirmation
- Run the push
- Confirm the push was successful
- Provide the GitHub branch URL if available

If the code-review routine has been configured, it will 
trigger automatically after this push.