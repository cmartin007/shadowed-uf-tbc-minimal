# Phase 2: Cast Bar + Auras

## Goal
Add a cast bar (player and target) and a simplified aura display using **TBC-only APIs** (no `C_UnitAuras`, no `AuraUtil`). Fix any existing retail API use in health/layout that touches auras or cast.

## Prerequisites
- Phase 1 complete (player/target/pet frames working; layout from `defaultlayout.lua`).
- **TBC APIs only:** `UnitCastingInfo`, `UnitChannelInfo`, `UNIT_SPELLCAST_*` / `UNIT_SPELLCAST_CHANNEL_*` for cast; `UnitAura` / `UnitBuff` / `UnitDebuff` for auras (see `docs/API_REFERENCE.md` and RULES.md §7).

## Tasks

### 2.1 Cast Bar Module
- [ ] Add **`modules/cast.lua`** (or `castbar.lua`).
  - Register with `ShadowUF:RegisterModule(Cast, "castBar", L["Cast bar"], true)` so layout treats it as a bar (`moduleHasBar = true`).
  - **OnEnable:** Create `frame.castBar` via `ShadowUF.Units:CreateBar(frame)`; create optional icon and name/time font strings per `db.profile.units[unitType].castBar` (defaultlayout already defines castBar with name/time).
  - **Events:** Register for `UNIT_SPELLCAST_START`, `UNIT_SPELLCAST_STOP`, `UNIT_SPELLCAST_FAIL`, `UNIT_SPELLCAST_INTERRUPTED`, `UNIT_SPELLCAST_DELAYED`, `UNIT_SPELLCAST_CHANNEL_START`, `UNIT_SPELLCAST_CHANNEL_STOP`, `UNIT_SPELLCAST_CHANNEL_UPDATE` (or equivalent TBC event names; verify in client).
  - **Update:** Use `UnitCastingInfo(unit)` and `UnitChannelInfo(unit)` to drive bar value, max, and text. Cast = 0→1 over time; channel = 1→0. Set bar color from `db.profile.castColors` (cast vs channel vs interruptible).
  - **Visibility:** Show bar only when casting/channeling; hide when not. `hidden.cast` controls only Blizzard cast bar hiding (in core); SUF cast bar is always shown when casting.
- [ ] Add **cast bar to TOC** and to **`build/build.sh`** module list so it is copied into `build/release`.
- [ ] Ensure **defaultlayout.lua** keeps castBar config for player/target (already present); enable castBar for units where it should show (e.g. player, target, focus if desired).

### 2.2 Fix Health Bar Dispel Color (TBC APIs)
- [ ] In **`modules/health.lua`**, `Health:UpdateAura` currently uses `C_UnitAuras.GetDebuffDataByIndex` and `AuraUtil.UnpackAuraData` (retail-only). Replace with **TBC API:**
  - Iterate with `UnitDebuff(unit, index, "HARMFUL")` (or equivalent filter); get `name, icon, count, dispelType, duration, expirationTime, source, ...`. Use `dispelType` (or equivalent) to check if player can cure (Magic, Curse, Poison, Disease). Set `frame.healthBar.hasDebuff` for coloring.
  - If `UnitIsFriend` is not in TBC, use a safe fallback (e.g. only run dispel check for player/party/raid units).
- [ ] Ensure **units.lua** `canCure` / `checkCurableSpells` uses only TBC spell IDs and APIs (e.g. `IsPlayerSpell`); adjust curable spell list for TBC classes if needed.

### 2.3 Auras Module (Simplified)
- [x] Add **`modules/auras.lua`**.
  - **Minimum:** Implement `Auras:UpdateFilter(frame)` so that `units.lua` does not error when it calls `ShadowUF.modules.auras:UpdateFilter(frame)` (e.g. no-op or set a filter from config).
  - **Optional / simplified display:** If layout or existing code expects aura icons on the frame:
    - Create a minimal icon row for buffs and/or debuffs (e.g. on target frame) using **`UnitBuff(unit, index)` / `UnitDebuff(unit, index)`** and texture widgets. Use `Layout:GetAuraGrowth(anchorPoint)` for growth direction; max rows/perRow from `db.profile.units[unitType].auras.buffs` / `debuffs`.
    - Register for `UNIT_AURA` and update icons when the unit’s auras change.
  - **TBC only:** Do not use `C_UnitAuras`, `AuraUtil`, or `AuraUtil.UnpackAuraData`.
  - **Done:** Icons use `ShadowUF.ResolveAnchorPoints(anchorPoint)` for SetPoint; aura borders (debuff type color); OmniCC via Cooldown frame per icon.
- [x] Add **auras to TOC** and **`build/build.sh`** module list.
- [x] **defaultlayout.lua:** ResolveAnchorPoints added; full aura config for target/parent; auras merged for skipped units; target/targettarget positions swapped. Auras enabled for target (and player) with icon display.

### 2.4 Integration and Cleanup
- [ ] **ShadowedUnitFrames.lua:** Defaults include `castBar` and `hidden.cast`. `hidden.cast = true` by default hides Blizzard player/pet cast bar only; SUF cast bar shows whenever unit is casting (cast module does not check `hidden.cast`).
- [ ] Remove or guard any other **retail-only API** use (e.g. `ShadowUF.UnitAuraBySpell` uses `C_UnitAuras`; either make it TBC-safe or restrict to addons that don’t call it in TBC).
- [ ] **Build:** Run `./build/build.sh` and confirm no missing module errors; run in WoW and confirm no Lua errors.

### 2.5 Test and Document
- [ ] In-game: Player cast bar appears when casting; target cast bar when target is casting; bar fills/drains correctly; spell name/time visible if configured.
- [ ] In-game: No Lua errors; health bar dispel color works on dispellable debuffs (if enabled) using TBC APIs.
- [ ] In-game: If aura icons are implemented, they show target (and/or player) buffs/debuffs and update on `UNIT_AURA`.
- [ ] Update **`docs/API_REFERENCE.md`** if new events or API details are used (e.g. exact TBC cast event names).
- [ ] Update **RULES.md** or phase2 docs if new patterns (e.g. cast bar module shape) should be reused.

## Out of Scope for Phase 2
- Full aura filtering (whitelist/blacklist by spell ID).
- Portrait, combat text, or other modules.
- Options UI; all config remains in `defaultlayout.lua` (and existing db defaults).

## Dependencies
- WoW TBC APIs: `UnitCastingInfo`, `UnitChannelInfo`, `UnitAura`/`UnitBuff`/`UnitDebuff`, `UNIT_SPELLCAST_*`, `UNIT_AURA`.
- Existing: `ShadowUF.Units:CreateBar`, `Layout`, `db.profile.castColors`, `db.profile.units[].castBar` / `auras`.
- Layout expects `frame.castBar` when castBar module is enabled and creates bar layout; auras module must at least provide `UpdateFilter`.

## Success Criteria
- Cast bar works for player and target using only TBC APIs.
- No retail API use in cast or aura code paths; health dispel color uses `UnitDebuff`.
- No Lua errors in WoW; addon loads and cast/aura features work as configured.
- Phase 2 review checklist passed and decision APPROVE or NEEDS FIXES documented.
