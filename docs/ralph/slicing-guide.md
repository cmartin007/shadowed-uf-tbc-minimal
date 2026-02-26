# Slicing Guide: Tiny Tasks for the Execution Loop

Ralph Phase 1 says: break features into **tiny slices** so each task has **low token usage** and **high accuracy**. This guide defines how we slice a backlog feature into one agent-sized (or one-session) task.

---

## 1. One task = one of these

- **One checkbox** in a phase plan (`phaseN/plan/tasks.md`).  
  Example: “Add cast bar to TOC and build.sh” is one task.

- **One file, one concern.**  
  Example: “In `modules/health.lua`, make `UpdateAura` use `UnitDebuff` when `C_UnitAuras` is nil” – one file, one behaviour change.

- **One doc update.**  
  Example: “Add UNIT_SPELLCAST_* to docs/API_REFERENCE.md” – one file, one section.

- **One verification step.**  
  Example: “Run `./build/build.sh` and fix any missing-module or lint errors” – no new code, single outcome.

---

## 2. Slice size rules

- **Max scope per task:** one main file (or one section of a long file). If a feature touches 3 files, make 3 tasks (or 2 if one change is trivial).
- **Clear acceptance:** the task is done when:
  - the one checkbox is checked, or
  - the one behaviour works (e.g. “cast bar appears when casting”) or
  - the one doc section is updated, or
  - the one command passes (build/lint).
- **Dependencies respected:** don’t slice “Phase 2 review” before “Phase 2 test checklist” is done; order follows `backlog.json` dependencies.

---

## 3. How to slice a backlog feature

1. **Open** the feature in `backlog.json` (e.g. `phase2-integration-retail-api`).
2. **Find** the matching block in the phase plan (e.g. `phase2/plan/tasks.md` §2.4).
3. **Pick one** of:
   - A single checkbox in that block, or
   - A single file + single change described in the scope, or
   - A single step from the “Success criteria” or test checklist.
4. **Write the task** in one sentence, e.g.  
   “In ShadowedUnitFrames.lua, add a TBC fallback for ShadowUF.UnitAuraBySpell using UnitAura loop when C_UnitAuras is nil.”
5. **Run** that task (edit, build, test). When it’s verified, update the phase plan and, when the whole feature is done, set `passes: true` for that feature in `backlog.json`.

---

## 4. Examples

| Backlog feature              | One slice (one task) |
|-----------------------------|----------------------|
| phase2-integration-retail-api | “Add TBC fallback in ShadowUF.UnitAuraBySpell (UnitAura by index when C_UnitAuras nil)” – one function, one file. |
| phase2-test-checklist       | “Run checklist items 1–5 (load, cast player/target), record results in checklist” – one verification pass. |
| phase2-docs                 | “Add cast bar events and UnitCastingInfo/UnitChannelInfo to docs/API_REFERENCE.md” – one file, one section. |
| phase3-fader                | “Add modules/fader.lua with OnEnable/OnDisable and combat alpha 0.8” – one file, one behaviour. |

---

## 5. What *not* to do

- **Don’t** pack “fix UnitAuraBySpell + run full Phase 2 checklist + update all docs” into one task.
- **Don’t** start a slice that depends on another slice in the same run (e.g. “add fader and then run Phase 3 tests” – do “add fader” first, then in a later run “run Phase 3 tests”).
- **Don’t** leave acceptance vague (“improve auras”) – use “auras show on target when UNIT_AURA fires” or “checklist items 6–8 passed”.

---

## 6. Reference

- Backlog: **`docs/ralph/backlog.json`**
- Phase plans: **`phaseN/plan/tasks.md`**
- Ralph Phase 1 overview: **`docs/ralph/README.md`**
