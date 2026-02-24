# SUF TBC Minimal - Development Progress

## Project Overview
**Goal:** Create lightweight, fast unit frames for **WoW Classic Anniversary TBC ONLY** (no retail, no other Classic).
**Repo:** https://github.com/cmartin007/shadowed-uf-tbc-minimal

---

## Progress by Phase

### Phase 1: Core MVP - Player + Target Frames
**Status:** COMPLETE

- [x] Strip options/ (240KB)
- [x] Strip media/ (600KB)
- [x] Strip localization (except enUS)
- [x] Remove 30+ unused modules
- [x] Add Config.lua (hardcoded positions)
- [x] Update TOC for minimal build
- [x] Add API docs
- [x] Test addon loads in WoW (no Lua errors; player/pet/target frames work)
- [x] Layout and positions in defaultlayout.lua (units.lua kept full; visibility via layout)
- [x] Proof: in-game screenshot in `phase1/review/phase1-unit-frames-proof.png`

### Phase 2: Cast Bar + Auras
**Status:** IN PROGRESS

- [ ] Add cast bar module (`modules/cast.lua`; TBC `UnitCastingInfo`/`UnitChannelInfo`)
- [ ] Fix health dispel color to use TBC APIs (`UnitDebuff` in `health.lua`)
- [x] Add auras module (`modules/auras.lua`; `UpdateFilter` no-op; icon display with UnitBuff/UnitDebuff)
- [x] Auras: ResolveAnchorPoints in defaultlayout (BL→BOTTOMLEFT etc.); merge auras when unit skipped; target/targettarget positions swap; unit frame borders off (edgeSize 0); aura icon borders + OmniCC Cooldown support
- [ ] Test in WoW (see `phase2/test/checklist.md`)
- [ ] Review & Approve (`phase2/review/decision.md`)

**Plan:** `phase2/plan/tasks.md`

### Phase 3: Combat Fader (Optional)
**Status:** NOT STARTED

- [ ] Add combat fader
- [ ] Performance test
- [ ] Review & Approve

---

## Current Build Stats

| Metric | Value |
|--------|-------|
| Files | 14 |
| Modules | 8 |
| Size | ~2.4MB |
| TOC Version | 1.0.0 |

---

## Latest Commit
`8cef666` - Add Phase 1 changes log

---

## What's Working
- Core files retained: units, layout, health, power, movers, defaultlayout, helpers, basecombopoints, tags
- Addon runs in WoW without errors; player, pet, and target unit frames display correctly (see phase1/review/phase1-unit-frames-proof.png)
- **Phase 2 auras:** Auras module with buff/debuff icons (TBC UnitBuff/UnitDebuff), positioning from defaultlayout (anchorPoint, x, y), debuff-type borders, OmniCC-compatible Cooldown frame; unit frame borders disabled (backdrop edgeSize 0); target/targettarget positions swapped (ToT top, target below)

## Next Action
Continue Phase 2: cast bar module, health.lua TBC dispel color fix. Run `phase2/test/checklist.md` for auras and cast bar when implemented.

---

## Changelog

### 2026-02-25
- **RULES.md:** Renumbered sections 2–9; added Findings for auras (ResolveAnchorPoints, layout merge for skipped units, OmniCC/Cooldown, aura vs unit frame borders). Last Updated 2026-02-25.
- **Phase 2 auras:** Auras module in place; anchor shorthand→SetPoint fix (ResolveAnchorPoints in defaultlayout); defaultlayout merges auras for skipped units; full target/parent aura config; removed target buff TL override; swapped target/targettarget positions; unit frame borders off (layout + edgeSize 0); aura icon borders restored; OmniCC support (Cooldown frame on icons). PROGRESS and phase2 CHANGES/tasks/checklist updated.

### 2026-02-24
- **Phase 2 planning:** Added `phase2/plan/tasks.md` (cast bar + auras), `phase2/test/checklist.md`, `phase2/review/decision.md`, `phase2/CHANGES.md`, `phase2/build/README.md`. PROGRESS Phase 2 set to PLANNING / IN PROGRESS.
- Phase 1: Stripped 30+ modules, options, media
- Added Config.lua with hardcoded positions
- Added API reference docs
- Added development rules
