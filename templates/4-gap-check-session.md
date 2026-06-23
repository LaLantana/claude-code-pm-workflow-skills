# Explore Session — Gap Check

Run after all Must Have briefs are produced.

## Step 1 — Terminal

cd into your repo, then start Claude:

```bash
cd [path-to-your-repos]/[repo]
claude
```

> ► **Several repos?** cd the parent folder `[path-to-your-repos]` instead, so the session can see every repo.

## Step 2 — Startup prompt

```text
I am starting a Gap Check session for [project-name].
Before doing anything:
1. Read ~/.claude/skills/pm-guardrails/SKILL.md and apply its rules throughout this session.
2. Read this repo's CLAUDE.md
3. Summarise your understanding of the current goal
Wait for my confirmation before taking any action.
```

> ► **Several repos?** Change step 2 to read the parent CLAUDE.md plus every repo's CLAUDE.md: "Read `[path-to-your-repos]/CLAUDE.md`, `[repo-a]/CLAUDE.md`, and `[repo-b]/CLAUDE.md`."

## Step 3 — Gap check prompt (after confirmation)

```text
I have produced briefs for all Must Have functionalities.
Before I close this explore session, please:

1. Read all feature briefs in [repo]/docs/briefs/
2. Read the build plan in [repo]/docs/build-plan/
3. Check for the following and report back:

COMPLETENESS
- Are all Must Have items from the build plan
  covered by a brief?
- Are there any Must Have items with no
  corresponding brief?

GAPS BETWEEN BRIEFS
- Is there any functionality needed by one brief
  that is not covered by another?
- Are there any shared dependencies between briefs
  that have not been accounted for?

BUILD ORDER CONSISTENCY
- Are the build order dependencies consistent
  across all briefs?
- Is there any circular dependency — where brief A
  depends on brief B which depends on brief A?

CONFLICTS
- Are there any conflicting acceptance criteria
  across briefs?
- Are there any briefs that make assumptions about
  how another brief will be implemented that could
  cause problems?

PREREQUISITES
- Are all prerequisites listed in the briefs
  realistic and achievable before the build starts?
- Is anything missing from the prerequisites list?

4. Produce a plain English summary of:
- Any gaps found — what is missing and where
- Any conflicts found — what needs to be resolved
- Any build order issues — what needs to change
- A recommended reading order for the briefs
  based on build order dependencies
- Whether it is safe to proceed to the
  Build sessions or whether issues need
  resolving first

Do not begin any implementation work.
Wait for my review before closing this session.
```

> ► **Several repos?** The briefs and build plan live in your planning-home repo, so read `[repo-a]/docs/briefs/` and `[repo-a]/docs/build-plan/` instead.

## Wrap-up — Publish planning documents

Run only after the gap check passes and you confirm.

```text
The planning documents exist only in the local working
tree until committed. In the repo containing the new
planning documents (build plan, feature briefs, and its
own audit):

1. Create a documentation branch named docs/planning-docs.
2. Stage only the planning documents. Propose a commit
   message and wait for my approval.
3. After approval, commit. Then wait for my approval
   before pushing and merging to the default branch.

These are documentation-only changes.
Do not begin any implementation work.
```

> ► **Several repos?** Do this once per repo that gained planning documents. The shared planning home ([repo-a] in these templates) carries the build plan, feature briefs, and its own audit; every other repo carries only its own audit.
