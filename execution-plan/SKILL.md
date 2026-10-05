---
name: execution-plan
description: Produces a technical step-by-step implementation plan 
before any code is written. Invoke at the start of a Build or Fix 
session, or when a course correction is needed mid-session.
disable-model-invocation: true
---

# Execution Plan

This skill produces a technical HOW document before any code is 
written. Feature briefs and build plans are inputs to this skill — 
this is the step-by-step technical implementation plan that 
bridges planning and execution.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

All pm-guardrails rules apply throughout execution after this 
plan is approved.

## Absolute rules
- Never begin implementation before the plan is approved
- Never make assumptions about scope — derive everything 
  from the provided context
- If blocking open questions exist in the provided context, 
  stop and surface them before producing the plan
- After approval, the first act of execution is creating 
  the suggested branch — no implementation files are 
  touched before the branch exists (the plan document 
  itself, saved in Step 4, is the only exception)

## Step 1 — Read all provided context
Read every document listed in the invocation prompt 
before doing anything else.
Also read CLAUDE.md files if not already loaded.

State what you have read in a brief list and proceed 
immediately to Step 2.

## Step 2 — Identify scope
Based on the context provided, identify and state 
in plain English:
- What is being built or fixed — one clear sentence
- What is explicitly out of scope
- Which files will be affected
- Which repos are affected — one or more
- Any dependencies or prerequisites that must be 
  in place before execution begins
- Any unknowns or risks that could affect the plan

If blocking open questions exist in the provided 
context, stop here and surface them to the user.
Do not proceed until blocking questions are resolved.

If anything else is unclear, ask the user before 
proceeding to Step 3.
Do not make assumptions about scope.

## Step 3 — Produce the plan document
Write a structured plan document using this format:

---
Plan: [feature or fix name]
Date: YYYY-MM-DD
Session type: Feature / Fix / Course correction
Goal: [one sentence]

## Out of scope
What this plan explicitly does not cover.

## Files affected
List every file that will be created or modified,
and what will change in each.

## Prerequisites
Anything that must be in place before 
execution begins.

## Suggested branch
Feature session → feature/[descriptive-name]
Fix session addressing code-review findings → the branch 
  under review, named in the findings; stay on it, do 
  not create a new branch
Standalone fix with no branch under review → fix/[descriptive-name]
Course correction → fix/[descriptive-name]-correction
Concise, lowercase, hyphenated, reflects the goal.

## Implementation steps
For each step:
Step [N]: [plain English description of what to do]
Files touched: [list]
Verify: [how to confirm this step succeeded 
before moving to the next one]

## Risks and unknowns
Anything that could go wrong or requires a 
decision during execution.

## Open questions
Anything requiring input from the user or a 
specialist before or during execution.
Tag each as blocking or non-blocking.
---

## Course correction handling
If session type is Course correction:
- State clearly what was being attempted and 
  why it is no longer viable
- Add to the plan document header:
  Supersedes: [original plan filename]
- The original plan is preserved in git history — 
  do not delete it
- Scope the new plan only to what has changed — 
  do not re-plan work that was already completed 
  successfully

## Step 4 — Save the document
Save the plan document to:
docs/plans/[functionality-name]-execution-plan.md
(path relative to the repository root)

If a course correction, save as:
docs/plans/[functionality-name]-execution-plan-v2.md
(increment version number for subsequent corrections)

If docs/plans/ does not exist, create it.
Confirm to the user where the file was saved.

## Step 5 — Present and wait
Present the full plan in the chat.
Do not summarise — show everything.

Stop completely and wait for explicit approval 
before doing anything else.

If the user requests changes, update the document 
and wait for approval again.

After approval:
- Create the suggested branch as the very 
  first action (for a Fix session on the branch 
  under review, confirm you are on it instead)
- Do not touch any implementation files before 
  the branch exists (the saved plan document is 
  the only file that already exists)
- Confirm branch creation to the user
- Then proceed with Step 1 of the implementation 
  plan