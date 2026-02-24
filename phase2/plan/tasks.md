# Phase 2: Cast Bar + Auras

## Goal
Add cast bar and simplified aura display.

## Tasks

### 2.1 Add Cast Bar
- [ ] Add back `modules/cast.lua`
- [ ] Hardcode cast bar position (below target)
- [ ] Hardcode cast bar colors (yellow)
- [ ] Test cast bar on target

### 2.2 Add Simplified Auras
- [ ] Add back `modules/auras.lua` (simplified version)
- [ ] Hardcode aura position (right of target frame)
- [ ] Hardcode aura icon size (20x20)
- [ ] Hardcode max auras (8 buffs, 8 debuffs)
- [ ] Test buff display
- [ ] Test debuff display

### 2.3 Hardcoded Config
```lua
SUFconfig = {
  cast = {
    position = "BELOW target",
    height = 20,
    color = { r=1, g=0.8, b=0 }
  },
  auras = {
    position = "RIGHT of target",
    size = 20,
    numBuffs = 8,
    numDebuffs = 8
  }
}
```

## Dependencies
- modules/cast.lua
- modules/auras.lua

## Test
- [ ] Cast bar appears when casting
- [ ] Buffs display correctly
- [ ] Debuffs display correctly
