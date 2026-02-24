# Phase 2 Build - Add Cast + Auras

## Add Files
```bash
# Add cast bar module
cp ../backup/modules/cast.lua modules/

# Add auras module (simplified)
cp ../backup/modules/auras.lua modules/
```

## Hardcode Config
Create `Config.lua`:
```lua
local SUFconfig = {}

-- Cast Bar
SUFconfig.cast = {
    position = "BELOW target",
    height = 20,
    width = 200,
    color = { r = 1, g = 0.8, b = 0 }, -- Yellow
    channelColor = { r = 0.8, g = 0.6, b = 0 }
}

-- Auras
SUFconfig.auras = {
    position = "RIGHT of target frame",
    size = 20,
    numBuffs = 8,
    numDebuffs = 8,
    spacing = 2
}

-- Positions (from Phase 1)
SUFconfig.player = {
    position = "BOTTOM",
    x = 0,
    y = 200,
    width = 200,
    height = 50
}

SUFconfig.target = {
    position = "RIGHT of player",
    x = 220,
    y = 0,
    width = 200,
    height = 50
}

_G.SUFconfig = SUFconfig
```

## Update TOC
Add to ShadowedUnitFrames.toc:
```
modules\cast.lua
modules\auras.lua
```

## Expected Outcome
- Total files: ~14
- Total size: ~600KB
