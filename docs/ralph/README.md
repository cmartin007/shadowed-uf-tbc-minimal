# Ralph Phase 1: Input & Requirement Gathering

This folder implements **Ralph Phase 1** (from `docs/agent-looping-flow.png`) for the SUF TBC Minimal project: structured input, a single backlog, and rules for slicing work so an agent or human can pick the next task with minimal context.

**For a simple high-level process (all steps in one place), see `PROCESS.md` at repo root.**

---

## 1. What Phase 1 Does (from the infographic)

- **Gathering:** User/developer provides requirements (features, scope, constraints).
- **Structured backlog:** Requirements are stored in a single format (e.g. JSON) with:
  - **Feature** – name or id
  - **passes** – whether the feature is done and verified (true/false)
  - **scope** – what’s in / out of scope
  - **dependencies** – what must be done first
- **Slicing:** Features are broken into **tiny slices** so each task has low token usage and high accuracy (one file, one concern, clear acceptance).

---

## 2. How This Repo Uses It

| Ralph concept        | In this repo |
|----------------------|--------------|
| **User input**       | PROGRESS.md, RULES.md, phase N plan/tasks, ESSENTIAL_FEATURES.md |
| **Structured backlog** | **`backlog.json`** – single source of feature status for agents |
| **Slicing**          | **`slicing-guide.md`** – how to turn a backlog item into a small task |
| **Source of truth**  | Phase plans (`phaseN/plan/tasks.md`) and PROGRESS.md stay authoritative; backlog is kept in sync for **agent-facing** priority and status |

---

## 3. Files in This Folder

- **`backlog.json`** – Structured list of features. Each entry has:
  - `id` – short identifier
  - `feature` – display name
  - `phase` – "phase1" | "phase2" | "phase3"
  - `passes` – boolean (tests/checklist/review say it’s done)
  - `scope` – one-line scope
  - `dependencies` – list of feature ids or `"phase1"` etc.
  - `notes` – optional (e.g. "TBC APIs only")

- **`slicing-guide.md`** – Rules for breaking a backlog item into **one agent-sized task** (one file or one concern, clear acceptance criteria).

- **`GROOMING.md`** – Backlog grooming: do it **with the human** after review and before pick; clarify scope, adjust order/deps, agree on “next”.

- **`README.md`** – This file.

---

## 4. Workflow

### Human or agent picking the next task

1. **Review** `backlog.json`: read it, list features (pass / not pass), and identify the first feature where `passes === false` and all `dependencies` have `passes === true`. Do not skip this review step.
2. **Groom** the backlog with the human: clarify scope, adjust order/dependencies, add or remove features, and **agree on which feature is “next”**. Update `backlog.json` if needed. See **`docs/ralph/GROOMING.md`**. Do not proceed to pick until grooming is done.
3. **Pick** the agreed feature as the next task. Locate the concrete tasks in the right phase plan (e.g. `phase2/plan/tasks.md`).
4. **Slice** using `slicing-guide.md`: choose one checkbox or one file/one concern.
5. **Execute** the task (edit, build, test).
6. **Update** `backlog.json`: set `passes: true` for the feature when its checklist/review is satisfied (and update PROGRESS.md / phase CHANGES.md per RULES.md).

### Keeping the backlog in sync

- When you **complete** a feature (all its tasks + test checklist + review), set that feature’s `passes` to `true` in `backlog.json`.
- When you **add** a new feature or phase, add an entry to `backlog.json` with `passes: false` and the right `dependencies`.
- Optionally run a quick diff: every feature in `backlog.json` should correspond to a goal or task block in some `phaseN/plan/tasks.md` or PROGRESS.md.

---

## 5. Why This Helps

- **Single place to look** – Agent or human asks “what’s next?” and reads `backlog.json` + one phase plan.
- **Clear “done”** – `passes` means “verified” (tests/checklist/review), not “code written.”
- **Small context** – Slicing keeps each run to one file or one concern, so prompts stay small and accurate.
- **Fits existing process** – Phase plans, PROGRESS.md, and RULES.md stay the source of truth; the backlog is the **input** for the execution loop (Ralph Phase 2).

---

## 6. Reference

- Infographic: **`docs/agent-looping-flow.png`**
- Project progress: **`PROGRESS.md`**
- Phase plans: **`phase1/plan/tasks.md`**, **`phase2/plan/tasks.md`**, **`phase3/plan/tasks.md`**
- Rules: **`RULES.md`**
