# Claude Code PM Workflow Skills

A complete, guardrailed Claude Code workflow that lets a Product Manager safely take work from understanding an existing codebase all the way to a merged pull request — across one or more repositories. It's built for non-coders: it prevents errors, explains everything in plain English, flags when a more technical human (e.g. an architect) is needed, runs an agentic review before every PR, and leaves behind a complete trail of dev and PM documentation. The system is 11 Claude Code skills plus session templates; every phase produces a document the next phase reads, and every risky action (branching, committing, pushing, merging) sits behind an explicit human approval gate.

> **One repo or several?** This works with both. The session templates default to a single repo; a multi-repo project just adds a parent CLAUDE.md and a designated planning home — see **Set up your CLAUDE.md files** below.

## Why it's document-driven

**Claude Code sessions have no memory of each other.** Close a session and what it learned is gone. This system makes *documents* the memory — audits, plans, briefs, reports, and merge records are written to predictable paths, committed to git, and read by the sessions and routines that follow.

**A non-coder driving a coding agent needs guardrails, not raw autonomy** — approval gates before anything irreversible, plain-English explanations, and a "stop and ask" rule instead of endless workarounds. *(Details in Guardrails philosophy below.)*

**The documents aren't just scaffolding — they're a deliverable.** You come out with a complete, plain-English paper trail for *both* sides: the build plan, briefs, and acceptance criteria a **PM** needs, and the audits, execution plans, review findings, and merge records a **developer** needs — all version-controlled alongside the code.

**Token efficiency.** The documents cost output tokens — but the trade pays off. A single long session carries its whole, ever-growing history into every turn, so it gradually degrades and eventually hits the context limit. Starting a fresh session with just the relevant document keeps each one lean, focused, and reliable. (Cost can creep up in long sessions too, though prompt caching softens that — the surer wins are quality and not running out of room.)

## What you need to know before you start

This workflow is built for non-coders — but "non-coder" isn't "no setup knowledge." Claude Code does the code; **you** make the decisions and run the git steps, so a little baseline is the difference between smooth and frustrating.

**Comfort with a code editor and a terminal.** You'll work in an editor like [Cursor](https://cursor.com) or [VS Code](https://code.visualstudio.com) and run commands in a terminal — `cd` into a folder, start `claude`, run the occasional git command. You won't write code; you do need to be comfortable opening files, switching branches, and pasting commands.

**A working mental model of Git — this is the big one.** You approve every branch, commit, push, and merge, so you need to know what they mean:

- **Branches & the working folder** — your folder shows *one branch at a time*; a file can seem to "vanish" when you switch branches (it's safe — just on another branch).
- **Commits & staging** — saving work into a branch, and choosing which files go in.
- **Local vs. GitHub** — your machine and GitHub are *separate copies*, synced with `push` (up) and `pull` (down). A merge on GitHub won't appear locally until you `pull`.
- **Pull requests & merging** — proposing a branch to merge into the main line, and what "merged" means.

  *If any of those feel fuzzy, spend 30 minutes with a beginner Git guide first (e.g. [GitHub's intro to Git](https://docs.github.com/en/get-started/using-git/about-git)). It will save you hours.*

**Expect lots of documents — and a fresh session per task.** That's the design (see *Why it's document-driven* above), not busywork.

**`gh` (GitHub CLI) installed and logged in** — the `open-pr` skill uses it to create PRs. It's a command-line tool, separate from the GitHub website and the GitHub Desktop app.

You don't need any of this *perfectly* — Claude Code explains as it goes — but the more you recognise, the smoother it'll be.

## The workflow at a glance

1. **Codebase audit** (`/codebase-understanding-audit`) — read-only exploration, run once per repo, produces an audit document.
2. **Build plan** (`/build-plan`) — reads the audits, produces a prioritised plan (MoSCoW) with acceptance criteria.
3. **Feature briefs** (`/feature-brief`) — one per Must Have functionality, each scoping exactly what to build.
4. **Gap check** — a session prompt that cross-checks all briefs against the build plan (completeness, conflicts, build order), gives a go/no-go, and then publishes the planning documents to the default branch.
5. **Build sessions** — per feature: `/execution-plan` → implement (tests + UAT) → `/pre-commit` → `/end-session` → `/pre-push`.
6. **Automated code review** — the `code-review` routine runs `/code-review` after the push and posts a GREEN / AMBER / RED recommendation to the branch.
7. **Fix sessions** — if the review finds problems, a fix session repeats the build session chain on the same branch.
8. **Ship** (`/open-pr`) — with a GREEN or AMBER verdict, draft and open the PR.
9. **Merge** — a developer reviews and merges.
10. **Automated merge documentation** — the `merge-documentation` routine runs `/merge-documentation`, producing a permanent merge record and updating CLAUDE.md.

```
Audit (per repo) ──> Build plan ──> Feature briefs ──> Gap check (go/no-go)
                                                            │
                                                            v
        ┌──────────────── Build session ─────────────────────┐
        │ /execution-plan → implement → /pre-commit           │
        │ → /end-session → /pre-push                          │
        └──────────────────────┬──────────────────────────────┘
                               v
                  code-review routine (GREEN/AMBER/RED)
                       │ RED → Fix session (loops back)
                       v GREEN/AMBER
                   /open-pr ──> developer merge ──> merge-documentation routine
```

> **⚠️ About the two routines.** Steps 6 and 10 are *designed* to run automatically as GitHub Actions (on push / PR-merge), but that setup isn't included here yet. Until you wire it up, run `/code-review` and `/merge-documentation` **manually** in a fresh session at those points — everything else works as described.

## Running it: terminal (CLI) or app (GUI)

The same Claude Code engine drives both, so the workflow, skills, and results are identical — pick whichever you prefer. The differences are only peripheral conveniences:

- **GUI (Desktop app):** rendered diffs, the CI-monitoring strip, a preview panel, a parallel-session sidebar
- **CLI (terminal):** scripting/automation, and running on a remote machine over SSH

The templates are written for the CLI, so the **only** interface-specific part is each recipe's **terminal step** (the `cd <repo>` + `claude` lines at the top). On the GUI, replace just that one step with "open/select the repo as your project" — every other line (the startup prompt, the skill invocations) is identical.

## The skills

| Skill | Phase | What it does | What it outputs |
|---|---|---|---|
| `pm-guardrails` | Opt-in, start of any workflow session | Core working rules for a non-developer PM: approval gates, plain-English communication, scope discipline, error handling, the loop guardrail | No document — rules applied throughout the session |
| `codebase-understanding-audit` | Explore | Read-only exploration of one repo: structure, tech stack, endpoints/pages, patterns, gaps, security observations. Never makes changes; runs on an `explore/` branch | `docs/audit/[repo-name]-audit.md` |
| `build-plan` | Explore | Reads the audit documents and produces a structured plan: gap analysis, MoSCoW-prioritised functionality list with testable acceptance criteria, out of scope, open questions | `docs/build-plan/[project-name]-build-plan.md` |
| `feature-brief` | Explore | Scopes one functionality from the build plan into a focused brief: boundaries, prerequisites, testable acceptance criteria tagged [AUTO]/[UAT]/[BOTH], technical constraints | `docs/briefs/[functionality-name]-brief.md` |
| `execution-plan` | Build / Fix | Produces the technical step-by-step implementation plan before any code is written; after approval, the first act of execution is creating the suggested branch. Also handles mid-session course corrections | `docs/plans/[functionality-name]-execution-plan.md` |
| `pre-commit` | Build / Fix close | Runs the repo's documented tests and checks, confirms UAT, checks every changed file against the execution plan, scans for sensitive data, proposes a conventional commit message; commits only after explicit approval | An approved, verified commit |
| `end-session` | Build / Fix close | Documents what actually happened while session memory is still available: commits, decisions and abandoned approaches, acceptance criteria status, tech debt, and review guidance for the code-review routine. Commits its own docs-only report after a self-check | `docs/reports/end-session-[branch]-[date].md` |
| `pre-push` | Build / Fix close | Final gate before GitHub: confirms branch and commit set, runs a last sensitive data scan, pushes only after explicit approval | An approved push (which triggers the code-review routine) |
| `code-review` | Post-push routine | Adversarial pre-PR review in a fresh session: checks the diff against CLAUDE.md conventions, security rules, scope, and acceptance criteria; cross-references the end-session report; ends with a GREEN / AMBER / RED recommendation. Commits and pushes its report to the feature branch. Optional deep-review mode runs multiple reviewers and keeps only majority-confirmed findings | `docs/reports/code-review-[branch]-[date].md` |
| `open-pr` | Ship | Verifies the review verdict (RED blocks the PR), drafts the PR description entirely from session documents, confirms details, opens the PR with `gh pr create`, and posts a comment linking the review findings | A GitHub pull request |
| `merge-documentation` | Post-merge routine | Documents what shipped: merge record, build plan status updates, AMBER-warning reconciliation, CLAUDE.md updates for new endpoints/dependencies/patterns, and archives the branch's working documents | `docs/releases/[date]-[branch-name]-merge.md` plus CLAUDE.md updates |

## Document pathways

All workflow documents live in a `docs/` folder at the root of a repository — never outside a repo — and must be committed to be visible to routines and other machines.

Every repo carries its own:

- `docs/audit/` — audit documents
- `docs/plans/` — execution plans
- `docs/reports/` — end-session and code review reports
- `docs/releases/` — merge records
- `docs/archive/` — archived working documents (moved here after merge)

The two project-wide planning folders live in **one** repo:

- `docs/build-plan/` — the build plan (one per project)
- `docs/briefs/` — feature briefs

In a single-repo project that's just the repo. In a multi-repo project you pick one repo to be the **shared planning home** — a single source of truth, not a copy per repo.

The templates use `[repo-a]` as the example planning home — swap in whichever of your repos suits.

## Guardrails philosophy

The `pm-guardrails` skill is the foundation every other skill builds on. Its core rules:

- **Hard stops.** Explicit user approval is required before creating or switching branches, committing, pushing, installing dependencies, modifying configuration, changing more than one file, running destructive commands, running the app for the first time in a session, taking any hard-to-undo action, opening a PR, or merging a branch.
- **Plain English first.** Every action is explained before it happens; code is never presented without context; the user is assumed to be unable to read code, so explanations are their only window into what is happening.
- **The loop guardrail.** When user input would resolve a blockage faster than further attempts (missing env var, failed install, permission error, port conflict, merge conflict, ambiguous failing test), the agent stops and asks instead of trying workarounds — stating what it tried, why it failed, and exactly what it needs.
- **The single documented exception.** Skills with a documented docs-only self-check — `end-session`, `code-review`, and `merge-documentation` — may commit (and, for the latter two, push) their own documentation autonomously, provided the self-check passes: the diff must contain only files under `docs/` and CLAUDE.md files, or the skill aborts. This is the only waiver, and it exists so end-session and the two routines can commit their own reports without an approval step.

## Set up your CLAUDE.md files (do this first)

The skills read each repo's `CLAUDE.md` as their source of truth — toolchain, commands, how to run and verify the app, conventions, security. **The workflow is only as good as these files**, so set them up before running anything.

**For each repo:**
1. Run Claude Code's `/init` — it reads the codebase and generates a first-draft `CLAUDE.md`.
2. Refine it against [`templates/repo-CLAUDE-template.md`](templates/repo-CLAUDE-template.md) so it covers toolchain commands, runtime checks, conventions, and security.

**One repo vs. several:**

- **One repo** → done: one `CLAUDE.md` in the repo. The session templates' base case is written for you — ignore every `► Several repos?` callout.
- **Several repos** → each repo gets its own `CLAUDE.md` (as above), **plus a parent `CLAUDE.md`** built from [`templates/parent-CLAUDE-template.md`](templates/parent-CLAUDE-template.md):
  - **Why** — when a session needs cross-repo context (e.g. building an integration), one repo's CLAUDE.md isn't enough; the parent gives the system overview (what each repo is, how they relate, the goal).
  - **Where** — in the folder that *contains* your repos (`[path-to-your-repos]/CLAUDE.md`), **not** inside any repo.
  - **When** — multi-repo projects only. Also pick one repo as the **shared planning home** (it holds `docs/build-plan/` and `docs/briefs/`).
  - The session templates flag every difference with a `► Several repos?` callout — just follow those.

## Installation

Copy the 11 skill folders into one of:

- `~/.claude/skills/` — user level: available in every project on your machine.
- `<repo>/.claude/skills/` — project level: travels with the repo, and is what CI (the GitHub Actions routines) uses.

```bash
# user level
cp -R pm-guardrails codebase-understanding-audit build-plan feature-brief \
      execution-plan pre-commit pre-push end-session code-review open-pr \
      merge-documentation ~/.claude/skills/
```

The `templates/` folder holds two kinds of starting point: the **session prompts** that drive the workflow (terminal commands, startup prompts, and skill invocations for each phase), and the two **CLAUDE.md skeletons** (`repo-CLAUDE-template.md`, `parent-CLAUDE-template.md`). Copy the session prompts, replace the placeholders (`[project-name]`, `[repo-a]`/`[repo-b]`, `[path-to-your-repos]`), and adapt them to your project.

## Requirements

- [Claude Code](https://claude.com/claude-code)
- git, and a GitHub remote for your repos
- [GitHub CLI (`gh`)](https://cli.github.com/) — used by `/open-pr`
- The two routines (`code-review` on push, `merge-documentation` on PR merge) are designed to run as event-triggered GitHub Actions. The Actions configuration is not included in this repo (yet) — until you set it up, both skills can be invoked manually in a fresh session.

## Adapting to your project

- [ ] Set up your `CLAUDE.md` files — see **Set up your CLAUDE.md files** above (`/init` to draft, refine against the template; multi-repo adds a parent file). Several skills read these as their source of truth.
- [ ] Pick the repo that will be the shared planning home for the build plan and feature briefs (single-repo projects: it is just the repo).
- [ ] Copy and adapt the `templates/` files (Installation covers the placeholders to replace).
- [ ] Decide your default branch name(s) — the skills refuse to commit or push directly to the default branch.

## License

MIT — see [LICENSE](LICENSE).
