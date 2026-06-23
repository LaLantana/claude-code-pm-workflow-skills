---
name: pre-commit
description: Runs scope, sensitive data, and test checks before 
committing. Invoke after implementation is complete and UAT has 
been confirmed. Never auto-invokes.
disable-model-invocation: true
---

# Pre-Commit

This skill runs a structured check before any commit is made. 
It never modifies code. It surfaces issues, proposes a commit 
message, and waits for explicit user approval before committing.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- Never commit without explicit user approval
- Never modify any code or file contents during this check
- If any check fails, stop and surface the issue clearly 
  before proceeding
- Never approve a commit on the user's behalf

## Step 1 — Confirm branch
State which branch you are on.
If on the default branch (e.g., main or master), 
stop immediately — commits must never go directly 
to the default branch.
Wait for user instruction before doing anything else.

## Step 2 — Run tests and checks, confirm UAT
Look up the test, typecheck, and lint commands 
documented in the repository's CLAUDE.md.

Run each documented command and report the results 
in plain English — what passed, what failed, and 
what the failures mean.

If no test or check commands are documented in 
CLAUDE.md, ask the user how to run them, and flag 
that they should be documented in CLAUDE.md.

If any test or check fails, stop and surface the 
failure clearly — do not proceed.

UAT remains a human gate. Ask the user to confirm 
the UAT checklist has been completed.
Do not proceed until the user explicitly confirms.
If it has not been completed, stop and tell the user 
what needs to be done before committing.

## Step 3 — Confirm execution plan exists
Check that an execution plan exists in docs/plans/ 
(relative to the repository root) for this 
session's work.

If multiple plan files exist, ask the user which one 
applies to this commit before proceeding.

If no execution plan exists, stop and tell the user — 
the scope check cannot run without a plan to compare against.
Ask the user how to proceed.

## Step 4 — Scope check
Read the confirmed execution plan.

List every changed file and for each state:
- File name and path
- What changed — plain English, no jargon
- Whether this change was part of the execution plan

Flag any files changed that were not in the execution plan.
For each unexpected change:
- Explain what it is in plain English
- Ask the user whether to include it in this commit 
  or revert it

Do not proceed until all unexpected changes are resolved.

## Step 5 — Sensitive data check
Scan all changed files for:
- API keys, tokens, or credentials
- Passwords or secrets
- Hardcoded URLs containing credentials
- Any value that looks like it belongs in .env 
  rather than in code
- console.log or debug statements left in the code

If anything is found, stop immediately and flag it 
clearly to the user before proceeding.
Never proceed with a commit containing sensitive data.

## Step 6 — Propose commit message
Propose a commit message in conventional commit format:

[type]: [short description of what changed and why]

Type options:
- feat — new functionality
- fix — corrects a problem
- docs — documentation only
- refactor — code restructure without behaviour change
- chore — maintenance, dependencies, configuration
- test — adding or updating tests

Rules:
- Start with a verb — add, fix, update, connect, remove
- Describe the WHY not just the WHAT
- Keep under 72 characters
- Lowercase throughout

If the changes span multiple concerns, propose 
splitting into multiple commits — one per concern.

Present the proposed message and wait for user 
approval or amendment.

## Step 7 — Commit
After user approves the commit message:
- State exactly what you are about to commit 
  in plain English
- Wait for final explicit confirmation
- Run the commit
- Confirm the commit was successful with the 
  commit hash