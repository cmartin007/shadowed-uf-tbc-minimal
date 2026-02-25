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

- [x] Add cast bar module (`modules/cast.lua`; TBC `UnitCastingInfo`/`UnitChannelInfo`)
- [x] Fix health dispel color to use TBC APIs (`UnitDebuff` fallback in `health.lua`)
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
| Files | 15 |
| Modules | 9 |
| Size | ~2.4MB |
| TOC Version | 1.0.0 |

---

## Latest Commit
`8cef666` - Add Phase 1 changes log

---

## What's Working
- Core files retained: units, layout, health, power, movers, defaultlayout, helpers, basecombopoints, tags, **cast**, auras
- Addon runs in WoW without errors; player, pet, and target unit frames display correctly (see phase1/review/phase1-unit-frames-proof.png)
- **Phase 2 auras:** Auras module with buff/debuff icons (TBC UnitBuff/UnitDebuff), positioning from defaultlayout (anchorPoint, x, y), debuff-type borders, OmniCC-compatible Cooldown frame; unit frame borders disabled (backdrop edgeSize 0); target/targettarget positions swapped (ToT top, target below). **Mouseover tooltips** via `GameTooltip:SetUnitAura` (rank-correct). **Alignment:** Target auras use `anchorTo = "$healthBar"` so icons start on the same x axis as the health bar.
- **Phase 2 cast bar:** Cast bar for player and target (UnitCastingInfo/UnitChannelInfo); name and time text; castColors; **detached** 80px below player and target frames; **smooth animation** via shared UIParent updater frame; **spark** at fill edge; **2px dark yellow border**; no background (transparent unfilled). **Blizzard cast bar:** Default `hidden.cast = true` hides Blizzard player/pet cast bar only; SUF cast bars are independent and always show when casting. Health dispel color uses UnitDebuff when C_UnitAuras/AuraUtil absent.

## Next Action
Test Phase 2 in WoW: cast bar (player/target), health dispel color, auras. Run `phase2/test/checklist.md` then complete `phase2/review/decision.md`.

---

## Changelog

### 2026-02-25 (phase2 docs and features)
- **phase2/CHANGES.md:** Documented cast bar (detached player/target 80px, per-frame updater, spark, 2px dark yellow border, no background); SUF cast bar no longer gated by `hidden.cast`; Blizzard cast bar hide option (`hidden.cast = true` default, `_G` frame refs); auras tooltips (`SetUnitAura`) and `anchorTo = "$healthBar"` for target alignment.
- **PROGRESS.md:** Updated "What's Working" for auras tooltips/alignment and cast bar (detached, animation, spark, border, Blizzard hide option).
- **Cast bar:** Detached player and target bars 80px below frame; shared updater frame for smooth fill; spark at leading edge; 2px dark yellow border; no background texture. `hidden.cast` only hides Blizzard cast bar; SUF cast bars always show when casting.
- **Auras:** Mouseover tooltips via `GameTooltip:SetUnitAura`; target auras anchored to `$healthBar` for left-edge alignment.
- **Blizzard cast bar:** Default `config.hidden.cast = true`; profile default `hidden.cast = true`; core uses `_G.PlayerCastingBarFrame` / `_G.PetCastingBarFrame`.

### 2026-02-25
- **RULES.md:** Renumbered sections 2–9; added Findings for auras (ResolveAnchorPoints, layout merge for skipped units, OmniCC/Cooldown, aura vs unit frame borders). Last Updated 2026-02-25.
- **Phase 2 auras:** Auras module in place; anchor shorthand→SetPoint fix (ResolveAnchorPoints in defaultlayout); defaultlayout merges auras for skipped units; full target/parent aura config; removed target buff TL override; swapped target/targettarget positions; unit frame borders off (layout + edgeSize 0); aura icon borders restored; OmniCC support (Cooldown frame on icons). PROGRESS and phase2 CHANGES/tasks/checklist updated.
- **Phase 2 cast bar + health:** Added `modules/cast.lua` (UnitCastingInfo/UnitChannelInfo, name/time text, castColors, hidden.cast). Enabled castBar for player and target in defaultlayout. Health.lua UpdateAura uses UnitDebuff when C_UnitAuras/AuraUtil missing. TOC and build.sh updated. phase2 CHANGES and PROGRESS updated.

### 2026-02-24
- **Phase 2 planning:** Added `phase2/plan/tasks.md` (cast bar + auras), `phase2/test/checklist.md`, `phase2/review/decision.md`, `phase2/CHANGES.md`, `phase2/build/README.md`. PROGRESS Phase 2 set to PLANNING / IN PROGRESS.
- Phase 1: Stripped 30+ modules, options, media
- Added Config.lua with hardcoded positions
- Added API reference docs
- Added development rules
