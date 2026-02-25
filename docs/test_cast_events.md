# Test cast events in your build

WoW chat has a **short line limit** (~255 chars). Use **one line per event** below—copy and run each line in order.

Run with ShadowedUnitFrames loaded for section 2.

## 1. Normal events (RegisterEvent)

One line per event. Each prints `EVENT_NAME OK` or `EVENT_NAME FAIL: ...`.

```
/run local f=CreateFrame("Frame") local e="UNIT_SPELLCAST_START" local ok,err=pcall(f.RegisterEvent,f,e) print(e,ok and "OK" or err) if ok then f:UnregisterEvent(e) end
```

```
/run local f=CreateFrame("Frame") local e="UNIT_SPELLCAST_STOP" local ok,err=pcall(f.RegisterEvent,f,e) print(e,ok and "OK" or err) if ok then f:UnregisterEvent(e) end
```

```
/run local f=CreateFrame("Frame") local e="UNIT_SPELLCAST_FAIL" local ok,err=pcall(f.RegisterEvent,f,e) print(e,ok and "OK" or err) if ok then f:UnregisterEvent(e) end
```

```
/run local f=CreateFrame("Frame") local e="UNIT_SPELLCAST_INTERRUPTED" local ok,err=pcall(f.RegisterEvent,f,e) print(e,ok and "OK" or err) if ok then f:UnregisterEvent(e) end
```

```
/run local f=CreateFrame("Frame") local e="UNIT_SPELLCAST_DELAYED" local ok,err=pcall(f.RegisterEvent,f,e) print(e,ok and "OK" or err) if ok then f:UnregisterEvent(e) end
```

```
/run local f=CreateFrame("Frame") local e="UNIT_SPELLCAST_CHANNEL_START" local ok,err=pcall(f.RegisterEvent,f,e) print(e,ok and "OK" or err) if ok then f:UnregisterEvent(e) end
```

```
/run local f=CreateFrame("Frame") local e="UNIT_SPELLCAST_CHANNEL_STOP" local ok,err=pcall(f.RegisterEvent,f,e) print(e,ok and "OK" or err) if ok then f:UnregisterEvent(e) end
```

```
/run local f=CreateFrame("Frame") local e="UNIT_SPELLCAST_CHANNEL_UPDATE" local ok,err=pcall(f.RegisterEvent,f,e) print(e,ok and "OK" or err) if ok then f:UnregisterEvent(e) end
```

## 2. Unit events (RegisterUnitEvent)

Same idea; needs SUF loaded. Each prints `EVENT_NAME unit OK` or `EVENT_NAME FAIL: ...`. If SUF is not loaded you get "Load SUF first".

```
/run local F=_G.SUFUnitplayer if not (F and F.RegisterUnitEvent) then print("Load SUF first") else local e="UNIT_SPELLCAST_START" local ok,err=pcall(F.RegisterUnitEvent,F,e,"player") print(e,ok and "unit OK" or err) if ok then F:UnregisterEvent(e) end end
```

```
/run local F=_G.SUFUnitplayer if not (F and F.RegisterUnitEvent) then print("Load SUF first") else local e="UNIT_SPELLCAST_STOP" local ok,err=pcall(F.RegisterUnitEvent,F,e,"player") print(e,ok and "unit OK" or err) if ok then F:UnregisterEvent(e) end end
```

```
/run local F=_G.SUFUnitplayer if not (F and F.RegisterUnitEvent) then print("Load SUF first") else local e="UNIT_SPELLCAST_FAIL" local ok,err=pcall(F.RegisterUnitEvent,F,e,"player") print(e,ok and "unit OK" or err) if ok then F:UnregisterEvent(e) end end
```

```
/run local F=_G.SUFUnitplayer if not (F and F.RegisterUnitEvent) then print("Load SUF first") else local e="UNIT_SPELLCAST_INTERRUPTED" local ok,err=pcall(F.RegisterUnitEvent,F,e,"player") print(e,ok and "unit OK" or err) if ok then F:UnregisterEvent(e) end end
```

```
/run local F=_G.SUFUnitplayer if not (F and F.RegisterUnitEvent) then print("Load SUF first") else local e="UNIT_SPELLCAST_DELAYED" local ok,err=pcall(F.RegisterUnitEvent,F,e,"player") print(e,ok and "unit OK" or err) if ok then F:UnregisterEvent(e) end end
```

```
/run local F=_G.SUFUnitplayer if not (F and F.RegisterUnitEvent) then print("Load SUF first") else local e="UNIT_SPELLCAST_CHANNEL_START" local ok,err=pcall(F.RegisterUnitEvent,F,e,"player") print(e,ok and "unit OK" or err) if ok then F:UnregisterEvent(e) end end
```

```
/run local F=_G.SUFUnitplayer if not (F and F.RegisterUnitEvent) then print("Load SUF first") else local e="UNIT_SPELLCAST_CHANNEL_STOP" local ok,err=pcall(F.RegisterUnitEvent,F,e,"player") print(e,ok and "unit OK" or err) if ok then F:UnregisterEvent(e) end end
```

```
/run local F=_G.SUFUnitplayer if not (F and F.RegisterUnitEvent) then print("Load SUF first") else local e="UNIT_SPELLCAST_CHANNEL_UPDATE" local ok,err=pcall(F.RegisterUnitEvent,F,e,"player") print(e,ok and "unit OK" or err) if ok then F:UnregisterEvent(e) end end
```

## How to use the results

- **Normal OK, unit FAIL:** Use `RegisterNormalEvent` and filter by `unit` in the handler (current approach).
- **Both OK:** You can use `RegisterUnitEvent` for that event.
- **Normal FAIL:** Event does not exist in this build; do not register it.

Add the output to this file or to `docs/API_REFERENCE.md` under a "Cast events (tested on TBC Anniversary)" section.

**TBC Anniversary (tested):** `UNIT_SPELLCAST_FAIL` does **not** exist—do not register it. `UNIT_SPELLCAST_INTERRUPTED` registers OK; the cast module uses it. Cast module registers: START, STOP, INTERRUPTED, DELAYED, CHANNEL_START, CHANNEL_STOP, CHANNEL_UPDATE.

### Tested results (TBC Anniversary, RegisterEvent)

| Event | Result |
|-------|--------|
| UNIT_SPELLCAST_START | OK |
| UNIT_SPELLCAST_STOP | OK |
| UNIT_SPELLCAST_FAIL | **Unknown event** — do not register |
| UNIT_SPELLCAST_INTERRUPTED | OK (cast module uses it for immediate bar hide on interrupt) |
| UNIT_SPELLCAST_DELAYED | OK |
| UNIT_SPELLCAST_CHANNEL_START | OK |
| UNIT_SPELLCAST_CHANNEL_STOP | OK |
| UNIT_SPELLCAST_CHANNEL_UPDATE | OK |

Cast module registers: START, STOP, INTERRUPTED, DELAYED, CHANNEL_START, CHANNEL_STOP, CHANNEL_UPDATE.
