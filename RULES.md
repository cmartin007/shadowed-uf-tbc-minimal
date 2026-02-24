# Development Rules

**This project is for WoW Classic Anniversary TBC ONLY.** Do not add retail-only APIs or code paths for other game versions.

## Philosophy
- **Speed first** - Every feature must not impact performance
- **Robust** - No fragile code, edge cases handled
- **Minimal** - Only essential features
- **Hardcoded** - User config saved to variables, no options menu

## 1. Always Update CHANGES.md

**Before any commit, you MUST update `phase1/CHANGES.md`** (or the relevant phase folder).

Include:
- Date of change
- Files modified/added/removed
- Reason for change
- Any breaking changes

Example:
```markdown
### 2026-02-24: Description
- Changed: file.lua - modified function X
- Added: new.lua - new feature
- Removed: old.lua - not needed
```

## 2. Always Update PROGRESS.md

After any phase change, update `PROGRESS.md` in the root:
- Mark tasks as complete/in-progress
- Update current phase status
- Note what's working/broken
- Update next action

## 3. Phase Structure

Each phase (phase1/phase2/phase3) must have:
- `plan/tasks.md` - What to do
- `build/` - Commands to run
- `test/checklist.md` - Test cases
- `review/decision.md` - Approval
- `CHANGES.md` - Change log

## 4. Commit Message Format

Use clear, descriptive commit messages:
- `Phase1: Description`
- `Fix: Issue description`
- `Docs: What was added`

## 5. Test Before Push

Always test changes locally before pushing to repo.

## 6. No Breaking Changes

- Don't remove features without discussion
- Document any config changes
- Layout and settings live in modules/defaultlayout.lua; update that file if adding new layout/settings

## 7. Keep API Reference Updated

- Use [Battle.net WoW Classic Game Data APIs](https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis) as the **source of truth** for API calls.
- When you add or change API usage, document it in `docs/API_REFERENCE.md`.

## 8. TBC Anniversary Compatibility Rules

- **No retail-only APIs**
  - Do **not** use `C_UnitAuras`, `AuraUtil.*`, `GetSpecialization`, `GetSpecializationInfoByID`, or other retail-only globals.
  - Use `UnitAura` / `UnitBuff` / `UnitDebuff` and other TBC-compatible APIs as documented in `docs/API_REFERENCE.md`.

- **Libs must match TOC + usage**
  - Every path in `ShadowedUnitFrames.toc` must point to an existing file (especially under `libs/`).
  - If you add or rename a stub in `libs/`, update the TOC and `build/build.sh` so the release build stays in sync.
  - Prefer **removing** unused libs (e.g. dual-spec) over stubbing them when the feature does not exist in TBC Anniversary.

- **LibStub semantics**
  - `LibStub("Major", true)` must be treated as **get library (silent)**, not as `NewLibrary`.
  - Only call `LibStub:NewLibrary("Major", minor)` with a numeric `minor`.

- **Stubs must fit call sites**
  - If code does `LibStub:GetLibrary("AceDB-3.0"):New(..., true)`, the AceDB stub must:
    - Be registered via `LibStub:NewLibrary("AceDB-3.0", <minor>)`.
    - Accept a non-table third argument (e.g. `true`) without error and return an object that supports the methods the core calls (e.g. `RegisterCallback` no-op).
  - If code does `SML.RegisterCallback(...)`, the LibSharedMedia stub must define `RegisterCallback` / `UnregisterCallback` as safe no-ops.
  - If layout calls `fontString:UpdateTags()`, the Tags stub must attach an `UpdateTags` method to the font string (it can be a no-op in the minimal build).

- **Safe interaction with Blizzard frames**
  - When hiding Blizzard frames, always guard against `nil` frames before calling methods (e.g. in `hideBlizzardFrames` / `basicHideBlizzardFrames`).
  - Avoid calling widget methods (like `FontString:SetText`) before their font is known to be set.

- **Media and textures (no addon media folder)**
  - The addon **does not ship** `media/` (fonts, status bar textures, borders). All bar/font/backdrop paths must resolve to **built-in WoW paths** or the UI will render black/missing.
  - **LibSharedMedia stub:** `MediaList` must map each type (STATUSBAR, FONT, BACKGROUND, BORDER) to real built-in paths (e.g. statusbar → `Interface\\TargetingFrame\\UI-StatusBar`, font → `Fonts\\FRIZQT__.ttf`). `Fetch()` must return one of these when the requested key is missing (fallback to `Blizzard`).
  - In **Register()**, if the path is under `ShadowedUnitFrames\\media`, replace it with the built-in fallback for that type so layout’s Register calls for removed addon assets still yield a valid path.
  - **Layout CheckMedia()** fallbacks must **not** reference `Interface\\AddOns\\ShadowedUnitFrames\\media\\...`. Use built-in paths only (e.g. statusbar default `Interface\\TargetingFrame\\UI-StatusBar`, font default `Fonts\\FRIZQT__.ttf`).

## 9. Findings / Gotchas

- **Deploying to WoW**
  - Use `./build/copy-to-wow.sh` to copy `build/release/` into the WoW addon folder. Default target: `C:\Program Files (x86)\World of Warcraft\_anniversary_\Interface\AddOns\ShadowedUnitFrames` (WSL path: `/mnt/c/Program Files (x86)/World of Warcraft/_anniversary_/Interface/AddOns/ShadowedUnitFrames`). Override with `WOW_ADDON_DIR=/path ./build/copy-to-wow.sh`. Run `./build/build.sh` first.

- **AFK tag and layout text**
  - The `[afk]` tag in layout strings (e.g. `[(()afk() )][name]`) is resolved by `modules/tags.lua` via `UnitIsAFK(unit)`. Tag text only refreshes when the frame’s `FullUpdate` runs. **units.lua** must register:
    - **Player:** `PLAYER_FLAGS_CHANGED` → FullUpdate.
    - **Party / Raid:** `UNIT_FLAGS` → FullUpdate.
  - Otherwise the name line stays static and never shows/clears "AFK". In **movers.lua** the config env stubs `UnitIsAFK` to `false` for the layout preview; that does not affect in-game behaviour.

- **Layout source: defaultlayout.lua**
  - Layout is **not** loaded from saved variables. **ShadowedUnitFrames.lua** always calls `LoadDefaultLayout()` on init and on profile reset so the layout for all users/characters comes from **modules/defaultlayout.lua**. Any change to that file is the single source of truth after reload/update.
  - **Unit frame positions** are in `config.positions` inside `LoadDefaultLayout()`. The player frame is **`config.positions.player`** (e.g. `{point = "TOPLEFT", anchorTo = "UIParent", relativePoint = "TOPLEFT", y = -25, x = 20}`). Other units (target, party, focus, etc.) are in the same table; party/target often anchor to `#SUFUnitplayer` or `#SUFUnittarget`. Change `x`/`y` or point/relativePoint to move frames.

- **AceDB `global`**
  - If any code uses `ShadowUF.db.global` (e.g. **ShowInfoPanel** uses `db.global.infoID`), the AceDB defaults passed to `:New()` must include a **`global`** table. If defaults only have `profile`, `db.global` is nil and indexing it (e.g. `db.global.infoID`) errors at runtime.

- **Auras: anchor points and layout**
  - WoW `Frame:SetPoint()` accepts only **full** point names (e.g. `BOTTOMLEFT`), not shorthand (`BL`). Layout and defaultlayout use shorthand (BL, TR, TL, etc.). **`ShadowUF.ResolveAnchorPoints(anchorPoint)`** in **defaultlayout.lua** converts shorthand to full names using `Layout:GetRelative()`; use it whenever passing an anchor point to `SetPoint` in auras (or any module using layout anchor keys).
  - When **LoadDefaultLayout(useMerge)** runs with `useMerge = true`, units that already have dimensions are **skipped** for the full merge. To make defaultlayout aura edits (e.g. anchorPoint, x, y) apply anyway, **finalizeData** in defaultlayout.lua merges **auras** from the default config into those units in an `elseif` branch so aura layout is always applied.

- **Auras: OmniCC and borders**
  - **OmniCC** (and similar addons) attach to **Cooldown** frames. Each aura icon slot has a `Cooldown` frame covering the icon; `SetCooldown(start, duration)` is called when the aura has a duration so OmniCC can show its timer. Built-in duration text is hidden when a cooldown is set to avoid double timers.
  - **Aura icon borders** are drawn in **auras.lua** via `addIconBorder(slot)` (four edge textures) and `setIconBorderColor(slot, auraType, kind)` (debuff type color for debuffs). **Unit frame** borders are controlled by **backdrop.edgeSize** and **backdrop.borderTexture** in layout; set `edgeSize = 0` or `borderTexture = "None"` in defaultlayout and layout logic clears `edgeFile` so no frame border is drawn.

---

**Last Updated:** 2026-02-25
