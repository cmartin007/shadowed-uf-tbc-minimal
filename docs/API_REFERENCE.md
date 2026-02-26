# WoW Classic Anniversary TBC – API References

**Target: TBC Anniversary ONLY.** This addon is for WoW Classic Anniversary TBC (re-release of Burning Crusade Classic). Do not use retail-only APIs.

## Source of truth for API calls

**Game Data APIs (REST)** – items, spells, realms, etc. when calling Blizzard services from outside the game:

- **Official source of truth:** [Battle.net – WoW Classic Game Data APIs](https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis)  
  Use this for any HTTP/REST API usage (e.g. fetching item or spell data). The project should rely on Battle.net developer documentation for game data API contracts and endpoints.

**In-game Lua API** – addon functions (e.g. `UnitAura`, `CreateFrame`) used inside the client:

- Documented on [World of Warcraft API/Classic](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic) and [UnitAura](https://warcraft.wiki.gg/wiki/UnitAura) (warcraft.wiki.gg). Cross-check with Battle.net Classic docs where they cover in-game APIs.

## Classic vs retail – use these in WoW Classic Anniversary TBC

| Use in Anniversary TBC | Do **not** use in Anniversary TBC |
|------------------------|----------------------------------|
| `UnitAura(unit, index [, filter])` | `C_UnitAuras.GetAuraDataByIndex()` – added 10.2.5 / 4.4.0 / 1.15.1 |
| `UnitBuff` / `UnitDebuff` (aliases for UnitAura) | `C_UnitAuras.GetAuraDataBySpellName()` |
| Manual iteration with `UnitAura(unit, i, "HARMFUL")` | `C_UnitAuras.GetDebuffDataByIndex()` – not in Anniversary TBC |
| Plain `CreateFrame("Frame", ...)` + `SetBackdrop` | `AuraUtil.UnpackAuraData()` – retail/FrameXML only |
| | `AuraUtil.ForEachAura` – not in Classic global API list |
| | `BackdropTemplateMixin` / `"BackdropTemplate"` – retail |

- **UnitAura** is documented as available in **3.0.2 / 1.13.2** and is the correct API for auras in WoW Classic Anniversary TBC. Debuff limit is **40** for Burning Crusade Classic.
- **C_UnitAuras** and **AuraUtil** are not part of the Classic global API list for this client; use **UnitAura** and handle return values yourself.

## Official Blizzard APIs

### Unit APIs
- `UnitHealth(unit)` - Returns health of unit
- `UnitHealthMax(unit)` - Returns max health
- `UnitPower(unit)` - Returns current power (mana/rage/energy)
- `UnitPowerMax(unit)` - Returns max power
- `UnitPowerType(unit)` - Returns power type (0=Mana, 1=Rage, 3=Energy)
- `UnitName(unit)` - Returns unit name
- `UnitExists(unit)` - Check if unit exists
- `UnitIsUnit(unit1, unit2)` - Compare two units
- `UnitReaction(unit1, unit2)` - Returns reaction (hostile/neutral/friendly)

### Target APIs
- `UnitTarget(unit)` - Returns target's target
- `SecureUnitButton_OnClick()` - For targeting

### Combat APIs
- `UnitAura(unit, index[, filter])` - Get auras; returns `name, icon, count, dispelType, duration, expirationTime, source, ...` (use filter `"HELPFUL"` or `"HARMFUL"`).
- `UnitBuff(unit, index [, filter])` / `UnitDebuff(unit, index [, filter])` - Aliases for UnitAura.
- `CombatLogGetCurrentEvent()` - Combat log events

### Cast APIs
- `UnitCastingInfo(unit)` - Current cast info
- `UnitChannelInfo(unit)` - Channeled cast info
- `SpellStop Casting(unit)` - Stop casting

### Quest APIs
- `GetQuestLogTitle(questID)` - Quest info
- `GetNumQuestLeaderBoards(questLogIndex)` - Quest objectives

### Unit Frames
- `CreateFrame("Frame", name[, parent])` - Create frame
- `frame:RegisterEvent(event)` - Register for events
- `frame:SetScript("OnEvent", function)` - Event handler

### Common Events
- `UNIT_HEALTH` - Health changed
- `UNIT_POWER` - Power changed
- `UNIT_AURA` - Auras changed
- `UNIT_TARGET` - Target changed
- `PLAYER_TARGET_CHANGED` - Player changed target
- `PLAYER_REGEN_DISABLED/ENABLED` - Combat state
- `UNIT_SPELLCAST_START/SUCCESS/FAIL` - Cast events

### Cast events: test in your build
Spellcast event names and whether they support **unit** registration (`RegisterUnitEvent`) can differ by build. To see what your client supports, run the scripts in **`docs/test_cast_events.md`** in chat (with SUF loaded for the unit-event test). Record which events are "OK" for `RegisterEvent` and which are "unit OK" for `RegisterUnitEvent`; the cast module can use that to choose normal vs unit registration per event.

**TBC Anniversary (tested):** `UNIT_SPELLCAST_FAIL` does **not** exist (RegisterEvent gives "unknown event"). The cast module does not register it. `UNIT_SPELLCAST_INTERRUPTED` registers OK; the cast module uses it so the bar hides immediately on interrupt. Cast stop/fail is handled via `UNIT_SPELLCAST_STOP` and `UnitCastingInfo(unit)` returning nil.

### Useful Mixins
- `SecureMixin(frame)` - Make frame secure
- `UnitPowerBarMixin` - Power bar functionality
- `HealthBarMixin` - Health bar functionality

## Community & official resources

### Reference tools for this project

- **Wowpedia** – Game mechanics, formulas, and behaviour (e.g. grey mob level, XP thresholds, quest difficulty). Use when implementing features that depend on WoW rules rather than Lua API alone.  
  - **URL:** https://wowpedia.fandom.com (e.g. [Mob experience](https://wowpedia.fandom.com/wiki/Mob_experience), [Experience point](https://wowpedia.fandom.com/wiki/Experience_point)).

- **Battle.net** – Game data REST APIs and official Blizzard docs (see below).

- **warcraft.wiki.gg** – In-game Lua API and Classic coverage (see below).

### Source of truth – Battle.net (game data / REST)
- **WoW Classic Game Data APIs:** [community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis](https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis)  
  Use this as the source of truth for any game data API calls (items, realms, etc.).

### In-game Lua API (addon reference)
- Main API: https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic
- Unit: https://warcraft.wiki.gg/wiki/Unit
- Events: https://warcraft.wiki.gg/wiki/Events/Classic

## WoW Classic Anniversary TBC – specifics

### Power Types (TBC)
- `0` - Mana
- `1` - Rage  
- `2` - Focus ( Hunters)
- `3` - Energy
- `4` - Happiness

### Class IDs (TBC – no Death Knight)
- `1` - Warrior
- `2` - Paladin
- `3` - Hunter
- `4` - Rogue
- `5` - Priest
- `6` - (unused in TBC)
- `7` - Shaman
- `8` - Mage
- `9` - Warlock
- `11` - Druid

## Example: Basic Unit Frame
```lua
local frame = CreateFrame("Frame", "MyUnitFrame", UIParent)
frame:SetSize(200, 50)
frame:SetPoint("CENTER", 0, -200)

-- Health bar
local healthBar = CreateFrame("StatusBar", nil, frame)
healthBar:SetAllPoints()
healthBar:SetStatusBarColor(0.2, 0.8, 0.2)

-- Register events
frame:RegisterEvent("UNIT_HEALTH")
frame:RegisterEvent("UNIT_POWER")
frame:SetScript("OnEvent", function(self, event, unit)
    if unit == "player" then
        healthBar:SetMinMaxValues(0, UnitHealthMax("player"))
        healthBar:SetValue(UnitHealth("player"))
    end
end)
```

## Performance Tips

1. **Throttle updates** - Don't update every frame
2. **Use :SetScript** instead of closure
3. **Pool frames** - Reuse instead of creating/destroying
4. **Use UNIT_HEALTH** instead of OnUpdate for health
5. **Aura caching** - Don't query auras every frame
