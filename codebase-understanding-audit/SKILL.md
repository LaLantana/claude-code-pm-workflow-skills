---
name: codebase-understanding-audit
description: Read-only exploration of a repository. Produces a 
structured audit document mapping what exists, how it works, 
and what is missing. Frontend and backend agnostic. Invoke on 
explore/ branches only. Never makes changes.
disable-model-invocation: true
---

# Codebase Audit

This skill performs a read-only exploration of a repository and 
produces a structured audit document. It makes no changes to 
any files under any circumstances. Its sole output is a markdown 
document saved to docs/audit/ (relative to the repository root).

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- Read only — never create, edit, or delete any file except 
  the output document in docs/audit/
- Never suggest fixes, improvements, or implementations during 
  the audit — observations only
- Never make assumptions — if something is unclear, note it 
  as an open question
- Always confirm you are on an explore/ branch before starting
- If the codebase is too large to audit completely within 
  context limits, stop and tell the user — propose scoping 
  the audit to the most relevant folders and wait for approval 
  before proceeding

## Step 1 — Confirm branch and detect repository type
First confirm you are on an explore/ branch. If not, stop and 
tell the user before doing anything else.

Then read:
- CLAUDE.md files available in context
- package.json or equivalent dependency file
- Top-level folder structure
- README or any existing documentation

From this, identify and state:
- Whether this is a frontend, backend, or full-stack repository. Do not proceed to Step 2 until repository type is confirmed.
- The primary language and framework
- The runtime environment
- Key dependency versions — runtime, framework, and any 
  major libraries
- Any immediately obvious architectural patterns

## Step 1b — Assess scope
After detecting repository type, assess the codebase size:
- Count the number of source files
- Estimate whether the full codebase can be read within 
  a single context window

If the codebase is small to medium (under ~50 source files):
→ Proceed to Step 2 directly

If the codebase is large (50+ source files):
→ Inform the user that subagents will be used
→ Define folder groupings based on what was found in Step 1
→ Launch one subagent per folder group in parallel
→ Each subagent maps its assigned folders and returns 
  a structured summary in this exact format:
    - Folder: [name]
    - Purpose: [one sentence]
    - Key files: [list]
    - Patterns observed: [list]
    - Dependencies on other folders: [list]
    - Open questions: [list]
→ Collect all subagent summaries
→ Proceed to Step 2 using summaries as input instead 
  of reading files directly

## Step 2 — Map the structure
Systematically read the codebase and map:

**For any repository:**
- Top-level folder structure and purpose of each folder
- Entry point(s)
- Configuration files and what they control
- Environment variables required (from .env.example only — 
  never read .env)
- Dependencies, their versions, and their purpose
- Test coverage — do tests exist, what do they cover, 
  what is untested
- Any existing documentation

**For a backend repository, additionally map:**
- All API endpoints — method, path, purpose, inputs, 
  expected outputs
- Data models and schema
- Database connection and type
- Authentication and security patterns
- External service integrations
- Existing patterns for adding new endpoints — document 
  in enough detail that future sessions can follow them 
  without reading the whole codebase again
- Any endpoints that appear incomplete or placeholder

**For a frontend repository, additionally map:**
- All pages and their routes
- Key components and what they render
- How data is currently handled — static, mocked, or live
- Any existing API calls and what they connect to
- UI patterns and component conventions
- Styling approach and any design system or brand guidelines
- Any placeholder or hardcoded data that will need replacing
- Missing UI states — errors, loading, empty states

## Step 3 — Identify gaps
Based on the mapping in Step 2, identify:
- What exists but is incomplete
- What is missing entirely
- What is hardcoded or mocked that should be dynamic
- What would be needed to connect this repository to its 
  counterpart (frontend or backend)
- Any technical debt worth noting
- Any obvious security concerns — hardcoded credentials, 
  committed secrets, missing .gitignore entries — flag 
  these clearly without attempting to fix them

## Step 4 — Produce the audit document
Write a structured audit document using this format:

---
Audit: [repository name]
Date: YYYY-MM-DD
Branch: [branch name]
Repository type: Frontend / Backend / Full-stack

## Repository overview
Brief plain English summary of what this codebase does 
and how it is structured.

## Tech stack
Complete list of technologies, frameworks, and key 
dependencies with their versions and purpose.

## Structure map
Folder by folder breakdown with purpose of each.

## API endpoints (backend) / Pages and components (frontend)
Complete inventory with descriptions, inputs, and outputs.

## Data and models (backend) / Data handling (frontend)
How data is structured, stored, and managed.

## External integrations
Any third-party services, APIs, or tools connected.

## Existing patterns
How things are done in this codebase — the conventions 
that must be followed when adding new functionality.
For backend: includes step-by-step pattern for adding 
a new API endpoint, documented in enough detail to follow 
without reading the codebase again.

## Test coverage
What is tested, what is not, and any obvious gaps.

## Gaps and missing pieces
What is incomplete, missing, hardcoded, or mocked.

## Security observations
Any obvious security concerns observed during the audit.
These are observations only — do not action them here.

## Connection requirements
What this repository needs from its counterpart to function 
as intended. Be specific — list data, endpoints, and 
behaviours required. This section directly informs the build plan.

## Technical debt
Anything worth noting for future attention — do not 
action during this audit.

## Open questions
Anything unclear that requires input from the user or 
a developer.
---

## Step 5 — Save and present
Save the document to:
docs/audit/[repository-name]-audit.md
(path relative to the repository root)

If docs/audit/ does not exist, create it.
Confirm to the user where the file was saved.

Present the full document in the chat.
Do not summarise — show everything.

Then stop and wait for the user to review before 
doing anything else.