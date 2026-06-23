# Routine 1 — Code Review

- **Name:** `code-review`

- **Trigger:** GitHub push event on the [repo-a] and [repo-b]
  repos. Filters (configured in the GitHub Actions setup, to be built):
  only `feature/**` and `fix/**` branches; skip pushes that touch
  only `docs/**` — this prevents the routine's own report commit
  from re-triggering it.

- **Prompt:**

```text
Run /code-review
Context:
- docs/reports/ (latest end-session report — in this repository)
- [repo-a]/docs/briefs/ (latest feature brief — briefs live in
  the repo you designate as the shared planning home ([repo-a]
  in these templates); in a [repo-a] checkout this path is
  simply docs/briefs/; cross-repo access in CI is handled by
  the GitHub Actions setup, to be configured)
- docs/plans/ (latest execution plan — in this repository)
```
