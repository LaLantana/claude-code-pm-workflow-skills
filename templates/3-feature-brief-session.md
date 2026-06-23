# Explore Session — Feature Brief

Run once per functionality in its own session.
Repeat for each Must Have functionality.

## Step 1 — Terminal

cd into your repo, then start Claude:

```bash
cd [path-to-your-repos]/[repo]
claude
```

> ► **Several repos?** cd the parent folder `[path-to-your-repos]` instead, so the session can see every repo.

## Step 2 — Startup prompt

```text
I am starting a Feature Brief session for [project-name].
Functionality: [exact name from build plan]
Before doing anything:
1. Read ~/.claude/skills/pm-guardrails/SKILL.md and apply its rules throughout this session.
2. Read this repo's CLAUDE.md
3. Summarise your understanding of the current goal
Wait for my confirmation before taking any action.
```

> ► **Several repos?** Change step 2 to read the parent CLAUDE.md plus every repo's CLAUDE.md: "Read `[path-to-your-repos]/CLAUDE.md`, `[repo-a]/CLAUDE.md`, and `[repo-b]/CLAUDE.md`."

## Step 3 — Feature brief invocation (after confirmation)

```text
/feature-brief
Functionality: [exact name from build plan]
Save the brief to [repo]/docs/briefs/.
Context:
- [repo]/docs/build-plan/[project-name]-build-plan.md
- [repo]/docs/audit/[repo]-audit.md
- [any additional context documents]
```

> ► **Several repos?** Save the brief to your planning-home repo (`[repo-a]/docs/briefs/` — the repo you designate as the shared planning home), and point the context at the planning home plus the relevant repo's audit:
> ```text
> - [repo-a]/docs/build-plan/[project-name]-build-plan.md
> - [relevant-repo]/docs/audit/[relevant-repo]-audit.md
> ```
