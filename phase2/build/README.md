# Phase 2 Build

Phase 2 adds **modules** to the existing build; it does not change the build system.

- **Build command:** Same as Phase 1: `./build/build.sh` (from repo root).
- **New modules:** Add any new Lua modules (e.g. `cast.lua`, `auras.lua`) to:
  1. **`ShadowedUnitFrames.toc`** – under `# Modules`
  2. **`build/build.sh`** – in the `MODULES` list so they are copied into `build/release/modules/`

After adding a module, run `./build/build.sh` and deploy with `./build/copy-to-wow.sh` if desired.
