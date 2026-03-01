# Development Process (High Level)

Short overview of how we work. Details live in the linked docs.

---

## Where to start

**Each time you sit down to work:** start at **step 1** — **review the backlog** (read and show its state). Then **step 2** — **backlog grooming with you** (clarify scope, adjust order/deps, agree on next). Only then pick the next task (step 3), slice (step 4), and execute (step 5). Do **not** skip review or grooming: the loop is *input → review → **groom** → pick → slice → execute → **simplify** → feedback*.

**Step 1 in practice:** Open **`docs/ralph/backlog.json`**, list which features have `passes: true` vs `passes: false`, and identify the **next** feature (first `passes: false` with all dependencies satisfied).  
**Step 2 in practice:** Groom the backlog with the human: confirm or change scope, order, dependencies; agree on which feature is “next”; then proceed to slice and execute.

---

## Process Steps

1. **Review the backlog**  
   Read **`docs/ralph/backlog.json`**. Don’t skip this. List which features pass and which don’t; identify the first feature with `passes === false` whose dependencies all have `passes === true`. That is your candidate. Confirm scope and notes before acting.  
   → See **`docs/ralph/README.md`**

2. **Backlog grooming (with you)**  
   Before picking the next task, **groom the backlog** with the human: clarify scope, add/remove/split/merge features, adjust dependencies or order, and **agree on which feature is "next"**. Update **`docs/ralph/backlog.json`** if anything changed. Do not proceed to pick/slice until grooming is done.  
   → See **`docs/ralph/GROOMING.md`**

3. **Pick next task**  
   The agreed "next" from grooming is the next task. Use the matching **phase plan** (`phaseN/plan/tasks.md`) for concrete checkboxes.  
   → See **`docs/ralph/backlog.json`** and **`phase2/plan/tasks.md`** (or current phase)

4. **Slice**  
   Turn that feature into **one small task**: one checkbox, or one file / one concern, or one doc update. Keeps context small and accuracy high.  
   → See **`docs/ralph/slicing-guide.md`**

5. **Execute**  
   Do the task: edit, run **`./build/build.sh`**, test in WoW. Update the phase **CHANGES.md** and **PROGRESS.md** as per **`RULES.md`**.

5b. **Simplify** (after code works)  
   Review only the files changed in this slice for: reuse opportunities (duplicated logic, inlinable one-liners), quality (dead code, naming, readability), and efficiency (redundant ops, over-engineering). Apply fixes, re-run **`./build/build.sh`**. No behaviour changes — structure only. Skip if nothing to simplify.

6. **Feedback & decisions**  
   Run the phase **test checklist** (`phaseN/test/checklist.md`). When the feature is fully verified, set **`passes: true`** for that feature in **`docs/ralph/backlog.json`**. For each completed feature, make a quick decision: **does this become part of the minimal “must not break” surface?**  
   - If **yes**, add or update an entry in **`docs/ESSENTIAL_FEATURES.md`** explaining where it lives and why it is essential.  
   - If **no**, leave ESSENTIAL_FEATURES unchanged but note any questions in **`docs/CULL_INVESTIGATION.md`** or phase feedback.  
   Complete **phaseN/review/decision.md** when closing a phase.

---

## Quick Links

| Need to…              | Look at… |
|-----------------------|----------|
| See what’s done / next | **PROGRESS.md** |
| See process in detail  | **docs/ralph/README.md** |
| See the full loop (pic)| **docs/agent-looping-flow.png** |
| Ralph loop scaffold     | **ralph/** (phase1-input, phase2-execution, phase3-feedback) |
| Run one loop (checklist)| **ralph/RUN-ONE-LOOP.md** – starts with **review backlog**, then **groom with you** |
| Follow commit/changes  | **RULES.md** |
| Phase goals & tasks    | **PHASE.md**, **phaseN/plan/tasks.md** |

---

*This process follows the “Ralph Loop” from `docs/agent-looping-flow.png`: gather input → backlog → slice → execute → simplify → feedback → repeat.*
