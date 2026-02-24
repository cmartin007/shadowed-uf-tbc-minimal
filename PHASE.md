# SUF TBC Minimal - Development Plan

## Philosophy
- **Speed first** - Every feature must not impact performance
- **Robust** - No fragile code, edge cases handled
- **Minimal** - Only essential features
- **Hardcoded** - User config saved to variables, no options menu

---

## Phase 1: Core Only (MVP)
**Goal:** Player + Target frame with basic health/power

### Keep
- `ShadowedUnitFrames.lua` - Main addon core
- `ShadowedUnitFrames.toc` - TOC file
- `ShadowedUnitFrames.xml` - XML loader
- `modules/units.lua` - Unit definitions
- `modules/layout.lua` - Frame creation
- `modules/health.lua` - Health bar
- `modules/power.lua` - Power bar
- `modules/basecombopoints.lua` - Combo points (War/Rogue)
- `modules/defaultlayout.lua` - Default anchor positions

### Remove
- ALL of `options/` (240KB config UI - GONE)
- ALL of `localization/` except enUS
- ALL media (use WoW defaults)
- All other modules

---

## Phase 2: Essential Features
**Goal:** Cast bars + basic auras

### Add Back
- `modules/cast.lua` - Cast bar
- `modules/auras.lua` - Buffs/debuffs (simplified)

### Hardcoded Config (no options)
```lua
SUFconfig = {
  player = { position = "BOTTOM", x = 0, y = 200 },
  target = { position = "RIGHT", x = 200, y = 0 },
  auras = { position = "RIGHT", size = 20, numAuras = 8 },
  colors = {
    health = { r = 0.2, g = 0.8, b = 0.2 },  -- Green
    power = { r = 0.6, g = 0.6, b = 0.6 }, -- Grey
  }
}
```

---

## Phase 3: Polish
**Goal:** Combat fader, portrait placeholder

### Add Back (Minimal)
- `modules/fader.lua` - Fade in/out of combat
- `modules/portrait.lua` - Simple texture portrait (optional)

---

## Files Structure (Final)
```
ShadowedUnitFrames/
├── ShadowedUnitFrames.lua    (CORE - ~51KB → ~15KB)
├── ShadowedUnitFrames.toc
├── ShadowedUnitFrames.xml
├── modules/
│   ├── units.lua            (CORE - ~58KB → ~20KB)
│   ├── layout.lua            (CORE)
│   ├── health.lua
│   ├── power.lua
│   ├── cast.lua             (Phase 2)
│   ├── auras.lua            (Phase 2)
│   └── fader.lua           (Phase 3 - optional)
├── localization/
│   └── enUS.lua            (Phase 1)
└── media/                   (Phase 1 - use WoW defaults)
```

---

## Hardcoded Defaults

### Positions
- Player: Bottom center, above WoW player frame
- Target: Right side of screen

### Colors
- Health: Green gradient
- Power: Class color
- Cast: Yellow

### Sizes
- Player: 200x50px
- Target: 200x50px
- Aura icons: 20x20px

---

## TODO List

- [ ] Phase 1: Strip options/, localization/, media/
- [ ] Phase 1: Simplify main.lua to bare minimum
- [ ] Phase 1: Get player+target working
- [ ] Phase 2: Add cast bar
- [ ] Phase 2: Add simplified auras
- [ ] Phase 3: Add fader
- [ ] Test on WoW Classic Anniversary TBC
