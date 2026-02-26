# Context Reset Policy

From the infographic: **"Context wiped clean after every task to remove 'garbage' decisions."**

This document defines **what** we reset, **when**, and **how** so each task runs with a clean slate.

---

## 1. What "context" means

| Context | Reset? | Notes |
|--------|--------|--------|
| **Agent session / chat** | Yes | Don’t carry over the previous task’s conversation, reasoning, or mistakes. |
| **Prompt content** | Yes | Each run should get only: backlog entry + one slice + relevant file refs. No “we just did X” or prior-task narrative. |
| **Open files / editor state** | Optional | Closing unrelated files or starting from a clean window reduces noise; not required if you can ignore them. |
| **Backlog, progress.txt, repo** | No | These are **persistent**. Backlog and `ralph/phase3-feedback/memory/progress.txt` are the only memory between tasks. |

So: **reset** = no prior-task reasoning or chat; **keep** = backlog, git, progress.txt, and the codebase.

---

## 2. When we reset

- **After every slice (recommended)**  
  One slice = one task = one context. When the task is done (code changed, build passed, or “skip”), reset before picking the next slice.

- **After every feature (alternative)**  
  If you run multiple slices in one session, reset when the **feature** is done (all slices for that backlog entry completed and `passes` set to true).

Rule of thumb: **reset before starting a new task from the backlog.** If in doubt, reset after each slice.

---

## 3. How we reset (by mode)

### A. Human / Cursor chat (manual)

1. **Finish the current task:** apply edits, run `./build/build.sh`, update CHANGES if needed.
2. **Stop:** don’t continue in the same chat with “now do the next task.”
3. **Next session:** open a **new chat**. In the first message, give only:
   - “Pick the next task from `docs/ralph/backlog.json` (first `passes: false` with deps satisfied), slice it using `docs/ralph/slicing-guide.md`, and do that one task.”
4. Optionally close unrelated files so the new chat doesn’t see them by default.

### B. Cursor agent (semi-automated)

1. Treat each **agent run** as one task. When the run finishes (task done or failed), **don’t** resume with “continue with next task” in the same thread.
2. Start a **new agent run** with a prompt that includes:
   - Pointer to `docs/ralph/backlog.json` and “pick next feature (passes false, deps satisfied)”,
   - Pointer to `docs/ralph/slicing-guide.md` and “output exactly one slice”,
   - “Do only that one slice; do not continue to the next task.”
3. If your tooling supports it, avoid attaching the previous run’s transcript to the new run.

### C. Fully automated loop (e.g. ralph.sh + agent CLI)

1. Each **invocation** of the agent CLI = one task. CLI receives only: **feature id** + **slice description** (and paths to relevant files).
2. **No** shared process state between invocations: new process per task.
3. **Input** to each invocation: from backlog + task-selection (next feature) + slicing (one slice). **No** “previous task” or “previous output” in the prompt.
4. **Output**: code/docs changes; optionally append to `ralph/phase3-feedback/memory/progress.txt` for findings. Backlog is updated by the loop script after guardrails pass (phase 3).

---

## 4. What to include in the “fresh” prompt

So that the new context is self-contained, the first message or CLI input for a task should include:

- **Backlog:** path to `docs/ralph/backlog.json` and the **feature id** (and optionally scope) for this task.
- **Slice:** one-sentence description of the task (from slicing-guide: one file, one concern, clear acceptance).
- **References:** links to the phase plan (`phaseN/plan/tasks.md`), RULES.md, and any specific files to edit.
- **Boundary:** “Do only this task. Do not start the next backlog item.”

Optionally: “If you need prior project knowledge, read `ralph/phase3-feedback/memory/progress.txt` and docs/ralph/README.md; do not rely on previous chat or session.”

---

## 5. Summary

| Question | Answer |
|----------|--------|
| What do we wipe? | Agent chat/session and prior-task prompt content. |
| What do we keep? | Backlog, progress.txt, repo, build artifacts. |
| When? | Before starting the next task (ideally after every slice). |
| How (human)? | New chat; prompt = “pick next task, slice, do that one task only.” |
| How (automated)? | New process per task; input = feature id + slice only; no prior output in prompt. |

This gives you **The Context Reset** of Ralph Phase 2: every task starts from backlog + slice + persistent memory only, with no carry-over from the previous task.
