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
