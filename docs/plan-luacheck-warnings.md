# Plan: Address Luacheck Warnings by Module

Current status: **24 warnings / 0 errors** (addon source: modules/ + ShadowedUnitFrames.lua). This document lists each warning and a recommended fix.

---

## 1. modules/auras.lua (1 warning)

| Line | Warning | Fix |
|------|---------|-----|
| 96 | Unused variable `filter` | Variable is set (`"HELPFUL"` / `"HARMFUL"`) but never passed; we call `UnitBuff`/`UnitDebuff` with `nil`. **Option A:** Remove the line and keep passing `nil`. **Option B:** Use `filter` as the third argument to `UnitBuff(unit, index, filter)` and `UnitDebuff(unit, index, filter)` so the filter is explicit (and the variable is used). Prefer B for clarity. |

---

## 2. modules/defaultlayout.lua (1 warning)

| Line | Warning | Fix |
|------|---------|-----|
| 2 | Unused variable `playerClass` | `playerClass` is assigned but never used in this file (leftover for class-specific layout). **Fix:** Rename to `_playerClass` or use `local _ = select(2, UnitClass("player"))` if the call is only for side effect; or remove the line if not needed. |

---

## 3. modules/health.lua (7 warnings)

| Line | Warning | Fix |
|------|---------|-----|
| 11 | Values assigned to `sR`, `sG`, `sB`, `eR`, `eG`, `eB` are unused | Initial `0,0,0,0,0,0` is overwritten in both branches before use. **Fix:** Declare variables without initial value and set them only inside the `if`/`else` (e.g. `local sR, sG, sB, eR, eG, eB` then set in each branch). |
| 12 | Value assigned to `inverseModifier` is overwritten on line 23 before use | Same idea: initial `0` is never read. **Fix:** Assign `inverseModifier` only once, after the if/else: `local inverseModifier = 1 - modifier` (and remove the initial assignment on 12). |

---

## 4. modules/movers.lua (3 warnings)

| Line | Warning | Fix |
|------|---------|-----|
| 7 | Unused variable `playerClass` | **Fix:** Rename to `_playerClass` or remove if truly unused. |
| 8 | Unused function `noop` | **Fix:** Remove the line, or rename to `_noop`; or add a luacheck ignore for this file if kept for future use. |
| 155 | Setting read-only field `?` of global `_G` | In `__newindex = function(tbl, key, value) _G[key] = value end`, luacheck treats `_G` as read-only. **Fix:** Use `rawset(_G, key, value)` instead of `_G[key] = value`. |

---

## 5. modules/tags.lua (1 warning)

| Line | Warning | Fix |
|------|---------|-----|
| 86 | Shadowing upvalue argument `self` on line 82 | `Tags:Register(frame, fontString, config)` has `self`; the inner `fontString.UpdateTags = function(self)` uses `self` for the fontString (different meaning). **Fix:** Rename the inner parameter to avoid shadowing, e.g. `function(fontStr)` and use `fontStr._suf_frame`, `fontStr._suf_tagString`, `fontStr:SetText(...)`. |

---

## 6. modules/units.lua (7 warnings)

| Line | Warning | Fix |
|------|---------|-----|
| 2 | Line too long (521 > 400) | Long table definition. **Fix:** Break into multiple lines (e.g. one key per line) or add a file-level luacheck ignore for max line length in this file. |
| 10 | Unused variable `zoneUnits` | In the multi-assignment, `zoneUnits` is never used. **Fix:** Replace with `_` in the list: e.g. `..., zoneUnits` → `..., _` (or keep name but prefix `_zoneUnits`). |
| 48, 100, 158 | Loop is executed at most once | Small loops over `self.fullUpdates` or similar that may have 0 or 1 element. **Fix:** Leave as-is (correct logic) or add a single-line luacheck ignore above the loop: `-- luacheck: ignore 542`. |
| 700, 702 | Accessing undefined variable `GetSpecializationInfoByID` | TBC may not define this (retail API); code already guards with `if GetSpecializationInfoByID`. **Fix:** Add `GetSpecializationInfoByID` to `.luacheckrc` `read_globals` so the linter knows it can exist at runtime. |

---

## 7. ShadowedUnitFrames.lua (4 warnings)

| Line | Warning | Fix |
|------|---------|-----|
| 13–15 | Line too long (496, 528, 1255 > 400) | Long table/string definitions (e.g. `unitList`, `fakeUnits`, `L.units`). **Fix:** Prefer breaking into multiple lines for readability; or allow longer lines for this file in `.luacheckrc` (e.g. `max_line_length = 1300` for this file only) or leave as-is and accept the warning. |
| 938 | Unused variable `loaded` | `local loaded, reason = C_AddOns.LoadAddOn(...)` – only `reason` may be used. **Fix:** Use `local _, reason = ...` or `local loaded, reason = ...` and use `loaded` in the condition, or rename to `_loaded`. |

---

## Implementation order

1. **Low-risk, single-line fixes:** auras.lua (use `filter` or remove), defaultlayout.lua (`_playerClass`), movers.lua (`_playerClass`, `_noop`, `rawset`), tags.lua (rename inner `self`), ShadowedUnitFrames.lua (`_loaded` or use `loaded`).
2. **health.lua:** Refactor gradient vars and `inverseModifier` so no value is assigned unused (small logic cleanup).
3. **units.lua:** Add `GetSpecializationInfoByID` to `.luacheckrc`; fix `zoneUnits` → `_`; optionally break long line or add per-file max_line_length.
4. **Optional:** Loops “executed at most once” and remaining long-line warnings can be left or suppressed via `.luacheckrc` if the code is correct and readability is preferred over strict line length.

---

## .luacheckrc changes (minimal)

- Add `GetSpecializationInfoByID` to `read_globals` (units.lua).
- Optionally add `ignore` for “loop executed at most once” (code 542) and/or “line too long” (511) if you prefer not to change those lines.

After applying the code fixes above, re-run:

```bash
luacheck modules ShadowedUnitFrames.lua --no-color
```

and update this plan with any remaining warnings.
