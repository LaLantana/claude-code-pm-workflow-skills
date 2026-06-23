# Doc Saving Pathways

All workflow documents live in a `docs/` folder at the root of a
repository — never outside a repo. Documents must be committed
to be visible to routines and other machines.

## In every repo ([repo-a] and [repo-b])

| Folder | Contents |
|---|---|
| `docs/audit/` | audit documents |
| `docs/plans/` | execution plans |
| `docs/reports/` | end-session and code review reports |
| `docs/releases/` | merge records |
| `docs/archive/` | archived documents |

## In the shared planning home only

The repo you designate as the shared planning home ([repo-a]
in these templates) additionally holds:

| Folder | Contents |
|---|---|
| `docs/build-plan/` | build plan (one per project) |
| `docs/briefs/` | feature briefs |

## Paths

From a session started in the parent folder, paths are
`[repo-a]/docs/...` and `[repo-b]/docs/...`; from a
session started inside one repo, sibling-repo docs are at
`../[repo-a]/docs/...` etc.
