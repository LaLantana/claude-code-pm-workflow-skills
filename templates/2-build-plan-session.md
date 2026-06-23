# Explore Session — Build Plan

Run once after the audit is complete.

## Step 1 — Terminal

cd into your repo, then start Claude:

```bash
cd [path-to-your-repos]/[repo]
claude
```

> ► **Several repos?** cd the parent folder `[path-to-your-repos]` instead, so the session can see every repo.

## Step 2 — Startup prompt

```text
I am starting a Build Plan session for [project-name].
Before doing anything:
1. Read ~/.claude/skills/pm-guardrails/SKILL.md and apply its rules throughout this session.
2. Read this repo's CLAUDE.md
3. Summarise your understanding of the current goal
Wait for my confirmation before taking any action.
```

> ► **Several repos?** Change step 2 to read the parent CLAUDE.md plus every repo's CLAUDE.md: "Read `[path-to-your-repos]/CLAUDE.md`, `[repo-a]/CLAUDE.md`, and `[repo-b]/CLAUDE.md`."

## Step 3 — Build plan invocation (after confirmation)

```text
/build-plan
Project type: [integration / greenfield / refactor]
Goal: [plain English description of what we are building]
Save the build plan to [repo]/docs/build-plan/.
Context:
- [repo]/docs/audit/[repo]-audit.md
- [any additional context documents]
```

> ► **Several repos?** Save the build plan to your planning-home repo (`[repo-a]/docs/build-plan/` — the repo you designate as the shared planning home), and add every repo's audit to the context:
> ```text
> - [repo-a]/docs/audit/[repo-a]-audit.md
> - [repo-b]/docs/audit/[repo-b]-audit.md
> ```
