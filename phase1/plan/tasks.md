# Phase 1: Core MVP - Player + Target Frames

## Goal
Get basic Player and Target unit frames working with health and power bars.

## Tasks

### 1.1 Strip Non-Essential Files
- [ ] Remove `options/` directory (240KB config UI)
- [ ] Remove `localization/` except enUS
- [ ] Remove `media/` (use WoW defaults)
- [ ] Remove unused modules

### 1.2 Simplify Main Core
- [ ] Analyze `ShadowedUnitFrames.lua` - strip unused functions
- [ ] Remove LibStub dependencies if possible
- [ ] Simplify initialization

### 1.3 Simplify Units Module
- [ ] Strip `units.lua` to only player + target
- [ ] Remove party/raid/arena/boss/pet focus references

### 1.4 Layout and Positions
- [x] Layout lives in **modules/defaultlayout.lua** (single source for all users; see RULES.md §8)
- [x] Player frame position: `config.positions.player` in defaultlayout.lua (e.g. CENTER UIParent, x/y offsets)
- [x] Target frame position: `config.positions.target` (e.g. anchorTo `#SUFUnitplayer`, x = 50)
- _Note: Config.lua exists but is not used at runtime; defaultlayout.lua is the source of truth._

### 1.5 Test Basic Functionality
- [ ] Load in WoW - player frame appears
- [ ] Load in WoW - target frame appears
- [ ] Health bar updates correctly
- [ ] Power bar updates correctly

## Hardcoded Defaults
```
Player:  200x50px, Bottom center, y+200
Target:  200x50px, Right of player, x+220
Colors:  Health=Green, Power=Class
```

## Dependencies Required
- WoW API
- LibStub (optional - remove if possible)
