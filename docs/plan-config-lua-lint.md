# Plan: Resolve Config.lua Luacheck Warnings (obsolete)

**Config.lua was removed.** Layout and settings are defined in modules/defaultlayout.lua only (see RULES.md §8). This doc is kept for reference.

## Warnings that were addressed (file since removed)
1. **Line 4:** Unused variable `SUF` (from `local _, SUF = ...`).
2. **Line 55:** Setting read-only field `SUFconfig` of global `_G` (luacheck treats `_G` fields as read-only).

## Context
- Config.lua defines `SUFconfig` and assigns it to `_G.SUFconfig`. No other addon code reads `_G.SUFconfig`; layout is driven by **defaultlayout.lua** (see RULES.md §8). The file is kept for possible future use or reference.

## Options

### Option A: Minimal code change (recommended)
- **Unused SUF:** Use `local _ = ...` or `local _, _SUF = ...` so the second return is intentionally unused. Luacheck ignores variables prefixed with `_` in some configs, or we use only the first return.
- **_G.SUFconfig:** Use `rawset(_G, "SUFconfig", SUFconfig)` instead of `_G.SUFconfig = SUFconfig`. This avoids the “setting read-only field” warning (we’re not assigning to a field of `_G` in luacheck’s view) and is a common pattern for registering a global.

### Option B: Luacheck-only
- Add a file-specific override in `.luacheckrc` for `Config.lua` (e.g. `ignore` for the two warning codes, or allow `_G` to have setter fields for this file). No code change; warnings are suppressed only in the linter.

### Option C: Remove Config.lua
- Remove Config.lua from the TOC and delete the file (or move to `docs/` as reference). Eliminates dead code and both warnings. Phase 1 review noted the file is unused at runtime.

## Recommendation
Apply **Option A**: one-line change for `SUF` (use `_`), one-line change for the global (use `rawset`). No behavior change, and both luacheck warnings are resolved in code.
