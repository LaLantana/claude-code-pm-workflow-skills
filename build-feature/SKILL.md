---
name: build-feature
description: Builds one feature from its approved story. Plans, implements with tests, runs an adversarial review loop until GREEN or AMBER, and opens the PR. Also runs fix rounds on an open PR and writes the merge record once a feature has merged. Two approvals, the plan and the PR.
disable-model-invocation: true
---

# Build Feature

Takes a feature ID (for example `/build-feature 2.4`) whose matrix Status is
`Story approved` or `In review`, and drives it to an open pull request. The user
approves twice: the plan before any code, and the PR before it opens. Everything
between is yours. Follow the working rules in the repo's CLAUDE.md throughout.

## Rules
- Refuse to start without an approved story for the ID. Status must be
  `Story approved` (new build) or `In review` (fix round on an open PR).
- Decide every "how"; raise every "what" (CLAUDE.md, Working with a non-coding PM).
- Bounded effort: three attempts at the same failure, three review rounds. After
  that, write an escalation note and stop.
- Never commit on the default branch. Never push or open a PR except through the
  permission prompt. Never skip, weaken or disable a test to get green.
- Never read `.env`. Learn configuration from `.env.example`.

## Step 0 — Session start
`git fetch` first. Report: the current branch, whether the default branch is behind
the remote (offer to pull), and any uncommitted or untracked files by name, except
those CLAUDE.md records as known.

Then check for shipped work: any local `feature/*` branch now merged into the
default branch (compare against the fetched remote, or `gh pr list --state merged`).
For each one, write the merge record and set that feature's matrix Status to
`Shipped YYYY-MM-DD`. The record is committed as the first commit on the branch
this session will work on (Step 1), because the default branch is never
committed to directly; it ships with the next PR. Offer to delete the merged local
branch.

Merge record, saved as `docs/releases/[date]-[id]-merge.md`:

```
Merge record: [feature name]
ID: [matrix ID]
Date: YYYY-MM-DD
PR: [title and URL]
Branch: [branch] → [default branch]

## What shipped
## Acceptance criteria status
   Each criterion: Met / Partial / Not met / Deferred, from the PR.
## Known issues and tech debt
## CLAUDE.md updates
   New endpoints, dependencies, decisions or patterns worth recording. Propose
   them, apply on a yes, and list what changed. Existing entries that no longer
   match the code are reported here, never rewritten.
```

## Step 1 — Plan (approval 1)
Read the repo CLAUDE.md (and the parent CLAUDE.md if one exists), the story at
the path in the matrix row, `docs/project-plan.md`, `docs/audit/*` if present,
and `DESIGN.md` if the story has a Design approach line. Run the runtime
verification from CLAUDE.md.

Fix round (Status `In review`): also read the open PR's review comments with
`gh pr view --comments` and anything the user said in the prompt (for example
which UAT item failed). The plan covers only what the feedback asks for.

Stop and say so if a prerequisite ID in the story is not `Shipped`, or the story
has a blocking open question.

Write `docs/plans/[id]-plan.md`:

```
Plan: [feature name]
ID: [matrix ID]
Date: YYYY-MM-DD
Round: [1 for a new build; 2, 3… for fix rounds]
Goal: [one sentence]

## Out of scope
## Files affected
   Every file to create or change, and what changes in each.
## Steps
   Step N: what to do · files touched · verify: how you will know it worked
## Tests
   Each [AUTO] and [BOTH] criterion from the story, and the test that will
   prove it.
## Risks
## Decisions
   The "how" choices you made and why, one line each.
```

Present a summary: goal, number of steps, files affected, risks, decisions.
**Wait for approval.** On changes, update and present again. Approval of the
plan is approval for every file it lists; a change outside that list is a stop.

After approval: new build → pull the default branch and create
`feature/[id]-[slug]` from it. Fix round → switch to the existing branch and
pull it. Then commit the plan (and any merge record from Step 0), and set the
matrix Status to `In build`.

## Step 2 — Implement and test
For each step in the plan: write the tests for the criteria that step covers,
implement, run the test and lint commands from CLAUDE.md, fix, and run the
step's verify line. Commit each step that passes, with a conventional message
(`feat:`, `fix:`, `test:`, `refactor:`), so work is never lost.

Do not leave this step until every documented check passes and every [AUTO] and
[BOTH] criterion has a passing test. Three attempts at the same failure, then an
escalation note.

## Step 3 — Review loop
Spawn a reviewer subagent with no memory of this session. Give it: the diff
against the default branch, the story, the relevant CLAUDE.md conventions, and
this checklist: naming conventions, security (no credentials, no sensitive data,
env vars used correctly), scope against the plan, every acceptance criterion
addressed and tested, existing patterns followed, new dependencies justified,
error handling, leftover debug output.

It returns findings, each as: plain English for a non-developer · technical
detail · location · severity Blocking / Warning / Observation · beyond PM scope
yes/no. Plus one line per acceptance criterion: addressed, tested.

Verdict after each round:
- **GREEN**: no Blocking, no Warnings. Go to Step 4.
- **AMBER**: no Blocking; Warnings remain and are carried into the PR. Go to
  Step 4.
- **RED**: Blocking findings. Fix them (and Warnings that are local), re-run the
  tests, commit, and review again.

Three rounds at most. Still RED after three: escalation note with the remaining
findings, and stop.

## Step 4 — Pull request (approval 2)
Draft the PR description:

```
## What this does
## Why
## What changed
## Acceptance criteria
   Each: Met / Partial / Not met / Deferred (intentionally descoped, say why).
   [UAT] and [BOTH] items as a checklist for the PM to tick.
## Tests
## Known issues and tech debt
## Notes for reviewer
   Review verdict (GREEN / AMBER), remaining warnings in plain English,
   anything beyond PM scope, decisions worth a second look.
```

Present it. **Wait for approval.** Before pushing, check the branch: only files
the plan lists plus `docs/`, no secrets, no scratch or temporary files. Then push
(the permission prompt is the gate). New build: `gh pr create` with title
`feat: [feature name] ([id])`. Fix round: the push updates the open PR; post one
comment summarising the round. Set the matrix Status to `In review`. Report the
PR URL and remind the user that the UAT checklist is in the PR.

## When to stop
Only three things stop the loop: a "what" decision, a blocker still standing
after the bounded attempts, or missing credentials, environment or access. Each
produces an escalation note in the CLAUDE.md format (what you were trying to do,
what you tried, why it failed, what you need; plain English first, technical
detail second), so the user can forward it to someone technical.

## After the PR
The PM does not relay feedback. A developer's review on the PR, or a failed UAT
item, is handled by running `/build-feature [id]` again in a new session: Status
`In review` routes it to the existing branch and the open PR. When the PR merges,
the next `/build-feature` session's Step 0 writes the merge record.
