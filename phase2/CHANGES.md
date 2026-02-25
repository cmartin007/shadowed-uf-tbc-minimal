# Phase 2 Changes Log

## Planning (2026-02-24)
- Created Phase 2 plan: **Cast Bar + Auras**.
- **phase2/plan/tasks.md:** Tasks for cast bar module (TBC UnitCastingInfo/UnitChannelInfo), health dispel color fix (UnitDebuff), minimal auras module (UpdateFilter + optional icon display).
- **phase2/test/checklist.md:** Test checklist for cast bar (player/target), dispel color, auras.
- **phase2/review/decision.md:** Review template for Phase 2 completion.

## Implementation

### 2026-02-25: Auras module and layout

- **modules/auras.lua, build/release/modules/auras.lua**
  - Auras module: buff/debuff icon rows using TBC `UnitBuff`/`UnitDebuff`; `UpdateFilter` no-op for units.lua; positioning from config (anchorPoint, x, y); `ShadowUF.ResolveAnchorPoints()` for SetPoint (no shorthand like "BL").
  - Aura icon borders: `addIconBorder(slot)`, `setIconBorderColor(slot, auraType, kind)` (debuff type color for debuffs).
  - OmniCC support: `Cooldown` frame per icon; `SetCooldown(start, duration)` when aura has duration; built-in duration text hidden when cooldown set.

- **modules/defaultlayout.lua, build/release/modules/defaultlayout.lua**
  - `ShadowUF.ResolveAnchorPoints(anchorPoint)`: converts layout shorthand (BL, TR, etc.) to full WoW point names; uses `Layout:GetRelative()` with fallback map so SetPoint never receives invalid "BL".
  - When LoadDefaultLayout(useMerge) skips a unit (already has dimensions), still merge **auras** from default config so defaultlayout aura edits take effect.
  - Full aura config for target in parentUnit block (buffs/debuffs: perRow, size, anchorPoint, anchorTo, x, y).
  - Target unit block: full auras config (already present). Positions: **targettarget** = right of player (top); **target** = below targettarget.

- **modules/layout.lua, build/release/modules/layout.lua**
  - Unit frame borders: only set backdrop `edgeFile` when edgeSize > 0 and borderTexture ~= "None"; else clear edgeFile and set edgeSize 0.

- **modules/defaultlayout.lua (config.backdrop)**
  - Default `edgeSize` changed from 5 to 0 so new/reset layouts have no unit frame border.

- **Removed:** Hardcoded target/targettarget buff override in auras.lua (was forcing anchorPoint TL, y=30); layout is now sole source of truth for aura position.

### 2026-02-25: Cast bar module and health dispel TBC fallback

- **Added: modules/cast.lua**
  - Cast bar module using TBC APIs: `UnitCastingInfo`, `UnitChannelInfo`; events `UNIT_SPELLCAST_*`, `UNIT_SPELLCAST_CHANNEL_*`.
  - Creates `frame.castBar` via `ShadowUF.Units:CreateBar(frame)`; optional name and time font strings from `db.profile.units[unitType].castBar.name` / `.time`, anchored with `Layout:AnchorFrame`.
  - Bar colors from `db.profile.castColors` (cast, channel, uninterruptible).
  - **Visibility:** SUF cast bar is shown whenever the unit is casting; `hidden.cast` is not used for SUF cast bars (it only controls Blizzard cast bar hiding in `HideBlizzardFrames`).
  - **Animation:** Shared `castBarUpdater` frame (UIParent) drives per-frame updates so the bar fill animates smoothly like Blizzard's; `updateCastBarSparkPosition` and spark texture at fill edge; `ensureCastBarSpark` / `setCastBarBorderColor` (dark yellow 2px border).
  - **Detached bars:** Player and target cast bars are detached: `SetParent(frame:GetParent())`, positioned 80px below the unit frame (`SetPoint("TOP", frame, "BOTTOM", 0, -80)`). `bar.detachedPlayer` / `bar.detachedTarget` trigger `SetWidth`/`SetHeight` when showing. Layout skips cast bar height for player and target (`layout.lua`: `key == "castBar" and (frame.unitType == "player" or frame.unitType == "target")`).
  - **Style:** No background texture (unfilled portion transparent); 2px border (dark yellow); spark texture (bright yellow-white, ADD blend) at leading edge, updated every frame.
- **ShadowedUnitFrames.toc, build/build.sh**
  - Added `modules\cast.lua` to TOC and `cast` to MODULES list.
- **modules/defaultlayout.lua**
  - Player and target: `castBar = {enabled = true, order = 60}` so cast bar shows for player and target.
- **modules/health.lua**
  - `Health:UpdateAura`: when `C_UnitAuras`/`AuraUtil` exist, use existing path; else use TBC `UnitDebuff(unit, index, "HARMFUL")` loop with `dispelType` for dispel color (cross-build safe).

### 2026-02-25: Auras tooltips and alignment

- **modules/auras.lua**
  - **Tooltips:** Aura slots enable mouse and show spell tooltip on hover. `SetScript("OnEnter")` uses `GameTooltip:SetUnitAura(unit, index, filter)` when available (rank-correct); no fallback. `SetScript("OnLeave")` hides tooltip. `GameTooltip:IsForbidden()` guarded. Slots store `slot.index`; containers store `container.kind` (buffs/debuffs).
  - **Anchor resolution:** Containers support `anchorTo` like layout: `"$parent"` or `"$healthBar"` etc. When `anchorTo` starts with `"$"`, anchor frame is `parent[key]` (e.g. `frame.healthBar`) so auras can align to the health bar.
- **modules/defaultlayout.lua**
  - Target unit auras: `anchorTo = "$healthBar"` for buffs and debuffs so the first icon aligns with the health bar's left edge (same x axis).

### 2026-02-25: Blizzard cast bar hide option

- **ShadowedUnitFrames.lua**
  - Default `hidden.cast = true` (profile defaults). `HideBlizzardFrames()` uses `_G.PlayerCastingBarFrame` and `_G.PetCastingBarFrame` so it's safe when frames are missing.
- **modules/defaultlayout.lua**
  - `config.hidden.cast = true` so the default layout hides the Blizzard player/pet cast bar.
- **modules/cast.lua**
  - Removed use of `hidden.cast` for SUF cast bar visibility. SUF cast bars always show when casting; `hidden.cast` only controls Blizzard cast bar hiding in core.
