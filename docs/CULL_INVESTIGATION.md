# Cull Investigation: Features to Remove or Simplify

**Goal:** Reduce the addon to the minimum needed for **player + target (+ pet)** unit frames on TBC, in line with **RULES.md**:

- **Speed first** – Every feature must not impact performance  
- **Robust** – No fragile code, edge cases handled  
- **Minimal** – Only essential features  
- **Hardcoded** – User config saved to variables, no options menu  

**Before culling:** Check **docs/ESSENTIAL_FEATURES.md** so you do not remove or break required features.

Use this doc to decide what can be culled. For each item: confirm whether it is still required for the minimal build; if not, remove or replace with a no-op/hardcoded path.

---

## 1. Slash command and Options addon

**Where:** `ShadowedUnitFrames.lua` – `SlashCmdList["SHADOWEDUF"]`, `LoadAddOn("ShadowedUF_Options")`

**What it does:** `/shadowuf` (and /suf, etc.) tries to load `ShadowedUF_Options` and open config. In this build the Options addon is not included, so it always fails and prints an error.

**Investigate:**
- [ ] Is any slash behavior still needed (e.g. `/shadowuf profile Name`)?
- [ ] If no: remove slash registration, or replace with a single message (“No options UI. Layout is in defaultlayout.lua.”) and no `LoadAddOn`.
- [ ] Remove or simplify `L["Failed to load ShadowedUF_Options..."]` and related strings if slash is culled.

---

## 2. ShowInfoPanel and infoMessages

**Where:** `ShadowedUnitFrames.lua` – `ShowInfoPanel()`, `infoMessages`, `self:ShowInfoPanel()` in `OnInitialize`, `db.global.infoID`

**What it does:** Shows a one-off info dialog (e.g. “You must restart…”) keyed by `db.global.infoID`. Currently `infoID` is set to max so the panel effectively never shows.

**Investigate:**
- [ ] Is any info panel still needed for this minimal build?
- [ ] If no: remove `ShowInfoPanel` and the call in `OnInitialize`; remove or shrink `infoMessages`; consider dropping `global.infoID` from defaults if nothing else uses `db.global`.

---

## 3. LibDualSpec-1.0

**Where:** `ShadowedUnitFrames.lua` – `LibStub("LibDualSpec-1.0", true)`, `EnhanceDatabase(self.db, ...)`  
**TOC:** Not in OptionalDeps; only used if present.

**What it does:** Lets dual-spec profiles share or separate DB. Optional addon.

**Investigate:**
- [ ] Is dual-spec switching needed for TBC minimal (single hardcoded layout)?
- [ ] If no: remove the LibDualSpec block entirely to avoid extra lookup and simplify init.

---

## 4. Profile defaults only used by removed/optional features

**Where:** `ShadowedUnitFrames.lua` – `self.defaults.profile`

**Candidates:**

| Key | Used by | Note |
|-----|--------|------|
| `locked` | units.lua (`showRaid`, visibility early-return) | Keep; layout is fixed, frames never “unlocked”. |
| `advanced` | Grep: no uses in minimal modules | Candidate to remove from defaults. |
| `tooltipCombat` | units.lua (SUF_OnEnter: hide tooltip in combat) | Keep if tooltips desired; else cull and simplify OnEnter. |
| `bossmodSpellRename` | Grep: no uses in minimal modules | Candidate to remove. |
| `omnicc` / `blizzardcc` | Grep: no direct uses in minimal modules | Candidate to remove (OmniCC still works via Cooldown frame). |
| `tags` | tags.lua / layout | Keep if using custom tags; else can be empty. |
| `range` | Grep: range checker / alpha | If no range-based alpha, remove. |
| `filters` (zonewhite, zoneblack, etc.) | visibility / zone | Only needed if party/raid/zone visibility is used. |
| `visibility` (arena, pvp, party, raid, neighborhood) | units.lua SetVisibility, LoadUnits | Only needed for units other than player/pet/target. |

**Investigate:**
- [ ] For **player + target + pet** only: which of these keys are ever read?
- [ ] Remove from defaults any key that is never read or only used by culled code paths.

---

## 5. HideBlizzardFrames – scope of “hidden”

**Where:** `ShadowedUnitFrames.lua` – `HideBlizzardFrames()`, `profile.hidden.*`

**What it does:** Hides Blizzard UI (party, raid, player, pet, target, focus, boss, arena, cast bar, buffs, etc.) based on `profile.hidden.*`.

**Investigate:**
- [ ] This build only shows player, pet, target. Which Blizzard frames do we actually need to hide?
- [ ] Keep only: `hidden.cast` (and any other that is used). Remove branches and defaults for `hidden.*` that don’t apply (e.g. arena, raid if those units are culled).
- [ ] Ensure no references to removed `hidden` keys.

---

## 6. Units and headers not used by minimal layout

**Where:** `ShadowedUnitFrames.lua` – `unitList`, `partyUnits`, `raidUnits`, `bossUnits`, `arenaUnits`, etc.  
**Where:** `modules/units.lua` – `headerFrames`, `zoneUnits`, `CheckPlayerZone`, `InitializeFrame` for party/raid/arena/boss, etc.  
**Where:** `modules/defaultlayout.lua` – `config.units` and `config.positions` for all unit types.

**What it does:** Full unit list and init path support party, raid, arena, boss, focus, targettarget, etc. Minimal build only enables **player, pet, target** in defaultlayout.

**Investigate:**
- [ ] Can we trim `unitList` and related tables to only player, pet, target, targettarget (if ToT is shown)?
- [ ] Can we avoid creating headers/frames for party, raid, arena, boss, focus (and their positions) so they are never loaded?
- [ ] Impact on `LoadUnits`, `ReloadHeader`, `CheckPlayerZone`, and `SetVisibility`: ensure no errors when only a subset of units exist; simplify or stub paths for disabled unit types.
- [ ] defaultlayout: consider a “minimal” section that only defines player, pet, target (and targettarget if desired) so the rest of the file is clearly optional or for reference.

---

## 7. basecombopoints and class bars (runeBar, totemBar, etc.)

**Where:** `modules/basecombopoints.lua`, `defaultlayout.lua` – comboPoints, runeBar, totemBar, druidBar, priestBar, shamanBar, staggerBar, etc.

**What it does:** Combo points, runes, totems, class-specific bars. Some are enabled in defaultlayout for player.

**Investigate:**
- [ ] For minimal TBC (e.g. lock + target): are all of these needed, or can some be disabled in defaultlayout only?
- [ ] If culling code: can we remove basecombopoints or certain bar types entirely, or only disable them in layout?
- [ ] Document which bars are “in scope” for minimal so future culls don’t break them.

---

## 8. layout.lua – media and reload

**Where:** `modules/layout.lua` – `Layout:MediaForced`, `Layout:MediaRegistered`, `mediaRequired`, `Layout:Reload()`, `Layout:CheckMedia()`

**What it does:** LibSharedMedia-3.0 integration; reload when media changes; fallbacks when a media is missing.

**Investigate:**
- [ ] If we never change media at runtime: can we resolve media once at load and avoid RegisterCallback / MediaRegistered?
- [ ] Can we simplify to a single `CheckMedia()` at init and drop `mediaRequired` / `MediaRegistered`?
- [ ] Keep SML for fonts/bars/backdrop if layout still references them; otherwise consider hardcoded paths only.

---

## 9. AceDB callbacks and profile switching

**Where:** `ShadowedUnitFrames.lua` – `RegisterCallback(self, "OnProfileChanged", "ProfilesChanged")`, `ProfilesChanged`, `LoadUnitDefaults()`

**What it does:** Supports multiple named profiles and reloads layout on profile change.

**Investigate:**
- [ ] With hardcoded layout and no options UI, do we need multiple profiles at all?
- [ ] If no: consider a single profile and remove or no-op profile switching; simplify `ProfilesChanged` (e.g. only reload units/layout if still needed for one profile).
- [ ] Slash `profile <name>`: remove if profiles are culled.

---

## 10. CONFIGMODE_CALLBACKS (already removed)

**Where:** Was in `ShadowedUnitFrames.lua`; removed when movers was culled.

**Status:** Removed. If any other code still references `CONFIGMODE_CALLBACKS["Shadowed Unit Frames"]`, remove it.

---

## 11. RULES.md and docs references to culled code

**Where:** `RULES.md`, `PROGRESS.md`, `phase2/CHANGES.md`, other docs

**What to do:**
- [ ] After any cull: update RULES.md so it doesn’t refer to removed features (e.g. movers, options, config mode).
- [ ] PROGRESS “What’s Working” and phase docs: list only modules/features that remain.

---

## How to use this doc

1. **Check** **docs/ESSENTIAL_FEATURES.md** – do not cull anything listed there unless you are intentionally changing minimal scope.
2. **Pick an item** (e.g. “Slash command”, “ShowInfoPanel”, “LibDualSpec”).
3. **Grep/search** the repo for all references to the feature and its profile keys.
4. **Decide:** Required for minimal player+target+pet? If no, remove or replace with a minimal implementation.
5. **Implement:** Delete or stub the code; remove from TOC/build if a module; trim profile defaults.
6. **Checklist:** Mark the “Investigate” boxes and add a one-line “Decision” under the section (e.g. “Culled: no options UI.”).
7. **Update** RULES.md and PROGRESS.md as in §11.

**Decision template per item:**

```text
Decision: [ KEEP / CULL / SIMPLIFY ]
Reason: ...
```
