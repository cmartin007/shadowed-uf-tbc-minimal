# SUF TBC Minimal - Development Notes

## Project Goal
Lightweight, fast unit frames for **WoW Classic Anniversary TBC ONLY** (anniversary re-release of Burning Crusade Classic). No retail support; APIs must be TBC-compatible.

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

### Unit Frame Types (Anniversary TBC)
- `player` - Player frame
- `target` - Target frame

### Removed for Anniversary TBC
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
- **Source of truth for API calls:** [Battle.net – WoW Classic Game Data APIs](https://community.developer.battle.net/documentation/world-of-warcraft-classic/game-data-apis)
- **Game mechanics & formulas:** [Wowpedia](https://wowpedia.fandom.com) (e.g. grey mob level, XP) – see `docs/API_REFERENCE.md` for full reference list
- In-game Lua API (addon reference): https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic
- Battle.net WoW Classic docs: https://community.developer.battle.net/documentation/world-of-warcraft-classic

## Testing Blizzard API (GET/POST)

The **test/** folder contains unit tests that call the Battle.net WoW Classic Game Data APIs over HTTP. See **test/README.md** for setup (credentials, `pip install -r test/requirements.txt`) and run with `pytest test/ -v` from the repo root.
