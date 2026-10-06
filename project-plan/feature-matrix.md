# Feature matrix specification

One feature matrix per project: the single source of truth for each feature's
priority, build phase, dependencies and status. The project plan links to it and
never copies it. `/project-plan` creates it, `/story` and `/build-feature` read
it and update their own fields.

It lives in one of two trackers, chosen per project by the `Tracker:` line under
Project settings in the repo CLAUDE.md:

- **Google Sheets** (the default): a formatted sheet in a Drive folder named
  after the project. Right for solo work and for projects with a stakeholder who
  reviews features in a spreadsheet.
- **Linear**: a Linear project with one issue per feature. Right when a team
  already works in Linear. There is no sheet alongside it.

The first part of this file is the model, which is the same in both. The two
backend sections say how each tracker stores it and how the skills update it.

## The model

| Field | Values | Written by |
|---|---|---|
| Area | Short group name, e.g. `Input`, `Calculation`, `Reporting` | `/project-plan` |
| ID | `area-number.feature-number`, e.g. `2.4`. Assigned once, never renumbered. Every cross-reference uses it | `/project-plan`; `/story` for rows it adds |
| Feature | The name a user would use | `/project-plan` |
| Source | Where the idea came from: the user, an audit, a competitor, a stakeholder, a story (name it) | `/project-plan`, `/story` |
| Description | What it does, one or two sentences | `/project-plan` |
| Impact | `High` / `Medium` / `Low`, for the user if the feature is missing | `/project-plan` |
| Effort | `High` / `Medium` / `Low`, to build it well | `/project-plan` |
| Priority | `Must` / `Should` / `Could` / `Won't` | The user, via `/project-plan`. `/story` flags a change and waits; it never changes it |
| Phase | A phase name from the project plan, e.g. `Phase 1`; `—` on Won't rows | Same as Priority |
| Depends on | IDs that must be `Shipped` before this one starts; `—` if none | `/project-plan`; `/story` may add |
| Story | Path to `docs/stories/[id]-[slug].md` once the story is approved; `—` before | `/story` |
| Status | See below | `/story`, `/build-feature` |
| Stakeholder answer | `Yes` / `No` / `Ask` — optional, Sheets only | The stakeholder |
| Stakeholder comments | Free text — optional, Sheets only | The stakeholder |

Rules in both trackers: features are never deleted, a dropped one becomes
Priority `Won't` with the reason in Description; new features are added, never
renumbered in; the skills write only the fields they own.

### Status values

| Value | Meaning | Set by |
|---|---|---|
| `—` | No story yet | `/project-plan` |
| `Story approved` | The story exists and was approved; ready to build | `/story` |
| `In build` | A `/build-feature` session is working on it | `/build-feature`, after plan approval |
| `In review` | A PR is open; feedback rounds go back to the same branch | `/build-feature`, after the PR opens |
| `Shipped YYYY-MM-DD` | Merged to the default branch; merge record written | `/build-feature`, at the next session start |

## Google Sheets backend

### Sheet layout

Modelled on a stakeholder-facing feature inventory that worked in practice.

| Row | Content |
|---|---|
| 1 | Title `[Project name] — feature matrix`, merged across every used column |
| 2 | Version and date, e.g. `v1 · 2026-10-06` |
| 3 | blank |
| 4 | `HOW TO READ THE TABLE` in A; the intro sentence in B |
| 5 … | The reading guide: one row per column, the column name in A and its explanation in B (text below) |
| next | `Tip` in A; the reading advice in B |
| next | blank |
| header | The column names, in English, exactly as in the table below |
| below | One row per feature, flat, grouped by Area in build order |

The header row is the first row whose column B is `ID`. Data starts on the row
below it. No heading rows inside the table, so sorting and filtering keep
working. New rows are appended at the end of their Area.

### Columns

Header text is always English. Cell content is in the project language (the
`Language:` line in the repo CLAUDE.md, or the prompt; default English).

| Column | Header |
|---|---|
| A | Area |
| B | ID |
| C | Feature |
| D | Source |
| E | Description |
| F | Impact |
| G | Effort |
| H | Priority |
| I | Phase |
| J | Depends on |
| K | Story |
| L | Status |
| M | Stakeholder answer (optional) |
| N | Stakeholder comments (optional) |

Columns M and N exist only when the project names a stakeholder reviewer
(`Stakeholder reviewer:` line in CLAUDE.md or the prompt). When they exist, the
reading guide addresses the stakeholder directly and says those two columns are
theirs. No skill writes to them.

### Reading guide (rows 4 onward)

Write it in the project language; the English text here is the source. One row
per column, in column order. Include the two stakeholder rows only when those
columns exist.

| A | B |
|---|---|
| HOW TO READ THE TABLE | Each row is one feature. The columns say where it came from, what it is worth, what it costs, and where we propose to put it. |
| Area | Group of related features. |
| ID | Reference number (area.feature), so "the 2.1" means the same thing in every document. |
| Feature | The feature, with the name a user would use. |
| Source | Where the idea came from: the user, an audit, a competitor, a stakeholder, or a story that revealed it. |
| Description | What exactly it does. |
| Impact | For the user: High, Medium or Low. How much worse the product is if the feature is missing. |
| Effort | To build: High, Medium or Low. An idea of what it costs to do well, not a date. |
| Priority | Must = cannot ship without it · Should = important, not blocking · Could = if time permits · Won't = not building it; the reason is in Description. |
| Phase | Which version it belongs to: [one phrase per phase, from the project plan]. |
| Depends on | The IDs that have to ship before this one can start. |
| Story | Link to the written-up feature once it exists. |
| Status | Where it is: — (no story yet) · Story approved · In build · In review (a pull request is open) · Shipped, with the date. |
| Stakeholder answer | YOUR column. Yes = I would not accept the product without this · No = I would · Ask = we need to discuss it. A Yes on a non-Must row, or a No on a Must row, is a conflict we resolve together. |
| Stakeholder comments | YOUR column. Anything that changes the feature, its name, or who does it. |
| Tip | Don't read it top to bottom. Filter Priority = Must first (is anything missing or surplus?), then Should (is anything there you could not accept without?). [With a stakeholder: start with Stakeholder answer = Ask.] |

### Formatting

Apply with the Sheets connector's batch update, after the values are written.
Row and column indexes below are zero-based, as the API expects; `H` is the
header row's zero-based index and `N` the number of used columns (12, or 14
with the stakeholder columns).

| What | Request |
|---|---|
| Title across the sheet | `mergeCells` rows 0–1, columns 0–N, `MERGE_ALL` |
| Title look | `repeatCell` row 0: `fontSize` 18, background rgb(0.918, 0.820, 0.863), `wrapStrategy` WRAP, `verticalAlignment` TOP |
| Guide labels | `repeatCell` rows 3 to H−1, column 0: `bold` true |
| Guide text wraps | `repeatCell` rows 3 to H−1, columns 0–2: `wrapStrategy` WRAP, `verticalAlignment` TOP |
| Header row | `repeatCell` row H: `bold` true, `fontSize` 11 |
| Data rows | `repeatCell` rows H+1 to last: `fontSize` 10, `verticalAlignment` TOP |
| Long-text columns wrap | `repeatCell` rows H+1 to last, columns A, C, E, H, K, L (and M, N): `wrapStrategy` WRAP; the other columns `OVERFLOW_CELL` |
| Column widths (px) | `updateDimensionProperties` COLUMNS: A 252 · B 100 · C 193 · D 199 · E 197 · F 100 · G 100 · H 147 · I 142 · J 100 · K 134 · L 178 · M 140 · N 200 |

No frozen rows: the reading guide sits above the header, so freezing the header
would freeze everything above it too and consume most of the screen.

### How the skills update the sheet

- Row lookup: find the header row (the first row whose column B is `ID`), read
  columns A to L from there down, find the row whose column B equals the ID, and
  write to that row number. Never match on the feature name.
- Write only the columns you own. Never touch another column, and never touch M or N.
- `/story`: on approval, set K to the story's repo path and L to `Story approved`.
  When it adds a row, fill A to J and set K and L to `—`.
- `/build-feature`: set L to `In build` after plan approval, `In review` after the
  PR opens, and `Shipped YYYY-MM-DD` when the session start check finds the PR
  merged.
- If the sheet cannot be reached, say so, finish the step, and list the exact
  cell updates that are pending so the user can make them by hand.

## Linear backend

One Linear project per PM project, in the team named by the `Linear team:` line
under Project settings. One issue per feature. The matrix ID stays the stable
reference; Linear's own issue key is secondary.

### Mapping

| Field | In Linear |
|---|---|
| Project | A Linear project named after the PM project. Its description is a two-line version of the reading guide: what the IDs are, and what the states mean |
| Area | Label `area: [Area]`, created if missing |
| ID, Feature | Issue title `[ID] [Feature]`, e.g. `2.1 Expiring-soon list` |
| Source, Description, Impact, Effort, Depends on, Story | Lines in the issue description, in this order (template below) |
| Impact, Effort | Also labels `impact: high` / `medium` / `low` and `effort: high` / `medium` / `low`, so views can filter on them |
| Priority | Linear priority: Must → High, Should → Medium, Could → Low, Won't → no priority and the Cancelled state |
| Phase | A project milestone per phase, created by `/project-plan`. If the connector cannot create milestones, a label `phase: [Phase]` instead. Won't rows have neither |
| Depends on | A "blocked by" relation to each listed issue, when the connector supports relations. The `Depends on:` line in the description is always written and is the source of truth |
| Status | The team's workflow state: `—` → Backlog · `Story approved` → Todo · `In build` → In Progress · `In review` → In Review · `Shipped` → Done · Won't → Cancelled. If the team has no In Review state, say so once and use In Progress |
| Stakeholder columns | Not available. A project with a stakeholder reviewer uses the Sheets tracker; if both are set, stop and say so |

Issue description template, written in the project language:

```
Source: [source]
Impact: [High / Medium / Low] · Effort: [High / Medium / Low]
Depends on: [IDs, or —]
Story: [path, or —]

[Description]
```

### How the skills update Linear

- Issue lookup: list the project's issues and take the one whose title starts
  with `[ID] ` (the ID followed by a space). Never match on the feature name.
- `/project-plan`: create the project, its milestones, the labels it needs, then
  one issue per feature with title, description, labels, priority, milestone and
  state Backlog (Cancelled for Won't). Add "blocked by" relations last, once
  every issue exists. Put the project URL in the plan and in CLAUDE.md.
- `/story`: on approval, rewrite the `Story:` line in the description with the
  story's repo path and move the issue to Todo. When it adds a feature, create
  the issue the same way `/project-plan` does, with Story `—`.
- `/build-feature`: move the issue to In Progress after plan approval, In Review
  after the PR opens (and put the PR URL in a comment), and Done when the
  session start check finds the PR merged (comment with the merge date).
- Change only the `Story:` line and the state. Never rewrite the rest of the
  description, the title, labels, priority or milestone; those are the user's.
- If Linear cannot be reached, say so, finish the step, and list the exact
  issue updates that are pending so the user can make them by hand.
