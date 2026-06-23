# Routine 2 — Merge Documentation

- **Name:** `merge-documentation`

- **Trigger:** GitHub pull_request merged event on both repos

- **Prompt:**

```text
Run /merge-documentation
Context:
- docs/reports/ (latest end-session and code review reports — in
  this repository)
- [repo-a]/docs/briefs/ (latest feature brief — briefs live in
  the repo you designate as the shared planning home ([repo-a]
  in these templates); in a [repo-a] checkout this path is
  simply docs/briefs/; cross-repo access in CI is handled by
  the GitHub Actions setup, to be configured)
- docs/plans/ (latest execution plan — in this repository)
- [repo-a]/docs/build-plan/ (build plan — lives in the
  shared planning home repo; in a [repo-a] checkout this
  path is simply docs/build-plan/)
```
