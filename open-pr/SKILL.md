---
name: open-pr
description: Drafts a PR description from session documents and 
opens a pull request. Invoke after code-review findings are clean 
or findings have been addressed. Never auto-invokes.
disable-model-invocation: true
---

# Open PR

This skill drafts a pull request description from the end-session 
report, code review findings, and planning documents, then opens 
the PR on GitHub. It confirms everything is in order before 
opening and waits for explicit user approval at every step.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- Never open a PR without explicit user approval
- Never open a PR if blocking issues exist in the 
  code review findings
- Never open a PR directly to the default branch 
  (e.g., main or master) from a feature or fix 
  branch without user confirmation
- Derive the PR description entirely from existing 
  documents — never invent content

## Step 1 — Read all context
Read the following before doing anything else:
- CLAUDE.md files available in context
- Code review findings from docs/reports/
- End-session report from docs/reports/
- Feature brief from docs/briefs/ if available
- Execution plan from docs/plans/ if available
- Build plan from docs/build-plan/ if available

State what you have read and proceed immediately 
to Step 2.

## Step 2 — Confirm readiness
Before proceeding, confirm:

- The code review verdict, using the traffic-light 
  system from the code review findings:
  - 🟢 GREEN — Ready for PR: proceed.
  - 🟡 AMBER — Proceed with caution: proceed, but 
    the warnings from the findings MUST be carried 
    into the "Notes for reviewer" section of the 
    PR description, and flagged explicitly to the 
    user before the PR is opened.
  - 🔴 RED — Do not proceed: stop immediately and 
    tell the user. Do not open a PR until the 
    findings are addressed and a new code review 
    has been run.
- The branch is not the default branch 
  (e.g., main or master).

If the verdict is RED or the branch is the default 
branch, stop and tell the user what needs to be 
resolved before a PR can be opened.

## Step 3 — Draft the PR description
Using the session documents, draft a PR description 
that gives the reviewer everything they need to 
understand and evaluate the changes.

### What this PR does
Plain English summary of what was built — 
two to three sentences. Written for a developer 
reviewer who has no prior context.

### Why
The problem this solves and why it matters — 
traced back to the feature brief goal.

### What changed
List of key changes in plain English.
One item per significant change.
No technical jargon unless necessary.

### Acceptance criteria
List of acceptance criteria from the feature brief 
and their status:
- [criterion] — Met / Partial / Not met / Deferred 
  (Deferred means intentionally descoped)
Note any criteria that were deferred and why.

### Test coverage
What tests were written and what they verify.

### Known issues and tech debt
Any issues or tech debt that ships with this PR — 
carried over from the end-session report.
If none: state "None."

### Notes for reviewer
Anything the reviewer should pay particular 
attention to — derived from the code review 
findings and end-session report.
Highlight any decisions that were beyond PM scope 
and may warrant closer developer scrutiny.

Present the draft PR description to the user.
Wait for approval or amendment before proceeding.

## Step 4 — Confirm PR details
Before opening, confirm with the user:

- Base branch — which branch to merge into.
  Default is the repository's default branch 
  (e.g., main or master) unless the user 
  specifies otherwise.
- PR title — suggest a title based on the 
  feature brief goal and branch name:
  [type]: [plain English description of what shipped]
  Where type is feat, fix, docs, or refactor.
- Reviewers — who should be requested to review?
  If none specified, open without assigned reviewers.
- Labels — any labels to apply? If none, skip.

Wait for user confirmation of all details 
before proceeding.

## Step 5 — Open the PR
After user confirms all details:
- State exactly what you are about to do — 
  branch, base, title, reviewers
- Wait for final explicit confirmation
- Open the PR using GitHub CLI:
  gh pr create
- Confirm the PR was created successfully
  and provide the PR URL

If the PR cannot be opened, state the error 
in plain English and suggest the user open 
it manually at:
github.com/[org-or-username]/[repo]/compare/[branch]

If the merge-documentation routine has been 
configured, it will trigger automatically 
when this PR is merged.

Any further changes to address reviewer feedback 
should be made on the same branch and pushed — 
the PR will update automatically.

## Step 6 — Post code review link
After the PR is opened successfully, post a 
comment on the PR linking to the code review 
findings document:

"Automated pre-PR review findings available at:
docs/reports/[code-review-filename]"

This gives the reviewer direct access to the 
automated review without navigating the repo.

Confirm the comment was posted successfully.
If posting fails, tell the user and provide 
the file path so they can share it manually.