# Ralph Loop – Scaffold

Folder structure for the **three phases** in **`docs/agent-looping-flow.png`** (The Ralph Loop: Mastering Infinite AI Coding Workflows).

| Infographic phase | Folder | Purpose |
|-------------------|--------|---------|
| **Phase 1: Input & Requirement Gathering** | **`phase1-input/`** | User input, structured backlog, slicing tasks for small context |
| **Phase 2: Core Execution Loop** | **`phase2-execution/`** | Task selection, context reset, loop script (e.g. ralph.sh) |
| **Phase 3: Feedback Loops & Memory** | **`phase3-feedback/`** | Guardrails (tests/lint), commits policy, persistent memory (progress.txt) |

**Quick start:** See **`PROCESS.md`** at repo root for where to start each work session.  
**Backlog & slicing:** Implemented in **`docs/ralph/`** (backlog.json, slicing-guide.md).  
**Run one loop:** Use **`ralph/RUN-ONE-LOOP.md`** – checklist that starts with **review the backlog** (step 1), then pick, slice, execute, feedback.

## Folder tree

```
ralph/
├── README.md
├── phase1-input/
│   ├── README.md
│   ├── gathering/
│   ├── backlog/
│   └── slicing/
├── phase2-execution/
│   ├── README.md
│   ├── ralph.sh          # Stub: loop until backlog complete
│   ├── task-selection/
│   └── context-reset/
└── phase3-feedback/
    ├── README.md
    ├── guardrails/
    ├── commits/
    └── memory/
        └── progress.txt   # Persistent findings / logics
```
