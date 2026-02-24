# SUF TBC Minimal - Development Notes

## Project Goal
Lightweight, fast unit frames for WoW Classic TBC

## Core Principles
1. Speed first - Every feature must not impact performance
2. Robust - No fragile code
3. Minimal - Only essential features
4. Hardcoded - No options menu

## Architecture

### Main Files
- `ShadowedUnitFrames.lua` - Main addon core (~51KB)
- `Config.lua` - Hardcoded configuration
- `modules/units.lua` - Unit definitions (~57KB)
- `modules/layout.lua` - Frame layout
- `modules/health.lua` - Health bar
- `modules/power.lua` - Power bar

### Unit Frame Types (TBC)
- `player` - Player frame
- `target` - Target frame

### Removed for TBC
- Arena frames (not in Classic)
- Boss frames (use target)
- Raid frames (separate addon)
- Party frames (separate addon)

## Hardcoded Config

```lua
SUFconfig = {
    player = {
        anchor = "BOTTOM",
        x = 0,
        y = 200,
        width = 200,
        height = 50
    },
    target = {
        anchor = "LEFT", -- relative to player
        x = 220,
        y = 0,
        width = 200,
        height = 50
    }
}
```

## Development Phases

### Phase 1: MVP
- [x] Strip options/media/localization
- [x] Keep only player+target
- [ ] Test in WoW
- [ ] Simplify units.lua

### Phase 2: Cast + Auras
- [ ] Add cast bar
- [ ] Add aura display

### Phase 3: Polish
- [ ] Combat fader (optional)

## Testing Checklist

- [ ] Player frame appears
- [ ] Target frame appears
- [ ] Health updates
- [ ] Power updates
- [ ] Target switching works
- [ ] No Lua errors
- [ ] CPU < 1%
- [ ] Memory < 5MB

## Links
- Blizzard API: https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic
- Battle.net: https://community.developer.battle.net/docs/world-of-warcraft-classic
