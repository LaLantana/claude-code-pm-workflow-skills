---
name: story
description: Writes one testable story for one feature from the feature matrix, links it from the matrix, and adds any rows the story reveals are missing. Run once per feature, just before building it.
disable-model-invocation: true
---

# Story

Turns one feature from the feature matrix into a story: a focused, testable
ticket that `/build-feature` builds from. Its output is
`docs/stories/[id]-[slug].md`, plus two fields on the feature in the matrix,
which lives in Google Sheets or Linear (the `Tracker:` line in CLAUDE.md). Follow the working rules in the repo's CLAUDE.md
throughout.

## Rules
- One feature per run.
- Describe what is being built, never how. Implementation decisions belong to
  `/build-feature`.
- Derive everything from the project plan, the matrix entry, the audits and
  CLAUDE.md. Never invent requirements.
- Every acceptance criterion must be testable. One that cannot be tested is
  rewritten with the user before approval.
- Never change a feature's Priority or Phase. Flag a change and wait.
- A story with a blocking open question is not approved.

## Step 1 — Read and locate
Read the repo CLAUDE.md (and the parent CLAUDE.md if one exists),
`docs/project-plan.md`, `docs/audit/*` if present, and `DESIGN.md` if present.
Open the feature matrix (the link is under Project settings in CLAUDE.md) and
find the feature: in Google Sheets, the row whose ID column (B) matches the ID
given; in Linear, the issue in the project whose title starts with the ID and a
space. Match on ID, never on name.

Stop and say so if: the ID is missing or ambiguous; the feature's Status is anything
other than `—` (if a story already exists, ask whether to revise it); the feature
has UI and there is no `DESIGN.md` (the story cannot be approved until one
exists, so do not draft it); or a feature named in its Depends on is not yet
`Shipped` (Linear: Done) and the user has not said to proceed anyway.

State in plain English: the feature, its area, priority and phase, its
description from the matrix, and any plan open questions that touch it.

## Step 2 — Draft the story
Write it with the template in Step 4. Carry the matrix description in and expand
it: boundaries, prerequisites by ID, and acceptance criteria that cover the main
path, edge cases, error states, empty states and limits.

Tag every criterion `[AUTO]` (an automated test can verify it), `[UAT]` (a person
following a short checklist can verify it), or `[BOTH]`. If neither fits, the
criterion is too vague; rewrite it.

For a feature with new UI, the Design approach line follows `DESIGN.md`.

## Step 3 — Check against the matrix
- Priority and phase: if writing the story changed your view of either (more
  effort, wider scope, new dependencies, more repos than expected), present the
  recommended change and why, and wait. Otherwise state that both are
  reconfirmed.
- Gap check: if the story needs functionality that is not in the matrix, propose
  each missing piece as a new feature (Area, ID as the next number in that area,
  Feature, Source "story [id]", Description, Impact, Effort, Priority, Phase,
  Depends on). Add them on approval: in Sheets, a row appended at the end of its
  Area; in Linear, an issue created the way `/project-plan` creates them. Then
  add their IDs to this feature's Depends on.

## Step 4 — Present, approve, save
Present a summary: the one-line "what we are building", the count of criteria by
tag, prerequisites, any flags from Step 3, and the file path. Show the full story
only if asked. Wait for approval; on changes, update and present again.

Save `docs/stories/[id]-[slug].md`:

```
Story: [feature name]
ID: [matrix ID]
Date: YYYY-MM-DD
Repos affected: [list]

## What we are building
   One or two sentences: what this feature does and what problem it solves.
## Why we are building it
   One sentence tracing it to the project plan's goal.
## What this is not
   Explicit boundaries, specific.
## Prerequisites
   The IDs from the feature's Depends on, and anything else that must be in
   place. If a prerequisite is not met, the build does not start.
## Acceptance criteria
   Specific, binary statements, each tagged [AUTO], [UAT] or [BOTH]. Cover the
   main path, edge cases, error states, empty states, boundaries.
## Technical constraints
   Only what applies to this feature, from CLAUDE.md and the audits: naming,
   patterns to follow, things never to change.
## Design approach
   One line for UI features: direct build, direct build with a mockup
   checkpoint, or design-first, following DESIGN.md. Omit for non-UI features.
## Open questions
   Each with "Owner:" and blocking / non-blocking. Blocking means the story is
   not approved until it is answered.
```

## Step 5 — Update the matrix and hand off
Google Sheets: in the feature's row, set the Story column (K) to the file's path
from the repo root and the Status column (L) to `Story approved`. Touch no other
column except, if Step 3 added dependencies, this row's Depends on (J). New rows
have Story and Status `—`.

Linear: rewrite the `Story:` line of the issue's description with the file's
path and move the issue to Todo. Change nothing else on the issue except, if
Step 3 added dependencies, the `Depends on:` line and the matching "blocked by"
relations. New issues start in Backlog with Story `—`.

If the tracker cannot be reached, finish anyway and list the exact updates that
are pending so the user can make them by hand.

Do not commit the story. `/build-feature` commits it together with the plan as
the first commit on the feature branch, so until then it is an expected
untracked file. Stop. The next step is `/build-feature [id]`.
