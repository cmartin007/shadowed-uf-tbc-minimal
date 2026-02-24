#!/bin/bash
# Copy the latest build/release into the WoW addon folder.
# Default: Anniversary client on Windows (WSL path).
# Override: WOW_ADDON_DIR=/path/to/AddOns/ShadowedUnitFrames ./copy-to-wow.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$REPO_DIR/build/release"

# Default: WoW Anniversary client (WSL path for C:\Program Files (x86)\...)
WOW_ADDON_DIR="${WOW_ADDON_DIR:-/mnt/c/Program Files (x86)/World of Warcraft/_anniversary_/Interface/AddOns/ShadowedUnitFrames}"

if [ ! -d "$BUILD_DIR" ]; then
    echo "Build not found. Run ./build/build.sh first."
    exit 1
fi

echo "=== Copying SUF TBC Minimal to WoW ==="
echo "From: $BUILD_DIR"
echo "To:   $WOW_ADDON_DIR"
echo ""

mkdir -p "$WOW_ADDON_DIR"
if command -v rsync &> /dev/null; then
    rsync -a --delete "$BUILD_DIR/" "$WOW_ADDON_DIR/"
else
    rm -rf "$WOW_ADDON_DIR"/*
    cp -r "$BUILD_DIR"/* "$WOW_ADDON_DIR/"
fi

echo "Done. Addon updated at: $WOW_ADDON_DIR"
