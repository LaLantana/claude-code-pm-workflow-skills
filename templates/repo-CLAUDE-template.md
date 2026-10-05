# [repo-name] — [one-line description of what this repo is]

<!--
  CLAUDE.md template — one of these lives in EVERY repo (root level).
  The skills read this file as their source of truth, so keep it accurate.

  Fast start: run Claude Code's `/init` in this repo to auto-generate a first
  draft from the codebase, then refine it against the sections below.
  Replace every [bracketed prompt]. Delete sections that don't apply.
  Delete these HTML comments when you're done.
-->

## Context
<!-- Several repos only — delete this whole section if you have ONE repo. -->
A parent CLAUDE.md lives one level up at `[path-to-your-repos]/CLAUDE.md` with
the cross-repo system overview. At the start of a session, read it for context.
This file is canonical for everything about THIS repo.

## What this is
[Plain-English description of what this repo/service does and who uses it.]

## Tech stack
- Runtime: [e.g. Node.js / Bun / Python] — package manager: [npm / bun / pip / …]
- Language: [e.g. TypeScript]
- Framework(s): [...]
- Database / storage: [...]
- [Any other key tech, with versions if they matter]

## Project structure
[Key folders and what each holds — entry point(s), where routes / pages /
business logic live.]

## Key commands
- `[install command]` — install dependencies
- `[dev command]` — run in development
- `[test command]` — run the tests
- `[lint / typecheck command]` — lint / type-check
- `[build command]` — production build

## Runtime verification
[How to confirm the app/service is up — the URL/port, a health-check command,
and how to verify any dependency (e.g. a database is running). Skills use this
to check the environment before working.]

## Conventions & patterns
- [Naming conventions; language for code/comments; patterns to always follow]
- Design system and UI workflow: see `DESIGN.md` — read it before any UI work.
  Keep design specs there, not here. (Delete this line if the repo has no UI.)
- [Step-by-step pattern for adding a common thing — e.g. a new API route or
  page — documented well enough to follow without re-reading the whole codebase]

## Current API endpoints
<!-- Keep only if this repo exposes an API other repos consume. The
     merge-documentation skill appends new endpoints to this section, so keep
     the heading name "Current API endpoints". -->
This section is the single source of truth for the API surface.
- `[METHOD /path]` — [description, inputs, outputs]

## Per-repo docs
This repo carries its own `docs/` at the root: `docs/audit/`, `docs/plans/`,
`docs/reports/`, `docs/releases/`, `docs/archive/`.
<!-- Several repos + this is the planning home? Add: docs/build-plan/, docs/briefs/ -->

## Working rules
- [Project-specific rules — e.g. language for identifiers, things never to change]
- Test changes locally with `[dev/test command]` before committing.
- When a task needs changes to more than one file, list all affected files and
  wait for approval before proceeding.

## Git workflow
- Always create a branch before making changes; never work directly on the
  default branch ([your default branch — e.g. `main` or `master`]).
- Branch conventions: `feature/…`, `fix/…`, `explore/…`, `docs/…`
- Never commit or push without explicit approval.
  (Exception: the `end-session`, `code-review`, and `merge-documentation` skills
  make documentation-only commits/pushes after passing their docs-only self-check.)

## Security
- Never read, display, or output the contents of any `.env` file.
- `.env.example` is safe to read and is how required configuration is learned.
- Reference environment variables by name, never by value. Never put secrets in code.

## Deployment
[Note any deploy config that must not be touched — e.g. `vercel.json`, `netlify.toml`.]

## Documentation rules
- Keep entries concise (one or two lines). Show proposed doc updates and wait for
  approval before writing. Date new entries `YYYY-MM-DD`.
  (Exception: after a merge, the `merge-documentation` skill adds new entries
  directly. It only reports mismatches in existing entries and never rewrites them.)
- [What's worth documenting here: new endpoints, dependencies, decisions, patterns.]
