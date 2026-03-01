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
- Core files retained: units, layout, health, power, defaultlayout, helpers, basecombopoints, tags, **cast**, auras
- Addon runs in WoW without errors; player, pet, and target unit frames display correctly (see phase1/review/phase1-unit-frames-proof.png)
- **Phase 2 auras:** Auras module with buff/debuff icons (TBC UnitBuff/UnitDebuff), positioning from defaultlayout (anchorPoint, x, y), debuff-type borders, OmniCC-compatible Cooldown frame; unit frame borders disabled (backdrop edgeSize 0); target/targettarget positions swapped (ToT top, target below). **Mouseover tooltips** via `GameTooltip:SetUnitAura` (rank-correct). **Alignment:** Target auras use `anchorTo = "$healthBar"` so icons start on the same x axis as the health bar. **Self-cast enlargement:** Player's own debuffs on target render at 1.30× scale (Button frames + SetScale), bottom-aligned with smaller debuffs from other casters. **Player buff whitelist:** Player buffs enabled with a hardcoded whitelist (`playerBuffWhitelist` table in `defaultlayout.lua`); supports spell IDs (preferred) and names; icons anchored above the player health bar.
- **Phase 2 cast bar:** Cast bar for player and target (UnitCastingInfo/UnitChannelInfo); name and time text; castColors; **detached** 80px below player and target frames; **smooth animation** via shared UIParent updater frame; **spark** at fill edge; **2px dark yellow border**; no background (transparent unfilled). **Blizzard cast bar:** Default `hidden.cast = true` hides Blizzard player/pet cast bar only; SUF cast bars are independent and always show when casting. Health dispel color uses UnitDebuff when C_UnitAuras/AuraUtil absent.
- **Combo points:** Player combo points handled by `modules/basecombopoints.lua` as a dedicated widget; detached row of small round red dots anchored just above the player health bar, shown only when the player has combo points (rogue/cat).

## Next Action
Test Phase 2 in WoW: cast bar (player/target), health dispel color, auras. Run `phase2/test/checklist.md` then complete `phase2/review/decision.md`.

**Ralph Phase 1 (input & backlog):** For structured feature status and “what’s next,” see **`docs/ralph/README.md`** and **`docs/ralph/backlog.json`**. Slice work using **`docs/ralph/slicing-guide.md`** (one task = one checkbox or one file/one concern). For a **short process overview** (all steps in one place), see **`PROCESS.md`** at repo root.

---

## Changelog

### 2026-02-26 (player buff whitelist + bug fixes)
- **player-buff-whitelist:** Enabled player buffs on the player frame filtered by a named whitelist table (`playerBuffWhitelist`) in `defaultlayout.lua`. Whitelist uses spell IDs (numeric keys, preferred) and/or names; Clearcasting (16870), Tiger's Fury, Barkskin, Nature's Swiftness currently defined. `scanAuras` returns `spellId`; `updateAuraList` checks `whitelist[spellId]` then `whitelist[name]`. Scan index decoupled from button slot so filtering doesn't break icon positioning. `whitelist = {}` added to AceDB defaults so `verifyTable` does not strip the table.
- **buildContainer scope fix:** `buildContainer` was defined after `updateAuraList` in `auras.lua` — Lua resolved it as a nil global and silently dropped the call; moved definition before `updateAuraList`.
- **Lazy container creation:** `updateAuraList` now calls `buildContainer` on demand if the container for a kind is nil; fixes cases where buffs were enabled in the config after `OnEnable` already ran (container would never be created otherwise).
- **Simplify pass (auras.lua):** Removed dead `button.isSelfScaled` and `button.duration` fields; inlined `categorizeAura` into `updateAuraList`; removed redundant `enabled = true` from `getConfig` return; extracted `buildContainer` as a named local.

### 2026-02-26 (self-cast debuff enlargement)
- **self-cast-debuff-enlarge:** Rewrote `modules/auras.lua` to enlarge self-cast debuffs on target (1.30× scale via SetScale on Button frames). Caster detection via `playerUnits[sourceUnit]`; bottom-aligned positioning (BOTTOMLEFT/BOTTOMRIGHT) so mixed-scale icons share a baseline. Debuff-type-colored borders preserved. Added to backlog (passes: true), ESSENTIAL_FEATURES.md, and phase2 CHANGES.md.

### 2026-02-26 (Ralph Phase 1 – input & requirement gathering)
- **docs/ralph/:** Added Ralph Phase 1 setup for structured input and backlog: **README.md** (how we use Phase 1, workflow), **backlog.json** (feature list with passes, scope, dependencies), **slicing-guide.md** (how to slice into agent-sized tasks).
- **PROGRESS.md:** Linked to docs/ralph for “what’s next” and slicing.
- **PROCESS.md:** New root-level doc with a simple high-level process (5 steps + quick links) so the full loop is visible in one place.
- **ralph/:** Scaffold folder structure for all three infographic phases: **phase1-input/** (gathering, backlog, slicing), **phase2-execution/** (task-selection, context-reset, ralph.sh stub), **phase3-feedback/** (guardrails, commits, memory/progress.txt). Each subfolder has a README; **ralph/README.md** maps phases to folders and includes folder tree.

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
