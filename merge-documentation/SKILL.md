---
name: merge-documentation
description: Documents what shipped to the default branch after 
a PR merge. 
Reads the PR details, end-session report, and code review 
findings to produce a clean merge record and update CLAUDE.md 
where needed. Designed to run as a post-merge routine in a 
fresh session.
disable-model-invocation: true
---

# Merge Documentation

This skill documents what shipped to the default branch 
(e.g., main or master) after a PR is merged. 
It runs in a fresh session triggered by a PR merge event. It 
reads the PR details, end-session report, and code review 
findings to produce a clean permanent record of what was built 
and shipped, and updates CLAUDE.md files to reflect any new 
API endpoints, dependencies, or architectural decisions.

This skill never modifies implementation files. Its outputs are 
a merge record saved to docs/releases/, any necessary CLAUDE.md 
updates, and archived working documents.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- Never modify any implementation or code files
- Derive everything from the PR details, end-session 
  report, code review findings, and planning documents — 
  never invent or assume
- If source documents are missing or incomplete, 
  note the gap and proceed with what is available
- All output files are committed to the default 
  branch — this is 
  the permanent project record
- This push contains documentation changes only — 
  no implementation changes

## Step 1 — Read all context
Read the following before doing anything else:
- CLAUDE.md files available in context
- PR details — title, description, URL, commits, 
  files changed, PR review comments and 
  reviewer decisions
- End-session report from docs/reports/
- Code review findings from docs/reports/
- Feature brief from docs/briefs/ if available
- Execution plan from docs/plans/ if available
- Most recent previous merge record from 
  docs/releases/ — to understand what was 
  previously shipped and avoid duplicating 
  entries in the build plan

If any source documents are missing, note which 
ones and proceed with what is available.

State what you have read and proceed immediately 
to Step 2.

## Step 2 — Summarise what shipped
Using the PR details and source documents, 
produce a plain English summary of what shipped:

- What functionality was delivered
- Which files were changed
- How this relates to the build plan — 
  which planned functionality does this complete?
- Whether all acceptance criteria were met — 
  from the code review findings
- Whether this merge completes an entire Must Have 
  set or is part of a larger group of Must Haves 
  still in progress
- Any known issues or tech debt that shipped 
  with this merge — from the end-session report 
  and code review findings
- Any open questions that remain unresolved

Code review warnings reconciliation — if the latest 
code review findings carried warnings (AMBER 
recommendation), state the outcome of EACH warning:
- Fixed — with the commit that fixed it
- Accepted by reviewer — with the reviewer's 
  reasoning from PR comments, if available
- Deferred — also record it under Known issues 
  and tech debt

If the recommendation was GREEN with no warnings, 
state "No warnings to reconcile."

## Step 3 — Update build plan status
Check whether a build plan exists in docs/build-plan/.
If no build plan exists, note this and skip 
to Step 4.

If a build plan exists, update the status of 
any functionality completed by this merge:

For each functionality completed:
- Mark as shipped with the merge date
- Note the PR title and URL
- Note the merge record filename for traceability
- Note any acceptance criteria that were 
  partially met, not met, or deferred

Do not remove anything from the build plan — 
only add status updates.

## Step 4 — Produce the merge record
Write a structured merge record:

---
Merge Record
Date: YYYY-MM-DD
PR: [PR title]
PR URL: [PR URL if available]
Branch merged: [branch name]
Merged to: [default branch]
Feature brief: [brief filename if applicable]

## What shipped
Plain English summary of what was delivered 
in this merge — written for anyone reading 
the project history, not just the current team.

## Functionality completed
List of build plan items completed by this merge.
For each:
- Functionality name
- Acceptance criteria status — Met / Partial / 
  Not met / Deferred (Deferred = intentionally 
  descoped)
- Reference to feature brief and execution plan

## Must Have completion status
Is this merge part of a Must Have set that is 
now fully complete? Or are there remaining 
Must Haves still to build?
State clearly so the next session knows 
where things stand.

## Files changed
Complete list of files added or modified, 
with a plain English description of what 
changed in each.

## Code review warnings reconciliation
If the latest code review findings carried warnings 
(AMBER recommendation), the outcome of each warning:
- Fixed — with the commit that fixed it
- Accepted by reviewer — with the reviewer's 
  reasoning from PR comments, if available
- Deferred — also recorded under Known issues 
  and tech debt
If the recommendation was GREEN with no warnings: 
state "No warnings to reconcile."

## Known issues and tech debt
Any issues or tech debt that shipped with 
this merge — carried over from the end-session 
report and code review findings.
For each:
- What it is in plain English
- Where it is
- Priority — should be addressed soon / 
  can wait / low priority

## Open questions
Any questions that remain unresolved after 
this merge. Tag each with who needs to 
answer and whether it is blocking future work.

## Build plan status
Updated status of all build plan items 
affected by this merge.

## CLAUDE.md updates
List of any CLAUDE.md changes made as a 
result of this merge — see Step 5.
If none: state "No CLAUDE.md updates required."
---

## Step 5 — Update CLAUDE.md files
Review the merged changes and identify whether 
any CLAUDE.md files need updating.

Check for:
- New API endpoints added — update the 
  "Current API endpoints" section in the 
  relevant repo CLAUDE.md using the format:
  `- METHOD /path/endpoint — description 
  (added YYYY-MM-DD)`
- New dependencies introduced — update the 
  tech stack section in the relevant repo CLAUDE.md
- Architectural decisions made — update the 
  relevant CLAUDE.md with any decisions that 
  future sessions should know about
- New patterns established — update the 
  relevant CLAUDE.md so future sessions 
  follow them correctly
- Anything in the end-session report's 
  "Decisions and reasoning" section that 
  should be permanent project knowledge

Make the updates directly to the relevant 
CLAUDE.md files.
Document every change made in the merge 
record's "CLAUDE.md updates" section.
If no updates are needed, state this clearly 
in the merge record.

## Step 6 — Archive working documents
Use git mv to move the following documents 
to docs/archive/ — this preserves file 
history in git log:
- End-session report for this branch
- Code review findings for this branch
- Feature brief for this branch
- Execution plan for this branch

This keeps docs/reports/, docs/briefs/, and 
docs/plans/ clean — only active documents 
remain in those folders.

Archive only documents that exist in this 
repository. If a referenced document (for example 
the feature brief or build plan) lives in another 
repository, do not attempt to archive or modify 
it — note its location and status in the merge 
record instead.

If docs/archive/ does not exist, create it.
Confirm what was archived.

## Step 7 — Save and commit
Save the merge record to:
docs/releases/[date]-[branch-name]-merge.md

If docs/releases/ does not exist, create it.

Before committing, verify the diff contains only 
files under docs/ and CLAUDE.md files. If anything 
else appears in the diff, abort — do not commit 
or push — and report to the user exactly what 
unexpected files were found.

Exception to pm-guardrails: the approval-before-commit 
and approval-before-push rules are waived for this 
skill's own documentation-only commit and push, 
provided the self-check above passes. This skill 
is designed to run unattended.

Commit all changes — merge record, archived 
documents, build plan updates, and any 
CLAUDE.md updates — with this message:

If CLAUDE.md was updated:
docs: merge record and CLAUDE.md update for 
[branch-name] [date]

If CLAUDE.md was not updated:
docs: merge record for [branch-name] [date]

Push to the default branch — this push contains 
documentation changes only.
Confirm the push was successful.