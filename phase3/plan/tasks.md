# Phase 3: Combat Fader (Optional)

## Goal
Add subtle combat fader for immersion.

## Tasks

### 3.1 Add Combat Fader
- [ ] Add back `modules/fader.lua`
- [ ] Hardcode fade settings:
  - Fade out duration: 0.5s
  - Fade in duration: 0.5s
  - Alpha: 0.8 in combat, 1.0 out of combat

### 3.2 Test
- [ ] Frames fade when entering combat
- [ ] Frames fade when leaving combat
- [ ] No visual glitches

## Config
```lua
SUFconfig.fader = {
  combat = { alpha = 0.8 },
  rest = { alpha = 1.0 },
  speed = 0.5
}
```

## Note
This is optional - Phase 1+2 is the MVP. Only add if doesn't impact performance.
