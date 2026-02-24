# SUF TBC Minimal - Development Progress

## Project Overview
**Goal:** Create lightweight, fast unit frames for WoW Classic TBC
**Repo:** https://github.com/cmartin007/shadowed-uf-tbc-minimal

---

## Progress by Phase

### Phase 1: Core MVP - Player + Target Frames
**Status:** IN PROGRESS

- [x] Strip options/ (240KB)
- [x] Strip media/ (600KB)
- [x] Strip localization (except enUS)
- [x] Remove 30+ unused modules
- [x] Add Config.lua (hardcoded positions)
- [x] Update TOC for minimal build
- [x] Add API docs
- [ ] Test addon loads in WoW
- [ ] Simplify units.lua (remove party/raid refs)
- [ ] Simplify main core

### Phase 2: Cast Bar + Auras
**Status:** NOT STARTED

- [ ] Add cast bar module
- [ ] Add simplified aura display
- [ ] Test in WoW
- [ ] Review & Approve

### Phase 3: Combat Fader (Optional)
**Status:** NOT STARTED

- [ ] Add combat fader
- [ ] Performance test
- [ ] Review & Approve

---

## Current Build Stats

| Metric | Value |
|--------|-------|
| Files | 14 |
| Modules | 8 |
| Size | ~2.4MB |
| TOC Version | 1.0.0 |

---

## Latest Commit
`8cef666` - Add Phase 1 changes log

---

## What's Working
- Core files retained: units, layout, health, power, movers, defaultlayout, helpers, basecombopoints

## What's Broken
- Needs testing in WoW
- units.lua still has party/raid code that needs stripping

## Next Action
Test addon loading in WoW, then simplify units.lua

---

## Changelog

### 2026-02-24
- Phase 1: Stripped 30+ modules, options, media
- Added Config.lua with hardcoded positions
- Added API reference docs
- Added development rules
