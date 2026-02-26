# Codebase Cleanup Plan

**Purpose:** Single reference for cleanup work. Lists areas, groups by module/theme, and notes impact. **No code changes in this doc**—use it to slice work and track decisions.

**Before any change:** Check **docs/ESSENTIAL_FEATURES.md** so required features are not removed.

---

## 1. Cleanup areas (summary)

| Area | Description | Priority |
|------|-------------|----------|
| **Lint (luacheck)** | Unused vars, shadowing, long lines, read_globals. See docs/plan-luacheck-warnings.md. | Medium – improves consistency; low risk. |
| **Retail-only paths** | C_UnitAuras, AuraUtil, GetSpecializationInfoByID guarded or fallback only; ensure no TBC break. | High – correctness on TBC. |
| **Dead / optional code** | Slash + Options load, ShowInfoPanel, LibDualSpec, unused profile keys, unused hidden.* branches. | Medium – see CULL_INVESTIGATION.md. |
| **Duplication** | Same logic in source vs build/release; keep single source (modules/, core), build copies. | Low – process only. |
| **Comments / docs** | Stale comments, RULES/PROGRESS references to culled features. | Low. |

---

## 2. By module / file

### ShadowedUnitFrames.lua
- **Lint:** Long lines (unitList, fakeUnits, L.units); unused `loaded` from LoadAddOn. See plan-luacheck-warnings.md §7.
- **Cull candidates:** Slash + LoadAddOn(ShadowedUF_Options), ShowInfoPanel/infoMessages, LibDualSpec block, profile keys (advanced, bossmodSpellRename, etc.) if unused. See CULL_INVESTIGATION.md §1–4, §9.

### modules/units.lua
- **Lint:** Long line, unused zoneUnits, “loop at most once”, GetSpecializationInfoByID read_globals. See plan-luacheck-warnings.md §6.
- **Retail:** GetArenaOpponentSpec/GetSpecializationInfoByID already guarded; ensure .luacheckrc has read_globals so lint is clean.
- **Cull:** Zone/visibility paths for party/raid/arena/boss if minimal build only uses player/pet/target. See CULL_INVESTIGATION.md §6.

### modules/auras.lua
- **Lint:** Unused `filter` – pass to UnitBuff/UnitDebuff or remove. See plan-luacheck-warnings.md §1.
- **Retail:** C_UnitAuras/AuraUtil path is optional (TBC fallback exists); keep as-is for builds that have it.

### modules/health.lua
- **Lint:** Unused initial values for gradient vars and inverseModifier. See plan-luacheck-warnings.md §3.
- **Retail:** C_UnitAuras path optional; UnitDebuff fallback in place.

### modules/tags.lua
- **Lint:** Inner `self` shadowing in UpdateTags – use e.g. `fontStr` parameter. See plan-luacheck-warnings.md §5.

### modules/defaultlayout.lua
- **Lint:** Unused `playerClass`. See plan-luacheck-warnings.md §2.

### modules/movers.lua (if present)
- **Lint:** Unused playerClass, noop; _G assignment – use rawset. See plan-luacheck-warnings.md §4.
- **Cull:** If movers are fully culled, remove or stub file and update TOC/build.

### modules/layout.lua
- **Cull:** Media reload, mediaRequired, RegisterCallback – simplify to “resolve once at load” if we never change media at runtime. See CULL_INVESTIGATION.md §8.

### HideBlizzardFrames
- **Cull:** Keep only hidden.* for frames we actually show (player, pet, target, cast). See CULL_INVESTIGATION.md §5.

---

## 3. Implementation order (suggested)

1. **Low-risk lint fixes** (one slice per file or group): auras filter, defaultlayout _playerClass, tags inner self, ShadowedUnitFrames _loaded; .luacheckrc read_globals for GetSpecializationInfoByID.
2. **health.lua** gradient/inverseModifier (small refactor).
3. **Cull investigation items** one by one: slash/Options, ShowInfoPanel, LibDualSpec, then profile keys, then hidden.* scope, then unit/header scope—each as a separate slice with “check ESSENTIAL_FEATURES + CULL_INVESTIGATION, then implement”.
4. **Optional:** Long-line and “loop at most once” – suppress in .luacheckrc or leave as-is.

---

## 4. References

- **docs/plan-luacheck-warnings.md** – All current luacheck warnings and suggested fixes.
- **docs/CULL_INVESTIGATION.md** – Per-feature cull checklist and decisions.
- **docs/ESSENTIAL_FEATURES.md** – Do not remove or break these.

---

*Created from Ralph backlog item `cleanup-plan`. Refine into concrete slices (e.g. “fix auras.lua filter”) before implementation; use grooming to pick order.*
