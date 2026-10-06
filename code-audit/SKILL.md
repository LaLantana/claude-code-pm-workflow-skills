---
name: code-audit
description: Read-only audit of one repository. Maps what exists, how it works and what is missing, and writes docs/audit/[repo]-audit.md. Run once per repo, before /project-plan.
disable-model-invocation: true
---

# Code Audit

A read-only exploration of the repository you are in. The only file it creates is
the audit document at `docs/audit/[repo-name]-audit.md`. Follow the working rules
in the repo's CLAUDE.md throughout.

## Rules
- Read only. Never create, edit or delete anything except the audit document.
- Observations only. Do not suggest fixes or implementations.
- Never assume. Anything unclear becomes an open question.
- Never read `.env`. Learn required configuration from `.env.example` only.

## Step 1 — Orient
Read the repo CLAUDE.md (and the parent CLAUDE.md if one exists), the dependency
manifest (`package.json` or equivalent), the top-level folder structure, and any
README or existing documentation.

State in plain English:
- Repository type: frontend, backend, full-stack, library, or other
- Primary language, framework and runtime, with versions
- Key dependencies and what each is for
- Any architectural pattern that is obvious at this level
- Approximate number of source files

## Step 2 — Choose the depth
Under about 50 source files: read the codebase directly in Step 3.

50 or more: tell the user you will use subagents. Group the folders from Step 1,
launch one subagent per group in parallel, and have each return exactly:
- Folder: [name]
- Purpose: [one sentence]
- Key files: [list]
- Patterns observed: [list]
- Dependencies on other folders: [list]
- Open questions: [list]

Use the summaries as the input to Step 3. If the codebase is still too large to
cover even this way, stop, propose scoping the audit to the most relevant folders,
and wait for the user's answer.

## Step 3 — Map
For any repository: folder purposes, entry points, configuration files and what
they control, required environment variables (from `.env.example`), dependencies
and their purpose, what the tests cover and what they do not, existing
documentation.

For a backend, also: every endpoint (method, path, purpose, inputs, outputs), data
models and schema, database type and connection, authentication and security
patterns, external integrations, and the step-by-step pattern for adding a new
endpoint, written so a future session can follow it without re-reading the code.
Note endpoints that look incomplete or placeholder.

For a frontend, also: every page and route, key components and what they render,
how data is handled (static, mocked, live), existing API calls and what they hit,
UI conventions, styling approach and whether a `DESIGN.md` or design system exists,
hardcoded or placeholder data, and missing UI states (loading, empty, error).

## Step 4 — Find the gaps
From the map: what exists but is incomplete, what is missing entirely, what is
hardcoded or mocked that should be dynamic, technical debt worth noting, and any
obvious security concern (committed secrets, hardcoded credentials, missing
`.gitignore` entries). Flag security concerns clearly; do not fix them.

If this repository is meant to connect to a counterpart (a frontend to this
backend, or the reverse), list what it needs from that counterpart: data,
endpoints, behaviours.

## Step 5 — Write the document
Save to `docs/audit/[repo-name]-audit.md`, creating the folder if needed.

```
Audit: [repository name]
Date: YYYY-MM-DD
Repository type: Frontend / Backend / Full-stack / Library / Other

## Repository overview
## Tech stack
## Structure map
## Endpoints (backend) / Pages and components (frontend)
## Data and models (backend) / Data handling (frontend)
## External integrations
## Existing patterns
## Test coverage
## Gaps and missing pieces
## Security observations
## Technical debt
## Connection requirements   (only if a counterpart system exists)
## Open questions
```

Each section is plain English. "Existing patterns" includes the step-by-step
recipe for the most common addition (a new endpoint, a new page). "Open questions"
tags who needs to answer each one: the user, a developer, or an external party.

## Step 6 — Present and stop
Confirm where the file was saved. Give a summary of at most ten lines: type and
stack, size, the three biggest gaps, any security flags, how many open questions.
Show the full document only if asked.

Suggest committing the audit (`git add docs/audit` on a branch of the user's
choosing) and stop. Do not commit, and do not start any other work.
