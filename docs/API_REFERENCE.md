# WoW Classic TBC API References

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
- `UnitAura(unit, index[, filter])` - Get auras/buffs/debuffs
- `GetAuraInfo()` - Get detailed aura info
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

### Useful Mixins
- `SecureMixin(frame)` - Make frame secure
- `UnitPowerBarMixin` - Power bar functionality
- `HealthBarMixin` - Health bar functionality

## Community Resources

### Warcraft.wiki.gg
- Main API: https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic
- Unit: https://warcraft.wiki.gg/wiki/Unit
- Events: https://warcraft.wiki.gg/wiki/Events

### Battle.net Developer
- Game Data APIs: https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis

## TBC Classic Specific

### Power Types (TBC)
- `0` - Mana
- `1` - Rage  
- `2` - Focus ( Hunters)
- `3` - Energy
- `4` - Happiness

### Class IDs
- `1` - Warrior
- `2` - Paladin
- `3` - Hunter
- `4` - Rogue
- `5` - Priest
- `6` - Death Knight
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
