# Phase 2 Test Checklist

## WoW Classic Anniversary TBC – Cast Bar + Auras

### Load and Stability
- [ ] Addon loads without Lua errors
- [ ] No errors when entering world or switching zones
- [ ] No errors when targeting units or starting/stopping casts

### Cast Bar – Player
- [ ] Player cast bar appears when casting a spell (e.g. Healing Touch, Shadow Bolt)
- [ ] Bar fills left-to-right (or as configured) during cast
- [ ] Spell name and/or cast time visible when configured in defaultlayout
- [ ] Bar hides when cast completes, fails, or is interrupted
- [ ] Channeled spells: bar drains correctly (e.g. Blizzard, Drain Life)

### Cast Bar – Target
- [ ] Target cast bar appears when target is casting
- [ ] Bar reflects target’s cast progress
- [ ] Bar hides when target stops casting or loses target

### Cast Bar – Config
- [ ] Cast bar position/size follow defaultlayout.lua (castBar order, height)
- [ ] Cast bar colors (cast vs channel vs uninterruptible) use db.profile.castColors when implemented

### Health Bar – Dispel Color (TBC)
- [ ] If healthBar.colorDispel is enabled: health bar color changes for dispellable debuffs (Magic, Curse, etc.) on friendly units
- [ ] No Lua errors from aura iteration (UnitDebuff used instead of C_UnitAuras)

### Auras (if implemented)
- [ ] Auras module loads; no error when units.lua calls UpdateFilter
- [ ] Target (and player if enabled) buff/debuff icons show and update on UNIT_AURA
- [ ] Aura position/size follow defaultlayout (anchorPoint, x, y, perRow, maxRows)
- [ ] Aura icon borders visible (debuff type color on debuffs); unit frame borders off
- [ ] With OmniCC: timer text on aura icons; without OmniCC: cooldown spiral only
- [ ] Only TBC APIs used in TBC path (UnitBuff/UnitDebuff); no C_UnitAuras or AuraUtil in critical path

### Performance and Size
- [ ] No noticeable frame drop when casting or when auras update
- [ ] Build/release size remains reasonable (document in review)

## Bugs Found
_Record any issues here:_

## Notes
- Test on a character that can cast and channel (e.g. Mage, Priest, Warlock).
- Test with a target that casts (e.g. hostile caster NPC).
