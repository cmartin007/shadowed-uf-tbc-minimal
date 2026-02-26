# Phase 1: Input & Requirement Gathering

From the infographic: **Gathering** (user input) → **Structured backlog** (PRD/event model, JSON) → **Slicing** tasks for small context (low token, high accuracy).

## In this repo

- **Backlog & slicing** are implemented in **`docs/ralph/`**:
  - **`docs/ralph/backlog.json`** – structured feature list (passes, scope, dependencies)
  - **`docs/ralph/README.md`** – workflow and how to use the backlog
  - **`docs/ralph/slicing-guide.md`** – how to break a feature into one agent-sized task

- **User input / requirements** live in **PROGRESS.md**, **RULES.md**, **phaseN/plan/tasks.md**, **docs/ESSENTIAL_FEATURES.md**.

## Subfolders (scaffold)

- **`gathering/`** – Where to capture or document raw requirements (e.g. from user, from event model).
- **`backlog/`** – Pointer to the canonical backlog; optional local notes or exports.
- **`slicing/`** – Slicing rules, examples, or scripts (canonical guide: **docs/ralph/slicing-guide.md**).
