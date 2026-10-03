---
name: feature-brief
description: Scopes one specific functionality from the build plan 
into a focused brief. Invoke during the explore session after 
build-plan has been completed. Provide the functionality name, 
build plan path, and relevant audit document paths in the 
invocation prompt. Run once per functionality.
disable-model-invocation: true
---

# Feature Brief

This skill scopes one specific functionality from the build plan 
into a focused brief. It does not make implementation decisions 
or write code. Its primary output is a markdown document saved to 
docs/briefs/; on approval it also adds the brief link to that 
functionality's row in the build plan's feature matrix and runs a 
re-prioritisation check — see Step 5.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- One functionality per invocation — never scope multiple 
  functionalities in a single brief
- Never make implementation decisions — describe WHAT 
  is being built, not HOW
- Derive everything from the build plan and provided 
  context — never invent requirements
- If the named functionality cannot be found in the 
  build plan, stop and tell the user before proceeding
- Every acceptance criterion must be written in a 
  way that is testable — either automatically or 
  via manual UAT. If a criterion cannot be tested, 
  flag it to the user and rewrite it together before 
  finalising the brief. A brief with untestable 
  criteria must not be approved.

## Branch
This skill runs during the explore phase, on the same 
explore/ branch as codebase-understanding-audit and 
build-plan.
If the session is running inside a repository and no 
explore/ branch exists, stop and tell the user before 
doing anything else.
If the session is running from a folder that is not a 
git repository (a multi-repository planning session), 
note this and proceed — planning documents are committed 
at the end of the explore phase.

## Step 1 — Read all provided context
Read every document listed in the invocation prompt 
before doing anything else. This should include at minimum:
- The build plan
- The relevant codebase audit document(s)
- CLAUDE.md files available in context

State what you have read in a brief list and proceed 
immediately to Step 2 without waiting for confirmation.

## Step 2 — Locate the functionality
Find the named functionality in the build plan.

Extract and state in plain English:
- The functionality name
- What it does — from the build plan
- Its MoSCoW priority — from the build plan
- Its build order dependencies — from the build plan
- Its acceptance criteria — from the build plan
- Any relevant notes or open questions from 
  the build plan

If any of the above are missing or unclear in the 
build plan, flag this to the user before proceeding.

## Step 3 — Identify scope boundaries
Based on the build plan, audit documents, and CLAUDE.md, 
identify:

- Which repos are affected — one or more
- What this functionality explicitly does NOT include — 
  derived from the build plan's out of scope section 
  and the functionality's own boundaries
- What must already be in place before this 
  functionality can be built — from build order 
  dependencies
- Any open questions from the build plan that 
  are relevant to this functionality
- Existing patterns from the audit documents that 
  apply to this functionality

## Step 4 — Produce the feature brief
Write a focused brief document using this structure:

---
Feature Brief: [functionality name]
Date: YYYY-MM-DD
Repos affected: [list affected repos]

## What we are building
One to two sentences in plain English describing 
what this functionality does and what problem it solves.

## Why we are building it
One sentence tracing this back to the build plan 
goal and gap analysis.

## What this is not
Explicit boundaries — what is out of scope for 
this specific functionality. Be specific.

## Prerequisites
What must already be built or in place before 
a build session for this functionality begins.
If prerequisites are not met, the build session 
should not start.

## Acceptance criteria
Specific, testable, binary statements describing 
how we know this functionality is complete.

Carry over acceptance criteria from the build plan 
and expand them here. Where the build plan criteria 
are high-level or vague, make them specific and 
testable. Add:
- Edge cases not captured in the build plan
- Error states — what happens when something goes wrong
- Empty states — what happens when there is no data
- Boundary conditions — limits, minimums, maximums

Each criterion must be:
- Specific — no ambiguous language
- Testable — can be verified without interpretation
- Binary — either done or not done

Before finalising acceptance criteria, verify 
each one is testable by asking:
- Can this be verified by an automated test? 
  If yes, it is automatically testable.
- Can this be verified by a human following 
  a clear step-by-step check? If yes, it is 
  manually testable via UAT.
- If neither — the criterion is too vague and 
  must be rewritten before the brief is approved.

Tag each criterion with its test type:
- [AUTO] — verifiable by automated test
- [UAT] — verifiable by manual check
- [BOTH] — verifiable by both

## Technical constraints
Relevant constraints that apply to this functionality, 
drawn from:
- CLAUDE.md — naming conventions, patterns to avoid, 
  working rules specific to this project
- Codebase audit documents — existing patterns that 
  must be followed when building this functionality

Do not repeat the full CLAUDE.md — extract only 
what is directly relevant to this functionality.

## Design approach (new-UI items only)
For items that introduce new UI (a new screen or component), 
include a one-line design approach: *direct build*, *direct 
build + mockup checkpoint*, or *design-first ticket* — following 
the project's documented UI design workflow (e.g. a repo 
CLAUDE.md "UI design workflow" section). Wiring an 
already-designed screen is implicitly *direct build*. Omit this 
line for non-UI (e.g. backend) items.

## Open questions
Any unresolved questions relevant to this functionality.
For each:
- State the question clearly
- Tag who needs to answer it — user, a developer, 
  or external party
- State whether it is blocking (brief cannot be 
  finalised until resolved) or non-blocking 
  (can resolve during build)

If any blocking questions exist, stop here — do not 
save or present the brief until they are resolved.
---

## Step 5 — Save and present
Save the document to:
docs/briefs/[functionality-name]-brief.md
(path relative to the repository root)

If docs/briefs/ does not exist, create it.
Confirm to the user where the file was saved.

Present the full document in the chat.
Do not summarise — show everything.

Wait for user approval before finalising.
If the user requests changes, update the document 
and wait for approval again.

After approval, before finishing, update the build plan to reflect
the approved brief:

1. Add the brief link to the feature matrix. In the build plan's
   feature matrix, put a link to the saved brief in this item's Brief
   column — the link is what signals the brief exists (there is no
   status field to set). If the build plan has no feature matrix yet
   (e.g. it predates this convention), do not silently skip: tell the
   user the matrix is missing and offer to add one. Edit the plan
   document in place and follow the project's convention for when
   planning documents are committed (e.g. leave uncommitted if the
   project batches planning docs). Change nothing else in the plan.
2. Re-prioritisation check. Now that the brief has surfaced more
   detail, consider whether anything learned while writing it — new
   dependencies, wider scope, more effort or risk, or that it now
   spans more repos than expected — changes this item's priority or
   its position in build order. If it might, present the recommended
   change and your reasoning to the user in plain English and wait
   for their decision. Never change a priority or reorder the plan
   yourself — flag it; the user decides. If nothing changed, state
   that priority and build order were reconfirmed.

This per-brief check catches drift one item at a time. A broader
review of priorities across all briefed items belongs at the
project's Gap Check.

Once the matrix is updated and any re-prioritisation is resolved,
stop completely. The brief is now ready for use in a future Build
session. Do not begin any implementation work in this session.