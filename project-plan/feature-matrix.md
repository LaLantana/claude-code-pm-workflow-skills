# Feature matrix specification

One feature matrix per project. It is a Google Sheet, created by `/project-plan`
through the Google Sheets connector, and it is the single source of truth for each
feature's priority, build phase and status. The project plan links to it and never
copies it. `/story` and `/build-feature` read it and update their own columns.

## Sheet layout

| Row | Content |
|---|---|
| 1 | Title: `[Project name] — feature matrix`, then version and date |
| 2 | The reading guide (one cell, text below) |
| 3 | blank |
| 4 | Header row (column names below, in English, exactly as written) |
| 5+ | One row per feature, flat, grouped by Area in build order |

No heading rows inside the table, so sorting and filtering keep working. New rows
are appended at the end of their Area. Rows are never deleted; a dropped feature
becomes Priority `Won't` with the reason in Description.

## Columns

Header text is always English. Cell content is in the project language (the
`Language:` line in the repo CLAUDE.md, or the prompt; default English).

| Column | Header | Values | Written by |
|---|---|---|---|
| A | Area | Short group name, e.g. `Input`, `Calculation`, `Reporting` | `/project-plan` |
| B | ID | `area-number.feature-number`, e.g. `2.4`. Assigned once, never renumbered. Every cross-reference uses it | `/project-plan`; `/story` for rows it adds |
| C | Feature | The name a user would use | `/project-plan` |
| D | Source | Where the idea came from: the user, an audit, a competitor, a stakeholder, a story (name it) | `/project-plan`, `/story` |
| E | Description | What it does, one or two sentences | `/project-plan` |
| F | Impact | `High` / `Medium` / `Low`, for the user if the feature is missing | `/project-plan` |
| G | Effort | `High` / `Medium` / `Low`, to build it well | `/project-plan` |
| H | Priority | `Must` / `Should` / `Could` / `Won't` | The user, via `/project-plan`. `/story` flags a change and waits; it never changes it |
| I | Phase | A phase name from the project plan, e.g. `Phase 1` | Same as Priority |
| J | Story | Link to `docs/stories/[id]-[slug].md` once the story is approved; `—` before | `/story` |
| K | Status | See below | `/story`, `/build-feature` |
| L | Stakeholder answer | `Yes` / `No` / `Ask` — optional column | The stakeholder |
| M | Stakeholder comments | Free text — optional column | The stakeholder |

Columns L and M exist only when the project names a stakeholder reviewer
(`Stakeholder reviewer:` line in CLAUDE.md or the prompt). When they exist, the
reading guide addresses the stakeholder directly and says those two columns are
theirs. No skill writes to them.

## Status values

| Value | Meaning | Set by |
|---|---|---|
| `—` | No story yet | `/project-plan` |
| `Story approved` | The story exists and was approved; ready to build | `/story` |
| `In build` | A `/build-feature` session is working on it | `/build-feature`, after plan approval |
| `In review` | A PR is open; feedback rounds go back to the same branch | `/build-feature`, after the PR opens |
| `Shipped YYYY-MM-DD` | Merged to the default branch; merge record written | `/build-feature`, at the next session start |

## Reading guide (row 2)

Write this in the project language. Adapt the phase names to the plan. Keep it to
one cell.

> **How to read this table.** Each row is one feature. Area groups related
> features; ID is the stable reference, so "the 2.4" means the same thing in every
> document. Impact is what the user loses if the feature is missing; Effort is what
> it costs to build well. Priority is Must / Should / Could / Won't. Phase says which
> version it belongs to: [one line per phase, from the project plan]. Story links
> to the written-up feature once it exists, and Status tracks it from story to
> shipped. The table is kept flat so you can sort and filter it.

If the stakeholder columns exist, add:

> **Your two columns.** *Stakeholder answer*: would you refuse to accept the
> product without this feature? Yes, No, or Ask if you need to discuss it.
> *Stakeholder comments*: anything that changes the feature, its name, or who does
> it. A Yes on a non-Must row, or a No on a Must row, is a conflict we resolve
> together.

## How the skills update the sheet

- Find the row by ID in column B. Never match on the feature name.
- Write only the columns you own. Never touch another column, and never touch L or M.
- `/story`: on approval, set J to the story's repo path and K to `Story approved`.
  When it adds a row, fill A to I and set J and K to `—`.
- `/build-feature`: set K to `In build` after plan approval, `In review` after the
  PR opens, and `Shipped YYYY-MM-DD` when the session start check finds the branch
  merged.
- If the sheet cannot be reached, say so, finish the step, and list the exact cell
  updates that are pending so the user can make them by hand.
