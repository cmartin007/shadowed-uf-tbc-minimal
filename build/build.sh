#!/bin/bash
# Build script for SUF TBC Minimal release
# Creates a clean addon folder with only essential files

set -e

# Get repo root (parent of build dir)
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$REPO_DIR/build/release"

echo "Building SUF TBC Minimal..."
echo "Repo: $REPO_DIR"
echo "Output: $BUILD_DIR"

# Clean build dir
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Files to include (from TOC)
echo "Copying core files..."
cp "$REPO_DIR/ShadowedUnitFrames.toc" "$BUILD_DIR/"
cp "$REPO_DIR/ShadowedUnitFrames.lua" "$BUILD_DIR/"
cp "$REPO_DIR/ShadowedUnitFrames.xml" "$BUILD_DIR/"
cp "$REPO_DIR/Config.lua" "$BUILD_DIR/"

# Localization
echo "Copying localization..."
mkdir -p "$BUILD_DIR/localization"
cp "$REPO_DIR/localization/enUS.lua" "$BUILD_DIR/localization/"

# Libraries (embedded)
echo "Copying libraries..."
mkdir -p "$BUILD_DIR/libs"

# Copy LibStub
if [ -d "$REPO_DIR/libs/LibStub" ]; then
    cp -r "$REPO_DIR/libs/LibStub" "$BUILD_DIR/libs/"
fi

# Copy CallbackHandler
if [ -d "$REPO_DIR/libs/CallbackHandler-1.0" ]; then
    cp -r "$REPO_DIR/libs/CallbackHandler-1.0" "$BUILD_DIR/libs/"
fi

# Copy LibSharedMedia
if [ -d "$REPO_DIR/libs/LibSharedMedia-3.0" ]; then
    cp -r "$REPO_DIR/libs/LibSharedMedia-3.0" "$BUILD_DIR/libs/"
fi

# Copy LibDualSpec
if [ -d "$REPO_DIR/libs/LibDualSpec-1.0" ]; then
    cp -r "$REPO_DIR/libs/LibDualSpec-1.0" "$BUILD_DIR/libs/"
fi

# Copy LibSpellRange
if [ -d "$REPO_DIR/libs/LibSpellRange-1.0" ]; then
    cp -r "$REPO_DIR/libs/LibSpellRange-1.0" "$BUILD_DIR/libs/"
fi

# Copy UTF8
if [ -d "$REPO_DIR/libs/UTF8" ]; then
    cp -r "$REPO_DIR/libs/UTF8" "$BUILD_DIR/libs/"
fi

# Modules
echo "Copying modules..."
mkdir -p "$BUILD_DIR/modules"

MODULES=(
    "helpers"
    "units"
    "layout"
    "movers"
    "defaultlayout"
    "health"
    "power"
    "basecombopoints"
)

for mod in "${MODULES[@]}"; do
    if [ -f "$REPO_DIR/modules/$mod.lua" ]; then
        cp "$REPO_DIR/modules/$mod.lua" "$BUILD_DIR/modules/"
    else
        echo "Warning: $mod.lua not found"
    fi
done

# Count files
FILE_COUNT=$(find "$BUILD_DIR" -type f | wc -l)
SIZE=$(du -sh "$BUILD_DIR" | cut -f1)

echo ""
echo "=== Build Complete ==="
echo "Files: $FILE_COUNT"
echo "Size: $SIZE"
echo "Location: $BUILD_DIR"
echo ""
echo "To package as zip:"
if command -v zip &> /dev/null; then
    cd "$BUILD_DIR"
    zip -r "../ShadowedUnitFrames-TBC-Minimal.zip" .
    echo "Created: $REPO_DIR/build/ShadowedUnitFrames-TBC-Minimal.zip"
else
    echo "  cd $BUILD_DIR"
    echo "  zip -r ../ShadowedUnitFrames-TBC-Minimal.zip ."
    echo ""
    echo "  (zip not installed)"
fi
