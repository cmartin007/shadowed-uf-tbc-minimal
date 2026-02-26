#!/usr/bin/env bash
# Ralph loop – invoke agent CLI repeatedly until backlog complete.
# Target: <100 lines. See docs/agent-looping-flow.png (Phase 2: Core Execution Loop).
#
# Usage (example):
#   ./ralph.sh
#   BACKLOG=docs/ralph/backlog.json ./ralph.sh
#
# Expected behavior:
#   1. Read backlog, select next task (passes=false, deps satisfied).
#   2. Invoke agent CLI with that task (slice from docs/ralph/slicing-guide.md).
#   3. On success: mark task/feature complete, commit if phase3-feedback policy says so.
#   4. Context reset; repeat until no next task or user stop.

set -e
REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
BACKLOG="${BACKLOG:-$REPO_DIR/docs/ralph/backlog.json}"

echo "Ralph loop stub: backlog=$BACKLOG"
echo "Implement: 1) parse backlog, 2) select next feature, 3) invoke agent, 4) update backlog on success, 5) loop."
exit 0
