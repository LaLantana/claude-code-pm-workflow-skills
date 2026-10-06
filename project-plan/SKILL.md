---
name: project-plan
description: Writes the project plan (a mini PRD) and creates the project's feature matrix in Google Sheets or Linear. Run once per project, from a product description, from /code-audit output, or both.
disable-model-invocation: true
---

# Project Plan

Produces two things: `docs/project-plan.md`, a short PRD, and the feature matrix,
the single source of truth for each feature's priority, phase, dependencies and
status. The matrix lives in Google Sheets or in Linear, chosen per project by the
`Tracker:` line in CLAUDE.md (default Google Sheets). The plan links to it and
never copies it.
Follow the working rules in the repo's CLAUDE.md throughout.

The full matrix specification (the model, and how each tracker stores and
updates it) is in `feature-matrix.md` next to this file. Read it before Step 3.

## Rules
- Planning only. Never implement anything.
- Derive every feature from the product description, the audits, or the user.
  Never invent requirements.
- If the input is too thin to plan from, say what is missing and stop.
- Priority and phase are the user's decisions. Propose them; never finalise them
  without approval.

## Step 1 — Read and orient
Read the repo CLAUDE.md (and the parent CLAUDE.md if one exists), every document
named in the prompt, and `docs/audit/*` if present. Note the Project settings in
CLAUDE.md: `Tracker:` (Google Sheets or Linear; default Google Sheets),
`Language:` (default English), `Stakeholder reviewer:` (optional, Sheets only)
and, for Linear, `Linear team:`. A stakeholder reviewer with the Linear tracker
is a contradiction: stop and ask which one the user wants. Check whether a
`DESIGN.md` exists in the repo.

State in plain English and wait for one confirmation:
- What exists today (from the audits), or "new product" if nothing does
- The goal, in the user's words
- The gap between the two
- Who the users are and what they need
- What kind of project this is: greenfield, integration, redesign or refactor,
  or a mix. Inferred, not asked
- Whether `DESIGN.md` exists. If the product has a UI and there is none, say so:
  it becomes a blocking prerequisite on every UI feature until one exists
- Constraints, dependencies and risks already visible

## Step 2 — Draft the plan and the feature list together
Write the project plan using the template in Step 5 and, in the same pass, the
feature rows: one row per feature, grouped by Area in build order, with the
columns from `feature-matrix.md` filled in. Assign IDs as `area.n` and never reuse
one. Propose Priority (Must / Should / Could / Won't) and Phase for every row,
using the phase names you defined in the plan, and fill Depends on with the IDs
that must ship first (most rows have none).

Acceptance criteria do not belong here. They are written per feature by `/story`.

## Step 3 — Create the feature matrix
**Google Sheets.** With the Google Drive connector, create a folder named `[Project name]` at the
top level of My Drive, or inside the folder the user names in the prompt. Then
create a new Google Sheet inside that folder, named
`[Project name] — feature matrix`, and lay it out with the Google Sheets
connector exactly as `feature-matrix.md` describes: title and version rows, the
two-column reading guide, the header row, then the feature rows. Then apply the
formatting in `feature-matrix.md` (title band, bold labels and header, wrapping,
column widths) with the connector's batch update. Headers in English; cell
content in the project language. Add the two stakeholder columns only if a
stakeholder reviewer is named, and address them in the reading guide.

If the Google connectors are not available in this session, do not substitute a
markdown table. Save the rows as `docs/feature-matrix.csv` with the same
columns, tell the user to import it into a new Google Sheet and paste the link
into CLAUDE.md, and carry on. The CSV is a handoff, not a second copy; say it
should be deleted after import.

**Linear.** With the Linear connector, in the team named in CLAUDE.md: create a
project named `[Project name]` with the two-line description from
`feature-matrix.md`; create one milestone per phase (or `phase:` labels if the
connector cannot create milestones); create the `area:`, `impact:` and
`effort:` labels that are missing; then create one issue per feature exactly as
the Linear mapping in `feature-matrix.md` says (title `[ID] [Feature]`, the
description template, labels, priority, milestone, state Backlog or Cancelled).
Add the "blocked by" relations last, once every issue exists. Issue text is in
the project language.

If the Linear connector is not available in this session, stop and tell the
user how to connect it. There is no file fallback for Linear.

## Step 4 — Present and get approval
Present, in this order: the plan summary (ten lines at most), the matrix link
(sheet or Linear project), and the feature count by priority and by phase. Do not paste the plan or the rows into
the chat unless asked.

Wait for approval. On changes, update both the plan and the matrix and present
again. Priority and phase changes are the user's call; apply them as given.

## Step 5 — Save and hand off
Save `docs/project-plan.md`:

```
Project plan: [project name]
Date: YYYY-MM-DD
Language: [from CLAUDE.md]
Stakeholder reviewer: [name and role, or "none"]
Feature matrix: [sheet link or Linear project URL]

## Problem
## Users
## Goal and what success looks like
## Scope
## Not in scope
## Phases
   One line per phase: name, what it means for this project, what it must
   contain. Phase names are the values used in the matrix.
## Constraints
## Risks
## Open questions
   Each with "Owner:" (the user, a developer, an external party, or a workflow
   skill such as "Claude via /build-feature") and blocking / non-blocking.
## Feature matrix
   The link, and one sentence on how to read it. Nothing else.
```

Then add the link to the `Feature matrix:` line under Project settings in
CLAUDE.md. Create a branch `docs/project-plan`, commit the plan and the CLAUDE.md
change, push, and open a PR to the default branch (push and PR go through the
permission prompt). This is the one docs-only PR a project needs. Tell the user
to merge it and pull before running `/story` for the first feature in build
order, then stop.
