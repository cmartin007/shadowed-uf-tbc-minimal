# Run one Ralph loop – Checklist

Use this checklist for **one** loop iteration. **Do not skip step 1 or step 2.**

---

## Step 1: Review the backlog (required)

- [ ] Open **`docs/ralph/backlog.json`**.
- [ ] List features and status:
  - Which have **`passes: true`**?
  - Which have **`passes: false`**?
- [ ] For each `passes: false` feature, check: are all of its **dependencies** `passes: true`?
- [ ] Identify the **next** feature: first (in order) with `passes === false` and all dependencies satisfied.
- [ ] Note that feature’s **id**, **scope**, and **notes** (e.g. “TBC APIs only”). Confirm you understand the scope before acting.

**Output to show (so the review is visible):** e.g. “Backlog review: N features pass, M open. Next candidate: `<id>` – `<scope>`.”

---

## Step 2: Backlog grooming (with you – required before step 3)

- [ ] **Groom the backlog with the human** before picking the next task. See **`docs/ralph/GROOMING.md`**.
- [ ] Clarify: Is the backlog still right? Any scope changes, add/remove/split/merge features, dependency or order changes?
- [ ] Agree with the user: “Next task will be `<id>`” (or a different one if you reprioritised). Confirm before proceeding.
- [ ] If anything changed, update **`docs/ralph/backlog.json`**.

**Output:** Agreed **“Next task: `<id>`”** and updated backlog if needed. Only then continue to step 3.

---

## Step 3: Pick next task

- [ ] The next task is the feature agreed in step 2.
- [ ] Open the matching **phase plan** (`phaseN/plan/tasks.md`) and find the checkboxes for this feature.

---

## Step 4: Slice

- [ ] Using **`docs/ralph/slicing-guide.md`**, choose **one** small task: one checkbox, or one file / one concern, or one doc update.
- [ ] Write the slice in one sentence (e.g. “In ShadowedUnitFrames.lua, add TBC fallback for UnitAuraBySpell when C_UnitAuras is nil”).

---

## Step 5: Execute

- [ ] Do the slice: edit, run **`./build/build.sh`**, fix any errors.
- [ ] Update **phase CHANGES.md** and **PROGRESS.md** if required by **RULES.md**.

---

## Step 5b: Simplify (after code works)

Review the files changed in this slice for three things, then apply fixes:

- **Reuse** – duplicated logic, extractable patterns, functions used only once that could be inlined (or vice-versa)
- **Quality** – readability, naming, dead code (set but never read, always-hidden UI, unreachable branches)
- **Efficiency** – unnecessary complexity, redundant operations, over-engineered indirection

Rules:
- Only touch files changed in this slice (don't wander).
- Do not change behaviour — no logic changes, only structure.
- Re-run **`./build/build.sh`** after to confirm lint still passes.
- If there is nothing to simplify, skip this step and note "no simplify needed".

---

## Step 6: Feedback

- [ ] If this slice completes the **feature** (all its tasks + checklist + review): set that feature’s **`passes: true`** in **`docs/ralph/backlog.json`**.
- [ ] Decide whether this feature is now part of the **essential minimal surface** (things that **must not break**):
  - If **yes**: add or update an entry in **`docs/ESSENTIAL_FEATURES.md`** describing the feature, where it lives (file/module), and why it’s essential.
  - If **no**: leave ESSENTIAL_FEATURES unchanged, but note any follow-up questions or potential future promotion in **`docs/CULL_INVESTIGATION.md`** or **`ralph/phase3-feedback/memory/progress.txt`**.
- [ ] Optionally append to **`ralph/phase3-feedback/memory/progress.txt`** (findings, gotchas).

---

*Next loop: start again at **Step 1** (review backlog), then **Step 2** (groom with you).*
