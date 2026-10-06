# Claude Code PM Workflow Skills

Four Claude Code skills that let a non-coding Product Manager take a product from
idea or existing codebase to merged pull requests, and leave behind the three
documents a developer on a larger team will actually read: the story, the PR, and
the merge record. Safety comes from mechanisms (a permissions allowlist, a commit
hook, the PR itself) rather than from asking before every step, so a feature
costs two approvals: the plan and the PR.

Nothing here loads on its own. A repo opts in by carrying a CLAUDE.md built from
the template; a session opts in by invoking a skill. Prototype work in other
folders is untouched.

## The loop

```
/code-audit        once per existing repo        → docs/audit/[repo]-audit.md
/project-plan      once per project              → docs/project-plan.md + the feature matrix (Google Sheet)
        │
        ▼  per feature, in build order
/story [id]        just before building it       → docs/stories/[id]-[slug].md, matrix row → "Story approved"
/build-feature [id]                              → plan (approval 1) → implement + tests → review loop
                                                   until GREEN/AMBER → PR (approval 2), matrix row → "In review"
        │
        ▼
a developer reviews and merges the PR
        │
        ▼
the next /build-feature session writes the merge record → docs/releases/, matrix row → "Shipped"
```

Feedback on an open PR, from a developer's review or from a failed item on the
PR's UAT checklist, is handled by running `/build-feature [id]` again. It sees
the feature is in review, stays on the same branch, reads the PR comments itself,
and updates the open PR. The PM relays nothing.

## The skills

| Skill | When | What it produces |
|---|---|---|
| `code-audit` | Once per existing repo | Read-only audit: structure, stack, endpoints or pages, patterns, gaps, security observations. `docs/audit/[repo]-audit.md` |
| `project-plan` | Once per project | A mini PRD at `docs/project-plan.md`, and the feature matrix: one Google Sheet per project, created through the Sheets connector, with Area, ID, Feature, Source, Description, Impact, Effort, Priority, Phase, Story, Status, and optional stakeholder columns. The plan links to it |
| `story` | Once per feature, just before building it | A testable ticket at `docs/stories/[id]-[slug].md`: what we are building, why, what it is not, prerequisites, acceptance criteria tagged [AUTO]/[UAT]/[BOTH], technical constraints, open questions. Links itself from the matrix and may add rows the story reveals |
| `build-feature` | Once per feature, and again for each fix round | The build loop: session start checks and merge records, execution plan, implementation with a test per criterion, an adversarial review by a subagent until GREEN or AMBER, and the PR with a UAT checklist. Bounded attempts; stops with an escalation note the PM can forward |

Each skill folder is self-contained. `project-plan/feature-matrix.md` is the
full matrix specification.

## Setup

1. **Install the skills.** Copy the four folders to `~/.claude/skills/` (all
   projects) or `<repo>/.claude/skills/` (one repo).

   ```bash
   cp -R code-audit project-plan story build-feature ~/.claude/skills/
   ```

2. **Give each repo a CLAUDE.md.** Run `/init` in the repo for a first draft,
   then refine it against [`templates/repo-CLAUDE-template.md`](templates/repo-CLAUDE-template.md).
   The skills read it as their source of truth: commands, runtime checks,
   conventions, the project language, an optional stakeholder reviewer, and the
   "Working with a non-coding PM" rules. Several repos? Add a parent CLAUDE.md
   from [`templates/parent-CLAUDE-template.md`](templates/parent-CLAUDE-template.md)
   in the folder that contains them, and pick one repo as the planning home.

3. **Copy the safety settings into each repo.**

   ```bash
   mkdir -p <repo>/.claude/hooks
   cp templates/settings-template.json <repo>/.claude/settings.json
   cp templates/hooks/block-default-branch-commit.sh <repo>/.claude/hooks/
   ```

   Adjust the test and lint commands in the allowlist to the repo's own. The
   first time you open the repo in Claude Code, accept the trust dialog;
   until then the settings file is ignored.

4. **Connect Google Sheets** in Claude Code (the Google Sheets connector), so
   `/project-plan` can create the feature matrix and `/story` and
   `/build-feature` can update it.

5. **Keep design specs in `DESIGN.md`**, not in CLAUDE.md. `/project-plan` flags
   a UI project with no `DESIGN.md`, and no UI story is approved until one exists.

Session invocations are in [`templates/session-prompts.md`](templates/session-prompts.md).

## Safety by mechanism

| Concern | What enforces it |
|---|---|
| No commits on the default branch | `.claude/hooks/block-default-branch-commit.sh` |
| No push, PR, or package install without a human | `permissions.ask` in `.claude/settings.json` |
| No force-push, hard reset, recursive delete, branch force-delete | `permissions.deny` |
| No reading `.env` | `permissions.deny` plus the Security section of CLAUDE.md |
| Tests, lint and read-only git run without prompts | `permissions.allow` |
| Code review before every PR | The reviewer subagent in `/build-feature`, until GREEN or AMBER |
| The PM decides "what", the model decides "how" | The "Working with a non-coding PM" section of CLAUDE.md |
| Nothing runs on without a human when it is stuck | Bounded attempts and the escalation note |

The hook and settings only exist in repos you copy them into.

## Documents

Everything a project produces lives under `docs/` in the repo, except the feature
matrix, which is one Google Sheet per project linked from the plan and from
CLAUDE.md.

```
docs/audit/[repo]-audit.md           one per repo
docs/project-plan.md                 one per project (in the planning home, if several repos)
docs/stories/[id]-[slug].md          one per feature
docs/plans/[id]-plan.md              one per build or fix round
docs/releases/[date]-[id]-merge.md   one per shipped feature
```

Feature IDs (`2.4`) are assigned once by `/project-plan` and never renumbered; every
document and matrix cell refers to a feature by its ID.

## Requirements

- [Claude Code](https://claude.com/claude-code) with the Google Sheets connector
- git, and a GitHub remote for your repos
- [GitHub CLI (`gh`)](https://cli.github.com/), logged in, for opening and reading PRs
- A working mental model of branches, commits, pushes and PRs. If any of those
  feel fuzzy, [GitHub's introduction to Git](https://docs.github.com/en/get-started/using-git/about-git)
  is thirty minutes well spent

## Previous version

The original eleven-skill workflow is tagged
[`v1.0`](https://github.com/LaLantana/claude-code-pm-workflow-skills/releases/tag/v1.0).

## License

MIT — see [LICENSE](LICENSE).
