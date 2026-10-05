# Workflow Overview

## Explore session

- /codebase-understanding-audit
- /build-plan
- /feature-brief (run multiple times)
- Gap check prompt (md file)
- Planning documents committed and merged to default branch

## Workstream 1 — Build

- Startup prompt (md file)
- /execution-plan
- Build + tests + UAT
- /pre-commit
- /end-session
- /pre-push

### Post-push routine

- code-review routine (calls /code-review)

## Workstream 2 — Fix (if needed)

- Startup prompt (md file)
- /execution-plan
- Fix + tests + UAT
- /pre-commit
- /end-session
- /pre-push

### Post-push routine

- code-review routine (calls /code-review)

## Workstream 3 — Ship

- Startup prompt (md file) (pull branch; GREEN or AMBER gate)
- /open-pr
- Developer reviews
- Merge triggers merge-documentation routine

## Branch cleanup

- Remote (GitHub): enable "Automatically delete head branches" per repo — merged branches delete on merge.
- Local: the pm-guardrails session start checks flag any leftover merged local branches for you to delete.
