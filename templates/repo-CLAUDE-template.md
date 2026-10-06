# [repo-name] — [one-line description of what this repo is]

<!--
  CLAUDE.md template — one of these lives in EVERY repo that uses the PM workflow
  (root level). The four skills read this file as their source of truth, so keep it
  accurate.

  Fast start: run Claude Code's `/init` in this repo to auto-generate a first draft
  from the codebase, then refine it against the sections below.
  Replace every [bracketed prompt]. Delete sections that don't apply.
  Delete these HTML comments when you're done.

  Prototype or throwaway repo? Don't add this file. Nothing in the workflow loads
  unless a repo has it and you invoke a skill.
-->

## Project settings
- Tracker: [Google Sheets or Linear — where the feature matrix lives; default Google Sheets]
- Linear team: [team key, e.g. SHE — only if Tracker is Linear]
- Language: [language for documents, stories and the feature matrix — e.g. English]
- Stakeholder reviewer: [name and role, or delete this line if there is none; Google Sheets only]
- Feature matrix: [link to the Google Sheet or the Linear project, added by /project-plan]

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
and how to verify any dependency (e.g. a database is running). /build-feature
runs this before implementing.]

## Conventions & patterns
- [Naming conventions; language for code/comments; patterns to always follow]
- [Step-by-step pattern for adding a common thing — e.g. a new API route or
  page — documented well enough to follow without re-reading the whole codebase]
- Design system and UI workflow: see `DESIGN.md` — read it before any UI work.
  Keep design specs there, not here. (Delete this line if the repo has no UI.)

## Current API endpoints
<!-- Keep only if this repo exposes an API other repos consume. /build-feature
     appends new endpoints here when it writes a merge record, so keep the heading
     name "Current API endpoints". -->
This section is the single source of truth for the API surface.
- `[METHOD /path]` — [description, inputs, outputs]

## Workflow documents
This repo carries its own `docs/` at the root:
- `docs/audit/` — codebase audit (from /code-audit)
- `docs/project-plan.md` — the project plan; links to the feature matrix
- `docs/stories/` — one story per feature (from /story)
- `docs/plans/` — one execution plan per feature, rewritten on fix rounds (from /build-feature)
- `docs/releases/` — one merge record per shipped feature (from /build-feature)
<!-- Several repos? The planning home holds docs/project-plan.md and docs/stories/;
     every other repo holds only its own audit, plans and releases. -->

## Working with a non-coding PM
The user is a Product Manager, not a developer. They decide what the product
does; you decide how to build it.

- **Plain English first.** Explain what you are about to do before doing it.
  Never show code without saying what it does and why. Define technical terms on
  first use. Assume the user cannot read code: your explanations are their only
  window.
- **What versus how.** Ask: does the answer depend on what the product should
  do, or only on how to build it? "What" is the user's: scope, product, UX, brand,
  anything hard to undo, technical debt they would be taking on. "How" is yours:
  technique, structure, naming, error handling, test data. Decide every "how"
  yourself, record it in a line in the plan, and keep going. Never ask the user
  to pick a technique. If a "how" has a "what" consequence, state the consequence
  and the choice you made.
- **Scope.** Do exactly what the story and plan say. Do not add features,
  refactors or improvements that were not asked for; note them for later. If
  finishing requires going beyond the agreed scope, stop and say so.
- **Trade-offs with debt.** When the clean solution and a faster one differ in the
  technical debt or risk they leave behind, present both, with a recommendation,
  and wait. Technical debt is always the user's decision. Two equally clean
  approaches are a "how": pick one.
- **When you are stuck**, stop and write an escalation note instead of trying
  more workarounds. The user cannot help with the "how", but they can forward the
  note to someone who can. The note has four parts, in plain English first and
  technical detail second: what you were trying to do, what you tried, why it
  failed, and exactly what you need.
- **Ask in the conversation.** Do not use the AskUserQuestion tool; ask directly
  in plain text and wait.

## Git workflow
- Branch names: `feature/[id]-[slug]`, where `[id]` is the feature's matrix ID.
- Never commit on the default branch ([your default branch — e.g. `main`]). The
  hook in `.claude/hooks/` enforces this.
- Pushing and opening a PR go through a permission prompt (see
  `.claude/settings.json`); that prompt is the approval.
- Fix rounds after a PR is open stay on the same branch; the PR updates itself.

## Security
- Never read, display, or output the contents of any `.env` file.
- `.env.example` is safe to read and is how required configuration is learned.
- Reference environment variables by name, never by value. Never put secrets in code.

## Deployment
[Note any deploy config that must not be touched — e.g. `vercel.json`, `netlify.toml`.]

## Documentation rules
- Keep entries concise (one or two lines). Date new entries `YYYY-MM-DD`.
- /build-feature proposes CLAUDE.md updates (new endpoints, dependencies,
  decisions, patterns) when it writes a merge record, and makes them after
  approval. It reports mismatches between this file and the code; it never
  rewrites an existing entry on its own.
