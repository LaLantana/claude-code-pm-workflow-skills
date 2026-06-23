---
name: code-review
description: Adversarial pre-PR review of code changes after a 
push. Reads the end-session report and reviews changes against 
CLAUDE.md conventions, security rules, and acceptance criteria. 
Produces a structured findings report. Can run as a post-push 
routine or be invoked manually.
disable-model-invocation: true
---

# Code Review

This skill performs an adversarial pre-PR review of code changes 
after a push to GitHub. It runs in a fresh session with no memory 
of the build session. It reads the end-session report, git diff, 
and planning documents to understand what was built and why — 
then reviews the actual code changes critically.

This is a first-pass filter that catches obvious issues before 
human review. It does not replace the developer's PR review.

This skill never modifies implementation files. Its sole output 
is a structured findings report saved to docs/reports/.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- Never modify any implementation or code files
- This is an adversarial review — look for problems, 
  not validation. Do not confirm that things look fine 
  unless they genuinely do
- Review only what changed in this push — not the 
  entire codebase
- Never fix issues found — surface them clearly 
  and let the user decide what to do
- Derive all review criteria from CLAUDE.md files 
  and the feature brief — never invent standards
- The findings report must be committed and pushed 
  to the feature or fix branch — not to the 
  default branch (e.g., main or master)

## Step 1 — Read all context
Read the following before doing anything else:
- CLAUDE.md files available in context
- End-session report from docs/reports/ — 
  this is the primary input
- Feature brief from docs/briefs/ if available
- Execution plan from docs/plans/ if available
- Audit documents from docs/audit/ if available

If no end-session report exists, note this as 
a warning in the findings report and proceed 
using only the git diff and planning documents.

State what you have read and proceed immediately 
to Step 2.

## Step 2 — Read the git diff
Read the git diff for this push to understand 
exactly what changed:
- Which files were added, modified, or deleted
- What specifically changed in each file
- How the changes relate to the execution plan 
  and feature brief

Focus on files directly related to the feature 
being built — identified from the end-session 
report and execution plan. Configuration, 
dependency, and documentation files are 
secondary unless flagged in the end-session report.

## Step 3 — Establish review criteria
From the CLAUDE.md files and feature brief, 
establish the specific criteria this review 
will check against.

Always check:
- Naming conventions — do all new identifiers 
  follow the conventions established in CLAUDE.md 
  and the existing codebase?
- Security — no hardcoded credentials, no 
  sensitive data in code, environment variables 
  used correctly
- Scope — do the changes match what was planned 
  in the execution plan? Are there unexpected 
  changes?
- Acceptance criteria — does the code appear 
  to address each criterion from the feature brief?
- Existing patterns — do the changes follow the 
  patterns established in the codebase? If audit 
  documents exist in docs/audit/ read and 
  use them. If not, derive patterns from CLAUDE.md 
  and the existing codebase directly.
- Dependencies — were any new dependencies 
  introduced? Are they justified?
- Error handling — are errors handled appropriately?
- Console logs or debug statements — any left 
  in the code?
- Test coverage — were tests written for each 
  acceptance criterion? Do the tests actually 
  run and pass?

Additionally check anything flagged in the 
end-session report's "Context for code review" 
section — this is the build session's specific 
guidance for this review.

State the full criteria list before proceeding 
to Step 4.

## Step 4 — Conduct the review
Review every changed file systematically against 
the criteria established in Step 3.

For each finding use this format:
- Plain English: what this means for a 
  non-developer — no jargon, no assumed knowledge
- Technical detail: specific technical description 
  for developer review
- Location: file and approximate location
- Severity: Blocking / Warning / Observation
- Beyond PM scope: yes or no — flag if resolving 
  this requires developer input or expertise

Severity definitions:
- Blocking — must be addressed before merge
- Warning — should be addressed, not blocking
- Observation — worth noting, low urgency

Do not validate or confirm things that look 
correct — only surface findings.

## Optional — Deep review (higher confidence)
By default this skill reviews in a single pass. 
For high-stakes changes — or when a single pass 
feels uncertain — run a deep review. Trigger it by 
including "deep review" in the request (or set it 
as the routine's mode).

A deep review replaces the single Step 4 pass with 
a multi-reviewer pass:
1. Spawn three independent reviewer subagents. Give 
   each the same git diff, the criteria from Step 3, 
   and the instruction to review adversarially and 
   return findings in the Step 4 format. Do not let 
   them see each other's work.
2. Pool all findings and group duplicates by file 
   and issue.
3. Keep a finding as confirmed only if at least two 
   of the three reviewers raised it independently. 
   A finding only one reviewer raised is demoted to 
   an Observation tagged "single-reviewer — low 
   confidence" — not dropped, but clearly weaker.
4. Continue with Steps 5–7 using the confirmed 
   findings.

This trades more time and tokens for fewer false 
positives. Everything else — the report format, the 
GREEN/AMBER/RED recommendation, the plain-English 
explanations — is unchanged.

## Step 5 — Cross-reference with end-session report
Cross-reference the review findings with the 
end-session report:

- Does the end-session report's acceptance 
  criteria assessment match what the code 
  actually shows?
- Does the tech debt section capture everything 
  found in the review?
- Are there discrepancies between what the 
  end-session report says was built and what 
  the code shows?

Flag any discrepancies explicitly.

## Step 6 — Produce the findings report
Write a structured findings report:

---
Code Review Findings
Date: YYYY-MM-DD
Branch: [branch name]
Session type: Feature / Fix
End-session report: [report filename]
Feature brief: [brief filename if applicable]

## Review summary
One to two sentence plain English summary of 
the overall state of the changes. Be honest — 
if the changes are clean say so. If there are 
significant concerns lead with that.

## Criteria reviewed
Complete list of all criteria checked.

## Findings

### Blocking issues
Issues that must be addressed before this 
branch is merged. For each:
- Plain English: what this means for a non-developer
- Technical detail: specific description for 
  developer review
- Location: file and approximate location
- Why it matters: impact if not addressed
- Beyond PM scope: yes or no

### Warnings
Issues that should be addressed but are not 
blocking. Same format as blocking issues.

### Observations
Low urgency notes worth capturing. Same format.

### Criteria with no findings
List of criteria where no issues were found.

## Acceptance criteria assessment
For each acceptance criterion from the feature brief:
- Criterion: [description]
- Code assessment: does the code address this?
- Test coverage: is there a test for this criterion?
- Matches end-session report: yes / no / partial
- Notes: any relevant observations

## Discrepancies with end-session report
Any differences between what the end-session 
report documented and what the code review found.
If none: state "No discrepancies found."

## Recommendation

🟢 GREEN — Ready for PR
No blocking issues. Pass to developer review.

🟡 AMBER — Proceed with caution
No blocking issues but warnings exist that require 
developer attention. Pass to developer review with 
warnings highlighted.
- Plain English summary of warnings — no jargon
- Which items are beyond PM scope — listed explicitly
- Suggested action: open PR and flag warnings to 
  the developer in the PR notes for reviewer section

🔴 RED — Do not proceed
Blocking issues found. Do not open a PR.
- Plain English summary of what must be fixed — 
  no jargon
- Which issues are beyond PM scope and require 
  specialist input — listed explicitly
- Suggested next step: address findings in a new 
  session, consult a specialist or relevant team 
  member, or both
---

## Step 7 — Save and push the report
Save the report to:
docs/reports/code-review-[branch-name]-[date].md
(replace any / in the branch name with - for the 
filename, e.g. feature/login → feature-login)

If docs/reports/ does not exist, create it.

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

Commit the report with this message:
docs: code review findings for [branch-name] [date]

Push the commit to the feature or fix branch — 
never to the default branch (e.g., main or master).

If the push fails, notify the user immediately — 
the report exists locally in docs/reports/ 
and should be pushed manually before opening a PR.

Confirm the push was successful.

The findings report is now available for the 
user to read before deciding whether to open 
a PR or start a new session to address findings.