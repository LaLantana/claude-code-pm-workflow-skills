# Build Session Invocations

These sessions run in a single repo by default: cd into the
repo, read its CLAUDE.md, and all context paths are local
(`docs/briefs/...`, `docs/plans/...`).

> ► **Several repos?** Work that touches more than one repo starts
> from the parent folder `[path-to-your-repos]` — that session is for
> planning and coordination only. Execution still happens in one
> repo at a time: the execution plan must state which repo each
> branch and commit belongs to, and the closing chain (/pre-commit →
> /end-session → /pre-push) runs separately in each repo that changed.
> Context paths below are written repo-local; from the parent folder,
> prefix each with its repo (e.g., `[repo-a]/docs/briefs/...`), and
> reach a sibling repo from inside another with `../` (e.g.,
> `../[repo-a]/docs/briefs/...`).

---

## Workstream 1 — Feature

### Step 1 — Terminal

cd into the repo where the work lives, then start Claude:

```bash
cd [path-to-your-repos]/[repo]
claude
```

> ► **Several repos?** If the feature touches more than one repo, cd the
> parent folder `[path-to-your-repos]` instead.

### Step 2 — Startup prompt

```text
I am starting a Feature session for [project-name].
Before doing anything:
1. Read ~/.claude/skills/pm-guardrails/SKILL.md and apply its rules throughout this session.
2. Read this repo's CLAUDE.md
3. Run the runtime checks documented in this repo's CLAUDE.md (e.g., database running, dev server reachable)
4. Flag anything that looks wrong
5. Summarise your understanding of the current goal
Wait for my confirmation before taking any action.
```

> ► **Several repos?** If this session started from the parent folder,
> change step 2 to also read the parent and every repo's CLAUDE.md:
> "Read `[path-to-your-repos]/CLAUDE.md`, `[repo-a]/CLAUDE.md`, and
> `[repo-b]/CLAUDE.md`."

### Step 3 — Execution plan (after confirmation)

```text
/execution-plan
Session type: Feature
Goal: [brief description]
Context:
- docs/briefs/[functionality-name]-brief.md
- [any additional context documents]
```

> ► **Several repos?** Briefs live in your planning-home repo, so point
> the context there and add the relevant repo CLAUDE.md files:
> ```text
> - [repo-a]/docs/briefs/[functionality-name]-brief.md
> - [repo-a]/CLAUDE.md (if not already loaded)
> - [repo-b]/CLAUDE.md (if relevant)
> ```

---

## Workstream 2 — Fix

### Step 1 — Terminal

cd into the repo where the fix lives, then start Claude:

```bash
cd [path-to-your-repos]/[repo]
claude
```

> ► **Several repos?** If the fix touches more than one repo, cd the
> parent folder `[path-to-your-repos]` instead.

### Step 2 — Startup prompt

```text
I am starting a Fix session for [project-name].
Before doing anything:
1. Read ~/.claude/skills/pm-guardrails/SKILL.md and apply its rules throughout this session.
2. Read this repo's CLAUDE.md
3. Check out the branch being fixed and pull the latest changes — the code-review routine commits its findings to the branch on GitHub, so the local copy may be behind
4. Run the runtime checks documented in this repo's CLAUDE.md (e.g., database running, dev server reachable)
5. Flag anything that looks wrong
6. Summarise your understanding of the current goal
Wait for my confirmation before taking any action.
```

> ► **Several repos?** If this session started from the parent folder,
> change step 2 to also read the parent and every repo's CLAUDE.md:
> "Read `[path-to-your-repos]/CLAUDE.md`, `[repo-a]/CLAUDE.md`, and
> `[repo-b]/CLAUDE.md`."

### Step 3 — Execution plan (after confirmation)

```text
/execution-plan
Session type: Fix
Goal: [brief description of what to fix]
Context:
- docs/briefs/[functionality-name]-brief.md
- docs/plans/[functionality-name]-execution-plan.md
- docs/reports/end-session-[branch]-[date].md
- docs/reports/code-review-[branch]-[date].md
- [any additional context documents]
```

> ► **Several repos?** Briefs live in your planning-home repo; the plan
> and reports live in the repo with the branch. Repoint accordingly and
> add the relevant repo CLAUDE.md files:
> ```text
> - [repo-a]/docs/briefs/[functionality-name]-brief.md
> - [repo-with-the-branch]/docs/plans/[functionality-name]-execution-plan.md
> - [repo-with-the-branch]/docs/reports/end-session-[branch]-[date].md
> - [repo-with-the-branch]/docs/reports/code-review-[branch]-[date].md
> - [repo-a]/CLAUDE.md (if not already loaded)
> - [repo-b]/CLAUDE.md (if relevant)
> ```

---

## Workstream 3 — Ship

### Step 1 — Terminal

cd into the repo where the branch lives, then start Claude:

```bash
cd [path-to-your-repos]/[repo]
claude
```

> ► **Several repos?** A ship session is always one repo — the one whose
> branch you're shipping. If several repos changed, run Ship once per repo.

### Step 2 — Startup prompt

```text
I am starting a Ship session for [project-name].
Branch: feature/[name] or fix/[name] —
this branch already exists, do not create
or switch branches.

Before doing anything:
1. Read ~/.claude/skills/pm-guardrails/SKILL.md and apply its rules throughout this session.
2. Read this repo's CLAUDE.md
3. Pull the latest changes on this branch —
   the code-review routine commits its findings
   to the branch on GitHub, so the local copy
   may be behind
4. Read the latest code review findings
   in docs/reports/
5. Confirm the code review recommendation
   is GREEN or AMBER
6. Summarise what is ready to ship

Wait for my confirmation before taking
any action.
```

### Step 3 — Open PR (after confirmation)

```text
/open-pr
```

---

## Mid-session — Course correction

Use mid-session when a hard change of direction
is needed. Not a session-start invocation.
No terminal command needed — already in session.

```text
/execution-plan
Session type: Course correction
Goal: [plain English description of new direction]
Context:
- docs/plans/[original-plan-filename].md
- [any other relevant context]
```

> ► **Several repos?** The original plan lives in the repo with the branch;
> from the parent folder, prefix it: `[repo-with-the-branch]/docs/plans/[original-plan-filename].md`.
