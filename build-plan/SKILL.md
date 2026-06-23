---
name: build-plan
description: Analyses audit documents and produces a structured 
build plan for any project type. Invoke after codebase-understanding-audit 
or an equivalent audit has been completed. Provide project type and 
goal in the invocation prompt.
disable-model-invocation: true
---

# Build Plan

This skill reads audit documents and produces a structured build 
plan. It adapts its output structure to the project type declared in 
the invocation prompt. It does not write code, make implementation 
decisions, or begin any execution work. Its sole output is a markdown 
document saved to docs/build-plan/.

All rules in the pm-guardrails skill apply 
throughout this skill. If pm-guardrails has 
not been loaded, read ~/.claude/skills/
pm-guardrails/SKILL.md before proceeding.

## Absolute rules
- Analysis and planning only — never begin implementation
- Never make assumptions about what to build — derive everything 
  from the audit documents and invocation context provided
- If audit documents are missing or insufficient, stop and 
  tell the user what additional context is needed before proceeding
- Never produce a plan that cannot be traced back to something 
  in the audit documents or invocation context
- This session ends after the plan is approved — execution 
  begins in a separate Build session
  - Acceptance criteria must be testable — specific, 
  binary, and verifiable either automatically or 
  manually. Vague criteria that cannot be tested 
  should be flagged and refined before the plan 
  is finalised

## Branch
This skill runs during the explore phase, on the same 
explore/ branch as the codebase-understanding-audit 
that preceded it.
If the session is running inside a repository and no 
explore/ branch exists, stop and tell the user before 
doing anything else — codebase-understanding-audit 
should be run first.
If the session is running from a folder that is not a 
git repository (a multi-repository planning session), 
note this and proceed — planning documents are committed 
at the end of the explore phase.

## Step 1 — Read all provided context
Read every document listed in the invocation prompt before 
doing anything else.

Also read:
- CLAUDE.md files available in context
- Any additional context provided by the user

State what you have read in a brief list and proceed 
immediately to Step 2 without waiting for confirmation.

## Step 2 — Understand the project
From the documents read in Step 1, identify and state 
in plain English:

- What exists — a plain English summary of each system, 
  repo, or codebase described in the audit documents
- What the stated goal is — taken directly from the 
  invocation prompt
- What the gap is — the difference between what exists 
  and what the goal requires
- Who the end users are and what they need
- Any constraints, dependencies, or risks that are 
  immediately apparent

Present this understanding to the user in plain English.
Wait for confirmation that your understanding is correct 
before proceeding to Step 3.
If your understanding is wrong, ask the user to clarify 
before continuing.

## Step 3 — Determine output structure
Based on the project type declared in the invocation prompt 
and your understanding from Step 2, determine which sections 
are relevant for this plan.

Required in every plan:
- Project overview
- Gap analysis
- Prioritised functionality list
- Out of scope
- Open questions

Optional — include if relevant to this project:
- Connection requirements — for integration projects 
  connecting two or more existing systems
- Architecture decisions — for greenfield projects 
  requiring structural decisions
- Migration path — for redesign or refactor projects
- Data model changes — for projects affecting 
  database schema or data structures
- Third-party dependencies — for projects requiring 
  new external services or APIs
- Security considerations — for projects where security 
  observations were flagged in the audit documents

The list above is a guide not a constraint — if the user 
requests a section not listed here, include it.

State which optional sections you are including, 
which you are excluding, and your reasoning for each.
Wait for user approval of the proposed structure 
before producing the document.

## Step 4 — Produce the build plan
Write the build plan using the approved structure.

Guidance for each required section:

### Project overview
- What is being built and why — two to three sentences
- Who it is for and what problem it solves
- What success looks like — stated in plain English, 
  not business metrics unless relevant to this project

### Gap analysis
- What exists in each system or codebase
- What is missing or incomplete
- What needs to be built vs what needs to be connected
- Any conflicts or incompatibilities between systems

### Prioritised functionality list
List every piece of functionality that needs to be built 
to achieve the goal. For each item include:

- Functionality name — short and descriptive
- What it does — one sentence in plain English
- Why it is needed — traced back to the gap analysis
- Priority — using MoSCoW:
    Must have — cannot ship without this
    Should have — important but not blocking launch
    Could have — nice if time permits
    Won't have this time — explicitly deferred, 
    with a brief note on why
- Build order dependencies — which other functionalities 
  from this list must be completed before this one can start
- Acceptance criteria — specific, testable statements 
  describing how we know this functionality is complete

Order the list by build order — what must be built 
first appears first.

### Out of scope
List what this plan explicitly does not cover.
For each item:
- State what it is
- State why it is out of scope
- Note where it should be addressed if relevant

Derive out of scope items from:
- Things mentioned in audit documents that are 
  not needed to achieve the stated goal
- Functionality the user explicitly excluded in 
  the invocation prompt
- Anything identified during gap analysis that goes 
  beyond the stated goal

### Open questions
List anything unresolved that could affect the plan.
For each question:
- State the question clearly
- Tag who needs to answer it — user, a developer, 
  or external party
- State whether it is blocking (must resolve before 
  starting) or non-blocking (can resolve during build)

Guidance for optional sections:

### Connection requirements (integration projects)
- What data flows between systems and in which direction
- What API endpoints are needed that do not yet exist
- What data format transformations are required
- What authentication or security is needed between systems

### Architecture decisions (greenfield)
- Key structural decisions that need to be made
- Options considered and recommendation for each
- Decisions that affect multiple functionalities

### Migration path (redesign or refactor)
- What currently exists that needs to change
- How to transition without breaking existing functionality
- What can be changed incrementally vs what requires 
  a larger change

### Data model changes
- What changes to the database schema are needed
- Impact on existing data
- Any migration scripts required

### Third-party dependencies
- New external services or APIs required
- What they provide and why they are needed
- Any setup, credentials, or configuration required

### Security considerations
- Reference security observations flagged in the 
  audit documents — do not conduct new security 
  analysis here
- State how each flagged concern will be addressed 
  or explicitly deferred
- Note any security implications of the planned 
  functionality that were not already flagged

## Step 5 — Save and present
Save the document to:
docs/build-plan/[project-name]-build-plan.md
(path relative to the repository root)

If docs/build-plan/ does not exist, create it.
Confirm to the user where the file was saved.

Present the full document in the chat.
Do not summarise — show everything.

Then stop completely and wait for the user to review 
and approve the plan before anything else happens.
If the user requests changes, update the document 
and wait for approval again.

This session ends after the plan is approved.
Execution begins in a separate Build session.
Do not begin any implementation work in this session
under any circumstances.