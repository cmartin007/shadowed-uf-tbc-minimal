# Phase 3 Build - Combat Fader

## Add File
```bash
cp ../backup/modules/fader.lua modules/
```

## Hardcode Config
Append to `Config.lua`:
```lua
SUFconfig.fader = {
    enabled = true,
    combatAlpha = 0.8,
    restAlpha = 1.0,
    fadeSpeed = 0.5,
    useOOCFade = true,
    useCombatFade = true
}
```

## Update TOC
Add to ShadowedUnitFrames.toc:
```
modules\fader.lua
```

## Performance Check
⚠️ Must verify:
- [ ] No CPU spike during fade
- [ ] Smooth transitions
- [ ] < 0.5% CPU total

## Note
If performance impact > 1%, disable this feature.
