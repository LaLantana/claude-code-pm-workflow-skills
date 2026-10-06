# Session prompts

One session per skill run. `cd` into the repo, start `claude`, paste the prompt.
Each skill reads the repo CLAUDE.md itself, so the prompt is just the invocation
and whatever context the skill needs.

> **Several repos?** Run `/code-audit` in each repo. Run `/project-plan` from the
> parent folder so it can see every audit, and tell it which repo is the planning
> home (where `docs/project-plan.md` and `docs/stories/` live). Run `/story` in
> the planning home. Run `/build-feature` in the repo where the code changes; if a
> feature touches two repos, run it once per repo with the same ID.

## Code audit (once per repo)

```text
/code-audit
```

## Project plan (once per project)

```text
/project-plan
Goal: [what we are building, in plain English]
Context: [paths to audits, a product description, research notes — optional]
```

Set the `Project settings` lines in CLAUDE.md first; the skill reads them from
there: `Tracker:` (Google Sheets or Linear), `Linear team:` if Linear,
`Language:`, and `Stakeholder reviewer:` for a Sheets project with one.
It ends by opening a docs-only PR with the plan; merge it and pull before the
first `/story`.

## Story (once per feature, just before building it)

```text
/story [id]
```

`[id]` is the feature's ID in the feature matrix, for example `2.4`. The story
file stays uncommitted until `/build-feature` picks it up; that is expected.

## Build feature

```text
/build-feature [id]
```

Two approvals during the session: the plan, then the PR. If a session stops
before the PR, run the same command again; it picks up where it left off.

## Fix round (feedback on an open PR, or a UAT item that failed)

```text
/build-feature [id]
[Optional: which UAT item failed and what you saw. Developer review comments
are read from the PR automatically.]
```

The skill sees the feature is `In review` and works on the existing branch; the
open PR updates itself.

## What happens on its own
- The first `/build-feature` session after a feature merges writes that
  feature's merge record and marks it `Shipped` in the matrix.
- Pushing and opening a PR go through a permission prompt; that prompt is the
  approval.
- A commit on the default branch is blocked by the hook.
