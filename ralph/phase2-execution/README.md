# Phase 2: Core Execution Loop

From the infographic: **AI Agent CLI** (center) → **Priority-based task selection** → **Context reset** (fresh start after each task) → **Infinite bash loop** (e.g. ralph.sh invokes agent until backlog complete).

## In this repo

- **Task selection** = read **`docs/ralph/backlog.json`**, pick first feature with `passes === false` and dependencies satisfied. See **`PROCESS.md`** step 2.
- **Context reset** = start each task with a clean slate (no carry-over from previous task). **Policy:** **`context-reset/CONTEXT-RESET.md`** – what to wipe, when, and how (human chat, agent, or ralph.sh).
- **Loop script** = **`ralph.sh`** in this folder (stub). Intended: &lt;100 lines, invoke agent CLI repeatedly until backlog complete.

## Subfolders (scaffold)

- **`task-selection/`** – How we choose the next task (backlog order, priority rules).
- **`context-reset/`** – When and how to wipe context between tasks.
