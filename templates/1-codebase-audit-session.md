# Explore Session — Codebase Audit

An audit is always one repo at a time.

> ► **Several repos?** Run this whole recipe once per repo.

## Step 1 — Terminal

cd into the repo you're auditing, then start Claude:

```bash
cd [path-to-your-repos]/[repo]
claude
```

## Step 2 — Startup prompt

```text
I am starting a Codebase Audit session for [project-name].
Before doing anything:
1. Read ~/.claude/skills/pm-guardrails/SKILL.md and apply its rules throughout this session.
2. Read this repo's CLAUDE.md
3. Summarise your understanding of the current goal
Wait for my confirmation before taking any action.
```

> ► **Several repos?** Add to step 2: "Also read the parent system overview at `[path-to-your-repos]/CLAUDE.md`."

## Step 3 — Create explore branch (after confirmation)

```text
Create and switch to a new branch named
explore/[repo]-audit (e.g., explore/[repo-a]-audit).
Show me the command and wait for my approval before
running it. Confirm once the branch is created.
```

## Step 4 — Audit invocation (after branch creation)

```text
/codebase-understanding-audit
Repo: [repo]
Goal: Understand the full structure, patterns, and
gaps in this codebase to inform the
build plan.
```
