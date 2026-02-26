# Task selection – Priority-based next task

**Rule:** Pick the highest-priority feature in **`docs/ralph/backlog.json`** where `passes === false` and every dependency has `passes === true`. Order in the JSON is priority.

Use this folder for: scripts that read the backlog and output the next feature id, or docs on custom priority (e.g. by phase, by label).
