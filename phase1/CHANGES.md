# Phase 1 Changes Log

## Changes Made

### 2026-02-24: Initial Strip
- Created new repo from Nevcairiel/ShadowedUnitFrames
- Added iterative folder structure (plan/build/test/review)

### 2026-02-24: File Stripping

**Removed directories:**
- `options/` - Full config UI (240KB)
- `media/` - Custom textures/fonts (~600KB)

**Removed localization files:**
- `localization/deDE.lua`
- `localization/esES.lua`
- `localization/esMX.lua`
- `localization/frFR.lua`
- `localization/koKR.lua`
- `localization/ptBR.lua`
- `localization/ruRU.lua`
- `localization/zhCN.lua`
- `localization/zhTW.lua`

**Removed modules (30+ files):**
- `modules/altpower.lua`
- `modules/arcanecharges.lua`
- `modules/auraindicators.lua`
- `modules/aurapoints.lua`
- `modules/auras.lua`
- `modules/cast.lua`
- `modules/chi.lua`
- `modules/combattext.lua`
- `modules/combopoints.lua`
- `modules/druid.lua`
- `modules/empty.lua`
- `modules/essence.lua`
- `modules/fader.lua`
- `modules/healabsorb.lua`
- `modules/highlight.lua`
- `modules/holypower.lua`
- `modules/incabsorb.lua`
- `modules/incheal.lua`
- `modules/indicators.lua`
- `modules/monkstagger.lua`
- `modules/portrait.lua`
- `modules/priest.lua`
- `modules/range.lua`
- `modules/runes.lua`
- `modules/shaman.lua`
- `modules/soulshards.lua`
- `modules/tags.lua`
- `modules/totems.lua`
- `modules/xp.lua`

**Removed other files:**
- `locale-import.lua` (not needed)

### 2026-02-24: Added Files

**New files:**
- `Config.lua` - Hardcoded configuration
  - Player frame position: Bottom center, y+200
  - Target frame position: Right of player, x+220
  - Health color: Green (0.2, 0.8, 0.2)
  - Disabled: focus, pet, party, raid, arena, boss, fader

**Documentation:**
- `PHASE.md` - Project phases overview
- `docs/API_REFERENCE.md` - WoW Classic Anniversary TBC API reference
- `docs/DEVELOPMENT.md` - Development notes

### 2026-02-24: Modified Files

**ShadowedUnitFrames.toc:**
- Removed all optional dependencies
- Removed 30+ module references
- Removed localization references (except enUS)
- Updated version to 1.0.0
- Changed title to "Shadowed Unit Frames TBC Minimal"

### Current State

**Remaining files:** 14
**Remaining modules:** 8
- `modules/units.lua` (57KB)
- `modules/layout.lua` (24KB)
- `modules/defaultlayout.lua` (32KB)
- `modules/health.lua` (7.5KB)
- `modules/power.lua` (3.5KB)
- `modules/movers.lua` (20KB)
- `modules/helpers.lua` (874B)
- `modules/basecombopoints.lua` (6.4KB)

## To Do

- [ ] Test addon loads in WoW
- [ ] Simplify units.lua (remove party/raid references)
- [ ] Simplify main core if needed

## Size Reduction

| Original | Current | Saved |
|----------|---------|-------|
| ~50 files | 14 files | ~36 files |
| ~3.3MB | ~2.4MB | ~900KB |
