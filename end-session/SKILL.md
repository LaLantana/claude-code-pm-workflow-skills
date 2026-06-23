---
name: end-session
description: Documents what was built in the current session, 
surfaces tech debt and outstanding questions, and produces a 
context document for the code-review routine. Invoke at the 
end of every Build session after pre-commit and before pre-push.
disable-model-invocation: true
---

# End Session

This skill documents the current Build session while full context 
is still available. It produces a structured report saved to 
docs/reports/ that is committed and pushed as part of the session's 
push. The code-review routine reads this report in a fresh session 
after the push.

This skill never modifies implementation files. The only files 
it creates or modifies are the end-session report and any 
documentation updates.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- Never modify any implementation or code files
- Document what actually happened — not what was planned
- If something is unclear, note it as an open question 
  rather than guessing
- This skill produces a report only — it does not make 
  recommendations for fixes or improvements. That is the 
  code-review routine's responsibility
- The report must be committed before pre-push runs

## Step 1 — Read context
Read the following before doing anything else:
- CLAUDE.md files available in context
- The execution plan for this session from docs/plans/
- The feature brief for this session from docs/briefs/ 
  if available
- Any previous end-session reports in docs/reports/ 
  for continuity

State what you have read and proceed immediately 
to Step 2.

## Step 2 — Document the session
Using full session memory, document what happened 
in this Build session. Verify against git state 
to confirm accuracy.

Identify and state:
- Which branch was worked on
- What commits were made — list each with its 
  message and a plain English summary
- Which files were created or modified
- What functionality was implemented
- Whether all planned steps in the execution plan 
  were completed
- Any steps that were not completed and why

If there is a discrepancy between the execution plan 
and what was actually built, note it explicitly 
and explain why.

## Step 3 — Document decisions and reasoning
Using session memory, capture:

- Key decisions made during implementation and why
- Approaches that were tried and abandoned — 
  what was attempted, why it didn't work, 
  what was chosen instead
- Any significant problems encountered and 
  how they were resolved
- Any constraints or discoveries that affected 
  the implementation
- Anything that future sessions should know about 
  the decisions made here

This section is only fully capturable in the same 
session — document it thoroughly.

## Step 4 — Assess completion
Using session memory and the feature brief, assess 
each acceptance criterion definitively:

For each acceptance criterion state:
- Criterion: [description]
- Status: Met / Partial / Not met
- Evidence: what was built that addresses it
- Notes: any relevant context

If a criterion is partial or not met, explain 
what remains to be done.

## Step 5 — Surface tech debt and pending items
Identify and list:

**Tech debt:**
Any shortcuts, workarounds, or incomplete implementations 
from this session. For each:
- What it is in plain English
- Where it is — file and approximate location
- Why it was done this way
- What the clean solution would be

**Pending changes:**
Any items from the execution plan not completed 
in this session. Any open questions from the 
execution plan that were not resolved.

**Outstanding questions:**
Anything requiring input from the user or a 
specialist before the next session begins.
Tag each as blocking or non-blocking and note 
who needs to answer.

## Step 6 — Produce the report
Write a structured end-session report:

---
End Session Report
Date: YYYY-MM-DD
Branch: [branch name]
Execution plan: [plan filename]
Feature brief: [brief filename if applicable]

## Session summary
Plain English summary of what was built — 
two to three sentences.

## Commits
List of commits with short hash, message, and 
one-line plain English summary of each.

## Files changed
Complete list of files created or modified with 
a plain English description of what changed in each.

## Decisions and reasoning
Key decisions made, approaches tried and abandoned, 
problems encountered and resolved. Captured from 
session memory — this section provides critical 
context for future sessions.

## Acceptance criteria status
For each criterion from the feature brief:
- Criterion: [description]
- Status: Met / Partial / Not met
- Evidence: [what was built]
- Notes: [any relevant context]

## Tech debt
Shortcuts or incomplete implementations from 
this session. Each item includes what it is, 
where it is, why it was done this way, and 
what the clean solution would be.

## Pending changes
Planned items not completed in this session.

## Outstanding questions
Questions requiring input before the next session.
Tag each as blocking or non-blocking and note 
who needs to answer.

## Context for code review
A focused summary of what the code-review routine 
should pay attention to — derived from the above.
Include:
- Areas of particular complexity or risk
- Any shortcuts or workarounds that warrant 
  closer scrutiny
- Specific acceptance criteria the reviewer 
  should verify carefully
- Any known edge cases or failure modes to check
---

## Step 7 — Save and commit the report
Save the report to:
docs/reports/end-session-[branch-name]-[date].md
(replace any / in the branch name with - for the 
filename, e.g. feature/login → feature-login)

If docs/reports/ does not exist, create it.
Confirm where the file was saved.

Before committing, verify the diff contains only 
files under docs/ and CLAUDE.md files. If anything 
else appears in the diff, abort — do not commit 
or push — and report to the user exactly what 
unexpected files were found.

Exception to pm-guardrails: the approval-before-commit 
rule is waived for this skill's own documentation-only 
commit, provided the self-check above passes. This 
skill is designed to run unattended.

Commit the report immediately with this commit message:
docs: end-session report for [branch-name] [date]

Confirm the commit was successful.

The report is now ready for pre-push to push 
to GitHub where the code-review routine will 
read it after the push triggers.