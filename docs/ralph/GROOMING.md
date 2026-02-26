# Backlog Grooming

**When:** After **reviewing** the backlog (step 1) and **before** picking the next task (step 2). Do grooming **with** the human so the backlog reflects current intent.

**Why:** Review shows *what the backlog says*; grooming decides *what we want to do next* and whether the backlog is still right. Prevents acting on stale or wrong scope.

---

## What grooming is

- **Clarify scope** – Is the scope for the next candidate still correct? Any missing or extra bits?
- **Adjust items** – Add a new feature, remove one, split a big one into smaller backlog entries, or merge two.
- **Dependencies** – Change dependencies if the order should be different.
- **Priority** – Reorder features (order in `backlog.json` = priority) or agree to work on a different “next” than the first eligible.
- **Agree on “next”** – After grooming, confirm with the human: “Next task will be `<id>` – `<scope>`. Proceed?” Only then go to slice and execute.

---

## How to run it

1. **Input:** The result of step 1 (review): list of features, pass/fail, next candidate.
2. **With the user**, go through:
   - “Is the backlog still right? Any changes to scope, order, or dependencies?”
   - “Do you want to work on the next candidate as-is, or pick something else / add something first?”
3. **Apply changes** to **`docs/ralph/backlog.json`** if anything changed (add/remove/edit features, reorder, fix deps).
4. **Confirm:** “Next task: `<id>`. Proceed to slice?” Then continue to step 2 (pick) → slice → execute.

---

## Output

- Updated **`docs/ralph/backlog.json`** if grooming changed anything.
- Explicit **“Next task: `<id>`”** agreed with the user before moving to slice.
