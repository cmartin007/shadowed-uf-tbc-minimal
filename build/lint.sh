#!/bin/bash
# Lua linting script for SUF TBC Minimal

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LINT_DIR="$REPO_DIR/build/lint"
mkdir -p "$LINT_DIR"

echo "Running Lua linting..."

# Lint main files
echo "Checking ShadowedUnitFrames.lua..."
luacheck "$REPO_DIR/ShadowedUnitFrames.lua" --codes --no-color 2>&1 | tee "$LINT_DIR/shadowed.log" || true

# Lint modules
echo "Checking modules..."
for f in "$REPO_DIR"/modules/*.lua; do
    if [ -f "$f" ]; then
        fname=$(basename "$f")
        echo "  Checking $fname..."
        luacheck "$f" --codes --no-color 2>&1 | tee -a "$LINT_DIR/modules.log" || true
    fi
done

# Lint Config.lua
echo "Checking Config.lua..."
luacheck "$REPO_DIR/Config.lua" --codes --no-color 2>&1 | tee -a "$LINT_DIR/config.log" || true

# Summary
echo ""
echo "=== Lint Summary ==="
echo "Logs saved to: $LINT_DIR/"

WARN_COUNT=$(grep -c "warning" "$LINT_DIR"/*.log 2>/dev/null || echo "0")
echo "Total warnings: $WARN_COUNT"

if [ "$WARN_COUNT" -gt 0 ]; then
    echo ""
    echo "Warnings found - review logs above"
    exit 1
else
    echo "All clean!"
    exit 0
fi
