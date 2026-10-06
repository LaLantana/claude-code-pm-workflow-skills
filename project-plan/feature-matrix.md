# Feature matrix specification

One feature matrix per project. It is a Google Sheet, created by `/project-plan`
through the Google Sheets connector, and it is the single source of truth for each
feature's priority, build phase and status. The project plan links to it and never
copies it. `/story` and `/build-feature` read it and update their own columns.

## Sheet layout

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
working. New rows are appended at the end of their Area. Rows are never deleted;
a dropped feature becomes Priority `Won't` with the reason in Description.

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
| I | Phase | A phase name from the project plan, e.g. `Phase 1`; `—` on Won't rows | Same as Priority |
| J | Depends on | IDs that must be `Shipped` before this one starts, comma-separated; `—` if none | `/project-plan`; `/story` may add |
| K | Story | Path to `docs/stories/[id]-[slug].md` once the story is approved; `—` before | `/story` |
| L | Status | See below | `/story`, `/build-feature` |
| M | Stakeholder answer | `Yes` / `No` / `Ask` — optional column | The stakeholder |
| N | Stakeholder comments | Free text — optional column | The stakeholder |

Columns M and N exist only when the project names a stakeholder reviewer
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

## Reading guide (rows 4 onward)

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

## Formatting

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

## How the skills update the sheet

- Find the row by ID in column B. Never match on the feature name.
- Write only the columns you own. Never touch another column, and never touch M or N.
- Row lookup: find the header row (the first row whose column B is `ID`), read
  columns A to L from there down, find the row whose column B equals the ID, and
  write to that row number.
- `/story`: on approval, set K to the story's repo path and L to `Story approved`.
  When it adds a row, fill A to J and set K and L to `—`.
- `/build-feature`: set L to `In build` after plan approval, `In review` after the
  PR opens, and `Shipped YYYY-MM-DD` when the session start check finds the PR
  merged.
- If the sheet cannot be reached, say so, finish the step, and list the exact cell
  updates that are pending so the user can make them by hand.
