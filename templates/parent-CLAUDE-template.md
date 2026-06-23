# [project-name] — [one-line description of the whole system]

<!--
  PARENT CLAUDE.md template — for MULTI-REPO projects only.

  This file lives in `[path-to-your-repos]/` — the folder that CONTAINS your
  repos — NOT inside any repo. It gives the cross-repo system overview so a
  session started from the parent folder understands how the repos relate.

  Each repo ALSO has its own CLAUDE.md (see repo-CLAUDE-template.md), which is
  canonical for that repo's toolchain and rules. Keep this parent file THIN —
  overview only, no per-repo detail (that would just go stale).

  Single-repo project? You do not need this file at all. Delete these comments
  and replace every [bracketed prompt] when done.
-->

## What is [project-name]?
[2–3 sentences: what the whole system does, and the current goal.]

## Repositories
These repos together make up [project-name]:
- `[repo-a]/` — [role · key tech in one line · default branch]
- `[repo-b]/` — [role · key tech in one line · default branch]

## How it works end-to-end
[A brief flow across the repos so a session understands how they connect —
what calls what, where data flows, what the overall goal is.]

## People
- [role] (GitHub: [handle]) — owns `[repo]`, [responsibilities / availability]

## Documentation conventions
- Every repo carries its own `docs/` at its root: `docs/audit/`, `docs/plans/`,
  `docs/reports/`, `docs/releases/`, `docs/archive/`.
- One repo is the **shared planning home** and additionally holds
  `docs/build-plan/` and `docs/briefs/`. For this project: **[repo-a]**.

## Working across repos
- Each repo's own CLAUDE.md is canonical for its toolchain, commands, conventions,
  and rules — read the relevant repo's CLAUDE.md before working in it.
- Never assume a package manager or command; use only what the repo's CLAUDE.md
  documents.
- [Any cross-repo rules — e.g. shared field names, naming that must match.]
