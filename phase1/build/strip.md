# Phase 1 Build - Strip & Core

## Commands

### Strip Files
```bash
# Remove options (240KB)
rm -rf options/

# Remove localization except enUS
rm localization/deDE.lua
rm localization/esES.lua
rm localization/esMX.lua
rm localization/frFR.lua
rm localization/koKR.lua
rm localization/ptBR.lua
rm localization/ruRU.lua
rm localization/zhCN.lua
rm localization/zhTW.lua

# Remove media (use WoW defaults)
rm -rf media/
```

### Modules to Remove (not needed for P+T)
```bash
rm modules/altpower.lua
rm modules/arcanecharges.lua
rm modules/auraindicators.lua
rm modules/aurapoints.lua
rm modules/auras.lua
rm modules/chi.lua
rm modules/combat_text.lua
rm modules/combopoints.lua
rm modules/druid.lua
rm modules/empty.lua
rm modules/essence.lua
rm modules/fader.lua
rm modules/healabsorb.lua
rm modules/highlight.lua
rm modules/holypower.lua
rm modules/incabsorb.lua
rm modules/incheal.lua
rm modules/indicators.lua
rm modules/monkstagger.lua
rm modules/portrait.lua
rm modules/range.lua
rm modules/runes.lua
rm modules/shaman.lua
rm modules/soulshards.lua
rm modules/tags.lua
rm modules/totems.lua
rm modules/xp.lua
```

### Keep Only
- ShadowedUnitFrames.lua
- ShadowedUnitFrames.toc
- ShadowedUnitFrames.xml
- modules/units.lua
- modules/layout.lua
- modules/health.lua
- modules/power.lua
- modules/basecombopoints.lua
- modules/defaultlayout.lua
- modules/movers.lua
- modules/helpers.lua
- localization/enUS.lua

## Expected Outcome
- ~10 files remaining
- ~500KB total
