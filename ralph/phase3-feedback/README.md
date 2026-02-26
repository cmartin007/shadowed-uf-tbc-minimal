# Phase 3: Feedback Loops & Memory

From the infographic: **Type-check & unit tests** (guardrails) → **Automated git commits** (passed tasks) → **Persistent memory** (e.g. progress.txt: findings, logics, “threeings”).

## In this repo

- **Guardrails** = **`./build/build.sh`** runs luacheck on the build; phase test checklists (**`phaseN/test/checklist.md`**) must pass before a feature is marked done. Add policy or scripts in **`guardrails/`**.
- **Commits** = RULES.md says update CHANGES.md before commit; document when to auto-commit (e.g. after each passed task) in **`commits/`**.
- **Memory** = **`memory/progress.txt`** (or similar) for findings, patterns, quirks so the agent can reuse them. See infographic: “Findings: Pattern X in module Y…”, “Logics: Quirk Z…”.

## Subfolders (scaffold)

- **`guardrails/`** – Lint, type-check, unit tests; what must pass before “done”.
- **`commits/`** – When to commit (e.g. after passed task, what message format).
- **`memory/`** – progress.txt and any persistent notes (findings, logics).
