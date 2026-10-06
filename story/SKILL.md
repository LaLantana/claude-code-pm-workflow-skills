---
name: story
description: Writes one testable story for one feature from the feature matrix, links it from the matrix, and adds any rows the story reveals are missing. Run once per feature, just before building it.
disable-model-invocation: true
---

# Story

Turns one row of the feature matrix into a story: a focused, testable ticket that
`/build-feature` builds from. Its output is `docs/stories/[id]-[slug].md`, plus
two cells in the feature matrix. Follow the working rules in the repo's CLAUDE.md
throughout.

## Rules
- One feature per run.
- Describe what is being built, never how. Implementation decisions belong to
  `/build-feature`.
- Derive everything from the project plan, the matrix row, the audits and
  CLAUDE.md. Never invent requirements.
- Every acceptance criterion must be testable. One that cannot be tested is
  rewritten with the user before approval.
- Never change a row's Priority or Phase. Flag a change and wait.
- A story with a blocking open question is not approved.

## Step 1 — Read and locate
Read the repo CLAUDE.md (and the parent CLAUDE.md if one exists),
`docs/project-plan.md`, `docs/audit/*` if present, and `DESIGN.md` if present.
Open the feature matrix (the link is under Project settings in CLAUDE.md) and
find the row whose ID column matches the feature ID given. Match on ID, never on
name.

Stop and say so if: the ID is missing or ambiguous; the row's Status is anything
other than `—` (if a story already exists, ask whether to revise it); or a
prerequisite row listed in the plan is not yet `Shipped` and the user has not
said to proceed anyway.

State in plain English: the feature, its area, priority and phase, its
description from the matrix, and any plan open questions that touch it.

## Step 2 — Draft the story
Write it with the template in Step 4. Carry the matrix description in and expand
it: boundaries, prerequisites by ID, and acceptance criteria that cover the main
path, edge cases, error states, empty states and limits.

Tag every criterion `[AUTO]` (an automated test can verify it), `[UAT]` (a person
following a short checklist can verify it), or `[BOTH]`. If neither fits, the
criterion is too vague; rewrite it.

For a feature with new UI: if `DESIGN.md` exists, the Design approach line
follows it; if it does not, add "DESIGN.md" as a blocking prerequisite and say so.

## Step 3 — Check against the matrix
- Priority and phase: if writing the story changed your view of either (more
  effort, wider scope, new dependencies, more repos than expected), present the
  recommended change and why, and wait. Otherwise state that both are
  reconfirmed.
- Gap check: if the story needs functionality that is not in the matrix, propose
  each missing piece as a new row (Area, ID as the next number in that area,
  Feature, Source "story [id]", Description, Impact, Effort, Priority, Phase).
  Add them to the sheet on approval, appended at the end of their Area.

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
   Matrix IDs that must be shipped first, and anything else that must be in
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
In the feature's row, set the Story column to the file's path from the repo root
and the Status column to `Story approved`. Touch no other column. If you added
rows in Step 3, their Story and Status columns are `—`.

If the sheet cannot be reached, finish anyway and list the exact cells that need
updating so the user can do it by hand.

Propose one commit for the story file and stop. The next step is
`/build-feature [id]`.
