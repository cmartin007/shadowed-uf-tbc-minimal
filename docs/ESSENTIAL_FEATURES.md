# Essential Features – Do Not Cull

**Purpose:** This list defines what the minimal build (player + target + pet unit frames on TBC) **requires**. When using **docs/CULL_INVESTIGATION.md**, check every change against this list so these features are not accidentally removed or broken.

**Scope:** WoW Classic Anniversary TBC only. Layout is hardcoded in `modules/defaultlayout.lua`; no options UI.

---

## 1. Core and init

| Feature | Where | Why essential |
|--------|--------|----------------|
| **ShadowedUnitFrames.lua** main addon core | `ShadowedUnitFrames.lua` | OnInitialize, AceDB, LoadDefaultLayout, HideBlizzardFrames, unit list and module loading. |
| **LoadDefaultLayout()** | Core + defaultlayout.lua | Single source of layout/positions; called on init and profile reset. Must remain. |
| **AceDB-3.0** (single profile) | Core, libs | SavedVariables and profile defaults; layout is applied from defaultlayout into db.profile. |
| **profile.units** and **profile.positions** | Core, defaultlayout, layout, units | Layout and frame positioning; required for player, pet, target. |

---

## 2. Modules (must remain)

| Module | File | Purpose |
|--------|------|--------|
| **Units** | modules/units.lua | Creates and updates unit frames (player, pet, target); registers events; visibility. |
| **Layout** | modules/layout.lua | Applies config to frames (bars, fonts, backdrop, anchors); CheckMedia; SML integration. |
| **Default layout** | modules/defaultlayout.lua | Defines config.units and config.positions for all units; merged into db on LoadDefaultLayout. |
| **Health** | modules/health.lua | Health bar and dispel highlight (UnitDebuff when needed). |
| **Power** | modules/power.lua | Power bar (mana, energy, etc.). |
| **Cast bar** | modules/cast.lua | Player and target cast bars (UnitCastingInfo/UnitChannelInfo); detached; spark; Blizzard bar hide. |
| **Auras** | modules/auras.lua | Buff/debuff icons; UnitBuff/UnitDebuff; Cooldown (OmniCC); tooltips; borders. |
| **Tags** | modules/tags.lua | Tag parsing for text (e.g. [name], [(()afk() )]); UpdateTags on font strings. |
| **Helpers** | modules/helpers.lua | Shared utilities used by layout/units. |
| **Base combo points** | modules/basecombopoints.lua | Combo points (and class bars if used in defaultlayout for player). |

Do **not** remove these modules or their registration. Disabling a feature (e.g. a bar) should be done in defaultlayout (e.g. `enabled = false`), not by deleting the module.

---

## 3. Units that must keep working

| Unit | Note |
|------|------|
| **player** | Main frame; health, power, cast bar, auras, tags. |
| **pet** | Pet frame; health, power (if enabled in layout). |
| **target** | Target frame; health, power, cast bar, auras, tags. |

- **Level-diff color:** `[level]` tag in `modules/tags.lua` colors the level number by quest-style difficulty (grey/green/yellow/red by level differential using TBC grey formula). Do not remove or regress this when changing tags or defaultlayout text like `[level( )][perpp]`.
- **Live health/power text:** Tags `[curhp]`, `[curmaxhp]`, `[curpp]`, `[curmaxpp]`, `[perhp]`, `[perpp]` in `modules/tags.lua` must update immediately when health or power change, driven by unit events (`UNIT_HEALTH`, `UNIT_MAXHEALTH`, `UNIT_CONNECTION`, `UNIT_POWER_FREQUENT`, `UNIT_MAXPOWER`, `UNIT_DISPLAYPOWER`) wired to `fontString:UpdateTags`. Do not change these tags or their events in a way that reintroduces "only updates on /reload" behavior.
- **Player buff whitelist:** Player buffs in `modules/auras.lua` are filtered by `cfg.whitelist` (a name-keyed table). When the whitelist is non-empty, only named buffs are shown. The whitelist is defined in `modules/defaultlayout.lua` in the player's `auras.buffs` config. `whitelist = {}` must remain in the AceDB defaults (`ShadowedUnitFrames.lua`) so `verifyTable` does not strip it. Do not remove `whitelist` from the defaults or the scan-index/button-slot decoupling in `updateAuraList`.
- **Self-cast debuff enlargement:** In `modules/auras.lua`, self-cast debuffs on the target render at 1.30x scale via `SetScale` on Button frames. Caster detection uses `playerUnits[sourceUnit]` (not `isFromPlayerOrPlayerPet`). Bottom-aligned positioning ensures mixed-scale icons share a baseline. Do not change aura buttons to Frame (SetScale only works on Button), and do not use `isFromPlayerOrPlayerPet` for self-cast detection (it is true for all player-type casters on Classic Anniversary).

The codebase may still reference other unit types (e.g. targettarget, party, raid) for init or layout merge. **Do not** remove support for player, pet, or target; do not break the path that creates and updates these three frames.

---

## 4. Profile keys that are required

These are read by core or modules for the minimal build. Do not remove them from defaults without replacing their use.

| Key | Used by | Purpose |
|-----|--------|--------|
| **profile.locked** | units.lua | Used for showRaid and visibility; keep (e.g. true) so layout stays fixed. |
| **profile.hidden** | Core HideBlizzardFrames | At least **hidden.cast** (hide Blizzard cast bar). Other hidden.* may be needed to hide Blizzard player/pet/target so SUF frames show. |
| **profile.units** | layout, units, defaultlayout | Per-unit config (bars, auras, cast bar, etc.). Required. |
| **profile.positions** | layout, units, defaultlayout | Per-unit positions. Required. |
| **profile.tags** | tags.lua | Tag strings; can be empty but key must exist if tags.lua reads it. |
| **profile.bars** | layout.lua | Bar texture name for SML. Required for layout. |
| **profile.font** | layout.lua | Font name for SML. Required for layout. |
| **profile.backdrop** | layout.lua | Backdrop/inset/border. Required for layout. |

If **profile.tooltipCombat** is used in units.lua for tooltip-in-combat behavior, keep it (or replace with a constant and then remove the key).

---

## 5. Layout and media pipeline

| Feature | Why essential |
|--------|----------------|
| **Layout:CheckMedia()** (or equivalent) | Resolves bar/font/backdrop paths (SML or fallbacks); layout uses these. |
| **LibSharedMedia-3.0** (or stub) | Layout and defaultlayout reference bar/font/backdrop by name; Fetch/fallback must work. |
| **Backdrop/inset/border** in layout | Frames and cast bar use backdrop table; edgeSize 0 supported for "no border". |
| **Anchor resolution** | defaultlayout and auras use shorthand (BL, TR); ResolveAnchorPoints (or equivalent) for SetPoint. |

You may simplify media to "resolve once at load" but the pipeline from config -> bars/fonts/backdrop -> frame appearance must remain.

---

## 6. Blizzard frame hiding

| Feature | Why essential |
|--------|----------------|
| **HideBlizzardFrames()** | Prevents duplicate player/pet/target and cast bar; uses profile.hidden. |
| **hidden.cast** | Hiding Blizzard cast bar is default; SUF cast bars are independent. |
| Safe nil checks when hiding | RULES.md: guard against nil frames before calling methods. |

Do not remove the hide logic for the Blizzard frames that correspond to units we show (player, pet, target, cast bar).

---

## 7. TOC and build

- **ShadowedUnitFrames.toc** must list all modules in section 2 and the libs they depend on (LibStub, CallbackHandler, LibSharedMedia, AceDB, etc.).
- **build/build.sh** must copy the same set of files so the release build matches.

---

## 8. Updating this list

- When **adding** a feature that is required for the minimal build, add it here with location and reason.
- When **culling** in CULL_INVESTIGATION.md, if you remove something that appears in this list, either remove it from this list only after the feature is intentionally dropped from the minimal scope (and update RULES/PROGRESS), or do not cull it.
- When in doubt, keep the feature and document the question in CULL_INVESTIGATION.md instead of removing it.
