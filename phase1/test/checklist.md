# Phase 1 Test Checklist

## WoW Classic Anniversary TBC Testing

### Load Test
- [ ] Addon loads without errors
- [ ] No Lua errors on login
- [ ] No missing texture warnings

### Player Frame Test
- [ ] Player frame appears on login
- [ ] Health bar shows correct health %
- [ ] Health bar color is green
- [ ] Power bar shows correct power %
- [ ] Power bar shows correct power type (mana/rage/energy)
- [ ] Frame is positioned correctly (per defaultlayout.lua `config.positions.player`)
- [ ] Frame size is correct (per defaultlayout.lua; e.g. 190x45)

### Target Frame Test
- [ ] Target frame appears when targeting NPC/mob
- [ ] Target frame appears when targeting player
- [ ] Health bar shows correct health %
- [ ] Health bar color is green
- [ ] Power bar shows correct power %
- [ ] Target name displays correctly
- [ ] Frame is positioned correctly (per defaultlayout.lua `config.positions.target`, right of player)
- [ ] Frame size is correct (per defaultlayout.lua; e.g. 190x45)

### Combat Test
- [ ] Health bar updates during combat
- [ ] Power bar drains correctly

### Target Switch Test
- [ ] Frame updates when switching targets
- [ ] Name updates correctly

## Performance
- [ ] No frame lag
- [ ] CPU usage < 1%
- [ ] Memory usage < 5MB

## Bugs Found
_Record any issues here:_
