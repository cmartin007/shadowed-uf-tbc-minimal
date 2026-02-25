#!/bin/bash
# Build script for SUF TBC Minimal release
# Creates a clean addon folder with only essential files

set -e

# Get repo root (parent of build dir)
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$REPO_DIR/build/release"

echo "=== Building SUF TBC Minimal ==="
echo "Repo: $REPO_DIR"
echo ""

# Check for luacheck or lua-check (Ubuntu package name)
if command -v luacheck &> /dev/null; then
    LUA_LINTER=luacheck
    LINT=true
elif command -v lua-check &> /dev/null; then
    LUA_LINTER=lua-check
    LINT=true
else
    echo "Warning: luacheck/lua-check not installed. Skipping lint."
    echo "Install: brew install luacheck  OR  sudo apt-get install -y lua-check"
    LINT=false
fi

# Clean build dir first
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Files to include (from repo)
echo "Copying core files..."
cp "$REPO_DIR/ShadowedUnitFrames.toc" "$BUILD_DIR/"
cp "$REPO_DIR/ShadowedUnitFrames.lua" "$BUILD_DIR/"
cp "$REPO_DIR/ShadowedUnitFrames.xml" "$BUILD_DIR/"

# Localization
echo "Copying localization..."
mkdir -p "$BUILD_DIR/localization"
cp "$REPO_DIR/localization/enUS.lua" "$BUILD_DIR/localization/"

# Libraries - copy from repo
echo "Copying libraries..."
mkdir -p "$BUILD_DIR/libs"

# Copy from repo libs folder
if [ -d "$REPO_DIR/libs" ]; then
    cp -r "$REPO_DIR/libs/"* "$BUILD_DIR/libs/" 2>/dev/null || true
fi

# Modules (from repo)
echo "Copying modules..."
mkdir -p "$BUILD_DIR/modules"

MODULES=(
    "helpers"
    "units"
    "layout"
    "defaultlayout"
    "health"
    "power"
    "basecombopoints"
    "cast"
    "auras"
    "tags")

for mod in "${MODULES[@]}"; do
    if [ -f "$REPO_DIR/modules/$mod.lua" ]; then
        cp "$REPO_DIR/modules/$mod.lua" "$BUILD_DIR/modules/"
    fi
done

# Run linting on build output
if [ "$LINT" = true ]; then
    echo ""
    echo "=== Running Lua Lint on Build ==="
    LINT_FAILED=0
    
    # Lint all lua files
    for f in $(find "$BUILD_DIR" -name "*.lua"); do
        OUTPUT=$("$LUA_LINTER" "$f" --no-color 2>&1) || true
        # Fail only on errors (ignore warnings; WoW addon has many benign warnings)
        if echo "$OUTPUT" | grep -qP "^\s*[1-9]\d* error"; then
            echo "LINT ERROR in: $f"
            echo "$OUTPUT" | head -3
            LINT_FAILED=1
        fi
    done
    
    if [ "$LINT_FAILED" -eq 1 ]; then
        echo ""
        echo "=== Lint: FAILED (errors found) - Fix before releasing! ==="
        exit 1
    else
        echo "=== Lint: OK (no errors) ==="
    fi
    echo ""
fi

# Count files
FILE_COUNT=$(find "$BUILD_DIR" -type f | wc -l)
SIZE=$(du -sh "$BUILD_DIR" | cut -f1)

echo ""
echo "=== Build Complete ==="
echo "Files: $FILE_COUNT"
echo "Size: $SIZE"
echo "Location: $BUILD_DIR"
echo ""
if [ -x "$REPO_DIR/build/copy-to-wow.sh" ]; then
    echo "=== Copying to WoW addon folder ==="
    "$REPO_DIR/build/copy-to-wow.sh"
else
    echo "Skipping copy (run ./build/copy-to-wow.sh manually if needed)"
fi
