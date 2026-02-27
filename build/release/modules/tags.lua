-- Minimal Tags for SUF TBC Minimal: powerMap + hardcoded tag parsing (TBC Anniversary only).
local Tags = {
    customEvents = {},
    powerMap = {
        [0] = "MANA", MANA = "MANA",
        [1] = "RAGE", RAGE = "RAGE",
        [2] = "FOCUS", FOCUS = "FOCUS",
        [3] = "ENERGY", ENERGY = "ENERGY",
    },
}

function Tags:FastRegister(frame, fontString) end
function Tags:FastUnregister(frame, fontString) end

-- Quest-style level-diff color (TBC): return WoW hex RRGGBB or nil for default. Grey = trivial (no XP), green = low, yellow = same, red = higher.
-- Grey threshold from Wowpedia: levels 1-5 grey=0; 6-39 grey=pl - floor(pl/10) - 5; 40-59 grey=pl - floor(pl/5) - 1; 60-70 grey=pl - 9.
local function getGreyLevel(playerLevel)
    if not playerLevel or playerLevel < 6 then return 0 end
    if playerLevel >= 60 then return playerLevel - 9 end
    if playerLevel >= 40 then return playerLevel - math.floor(playerLevel / 5) - 1 end
    return playerLevel - math.floor(playerLevel / 10) - 5
end
local function getLevelDiffColorHex(unitLevel, playerLevel)
    if not unitLevel or unitLevel < 1 or not playerLevel then return nil end
    local greyLevel = getGreyLevel(playerLevel)
    if unitLevel <= greyLevel then return "808080" end -- grey (no XP)
    if unitLevel < playerLevel then return "19ff19" end -- green (slightly lower)
    if unitLevel <= playerLevel + 2 then return "ffd100" end -- yellow (same-ish)
    return "ff1919" end -- red (much higher)

-- Short formatter for large values (e.g. 12345 -> 12.3k) for display.
local function formatShort(value)
    value = value or 0
    if value >= 1000000 then
        return string.format("%.1fm", value / 1000000):gsub("%.0m", "m")
    elseif value >= 10000 then -- 5+ digits -> use k
        return string.format("%.1fk", value / 1000):gsub("%.0k", "k")
    else
        return tostring(value)
    end
end

-- Resolve a single tag for unit (TBC API only). Returns string.
local function resolveTag(unit, tag)
    if not unit or not UnitExists(unit) then return "" end
    -- Normalize: strip whitespace and all parentheses (handles [(()afk())], [level()], etc.)
    local t = tag:lower():gsub("%s+", ""):gsub("[%(%)]", "")
    if t == "name" then
        return UnitName(unit) or ""
    elseif t == "curhp" then
        return formatShort(UnitHealth(unit) or 0)
    elseif t == "curmaxhp" then
        local c, m = UnitHealth(unit), UnitHealthMax(unit)
        return (formatShort(c or 0) .. "/" .. formatShort(m or 0))
    elseif t == "perhp" or t == "perchp" then
        local c, m = UnitHealth(unit), UnitHealthMax(unit)
        if m and m > 0 then return tostring(math.floor((c or 0) / m * 100)) .. "%" end
        return "0%"
    elseif t == "perhpyellow" then
        local c, m = UnitHealth(unit), UnitHealthMax(unit)
        if m and m > 0 then
            local pct = math.floor((c or 0) / m * 100)
            return ("|cffffd100%d%%|r"):format(pct)
        end
        return "|cffffd1000%|r"
    elseif t == "perhpclass" then
        local c, m = UnitHealth(unit), UnitHealthMax(unit)
        if not (m and m > 0) then return "0%" end
        local pct = math.floor((c or 0) / m * 100)

        local classToken = (unit == "pet") and "PET" or select(2, UnitClass(unit))
        local r, g, b = 1, 1, 1
        if ShadowUF and ShadowUF.db and ShadowUF.db.profile and ShadowUF.db.profile.classColors and classToken then
            local col = ShadowUF.db.profile.classColors[classToken]
            if col then r, g, b = col.r or r, col.g or g, col.b or b end
        end

        local function toHex(x)
            x = math.max(0, math.min(1, x or 0))
            return string.format("%02x", math.floor(x * 255 + 0.5))
        end

        local hex = toHex(r) .. toHex(g) .. toHex(b)
        return ("|cff%s%d%%|r"):format(hex, pct)
    elseif t == "curpp" then
        return tostring(UnitPower(unit) or 0)
    elseif t == "curmaxpp" then
        local c, m = UnitPower(unit), UnitPowerMax(unit)
        return (tostring(c or 0) .. "/" .. tostring(m or 0))
    elseif t == "perpp" or t == "percpp" then
        local c, m = UnitPower(unit), UnitPowerMax(unit)
        if m and m > 0 then return tostring(math.floor((c or 0) / m * 100)) .. "%" end
        return "0%"
    elseif t == "perppclass" then
        local c, m = UnitPower(unit), UnitPowerMax(unit)
        if not (m and m > 0) then return "0%" end
        local pct = math.floor((c or 0) / m * 100)

        local classToken = (unit == "pet") and "PET" or select(2, UnitClass(unit))
        local r, g, b = 1, 1, 1
        if ShadowUF and ShadowUF.db and ShadowUF.db.profile and ShadowUF.db.profile.classColors and classToken then
            local col = ShadowUF.db.profile.classColors[classToken]
            if col then r, g, b = col.r or r, col.g or g, col.b or b end
        end

        local function toHex(x)
            x = math.max(0, math.min(1, x or 0))
            return string.format("%02x", math.floor(x * 255 + 0.5))
        end

        local hex = toHex(r) .. toHex(g) .. toHex(b)
        return ("|cff%s%d%%|r"):format(hex, pct)
    elseif t == "perpppowercolor" then
        local c, m = UnitPower(unit), UnitPowerMax(unit)
        if not (m and m > 0) then return "0%" end
        local pct = math.floor((c or 0) / m * 100)

        local powerID, powerType, altR, altG, altB = UnitPowerType(unit)
        local token = Tags.powerMap[powerType] or Tags.powerMap[powerID] or powerType or "MANA"

        local r, g, b
        if ShadowUF and ShadowUF.db and ShadowUF.db.profile and ShadowUF.db.profile.powerColors then
            local col = ShadowUF.db.profile.powerColors[token]
            if col then r, g, b = col.r, col.g, col.b end
        end
        if not (r and g and b) then
            if altR then
                r, g, b = altR, altG, altB
            else
                local manaCol = ShadowUF and ShadowUF.db and ShadowUF.db.profile and ShadowUF.db.profile.powerColors and ShadowUF.db.profile.powerColors.MANA
                if manaCol then
                    r, g, b = manaCol.r, manaCol.g, manaCol.b
                else
                    r, g, b = 0.3, 0.5, 0.85
                end
            end
        end

        local function toHex(x)
            x = math.max(0, math.min(1, x or 0))
            return string.format("%02x", math.floor(x * 255 + 0.5))
        end

        local hex = toHex(r) .. toHex(g) .. toHex(b)
        return ("|cff%s%d%%|r"):format(hex, pct)
    elseif t == "level" then
        local l = UnitLevel(unit)
        local raw = (l and l > 0) and tostring(l) or "?"
        if unit == "player" then return raw end
        local playerLevel = UnitLevel("player")
        local hex = getLevelDiffColorHex(l and l > 0 and l or nil, playerLevel)
        if hex then return ("|cff%s%s|r"):format(hex, raw) end
        return raw
    elseif t == "class" then
        return select(2, UnitClass(unit)) or ""
    elseif t == "race" then
        return select(2, UnitRace(unit)) or ""
    elseif t == "afk" then
        -- TBC: UnitIsAFK is only valid for player and partyN; for target/focus/raid it can return true incorrectly
        if unit ~= "player" and not (unit and unit:match("^party%d+$")) then
            return ""
        end
        if UnitIsAFK and UnitIsAFK(unit) then return "AFK" end
        return ""
    elseif t == "combo" or t == "cp" then
        -- Simple combo point counter for cat/rogue: always read from player -> target
        if GetComboPoints then
            local points = GetComboPoints("player", "target")
            if points and points > 0 then
                return tostring(points)
            end
        end
        return ""
    elseif t == "classification" then
        local c = UnitClassification(unit)
        if not c or c == "normal" then return "" end

        local symbol
        if c == "rare" then
            symbol = "R"
        elseif c == "elite" then
            symbol = "+"
        elseif c == "rareelite" then
            symbol = "R+"
        elseif c == "worldboss" then
            symbol = "Boss"
        else
            symbol = ""
        end

        if symbol ~= "" then
            -- Always show classification in red
            return ("|cffff1919%s|r"):format(symbol)
        end
        return ""
    end
    return "[" .. tag .. "]"
end

-- Parse one bracket content: return tag name (normalized for lookup) and whether to add space after when non-empty.
-- Space after: [tag()], [tag( )], [tag ( )], or [tag ] (trailing/leading space).
local function parseBracket(raw)
    local wantSpaceAfter = not not (raw:match("%(%s*%)") or raw:match("%s+$") or raw:match("^%s+"))
    local name = raw:gsub("[%(%)]", ""):gsub("%s+", ""):lower()
    return name, wantSpaceAfter
end

-- Replace [tag] placeholders in s for unit. Spaces: [tag()], [tag( )], or [tag ] add space after value when non-empty.
local function formatTagString(unit, s)
    if not s or s == "" then return "" end
    local out = s:gsub("%[([%w%(%)%s]+)%]", function(raw)
        local tagName, wantSpaceAfter = parseBracket(raw)
        local result = resolveTag(unit, tagName)
        if result ~= "" and wantSpaceAfter then
            result = result .. " "
        end
        return result
    end)
    return out
end

function Tags:Register(frame, fontString, config)
    local tagString = (type(config) == "string") and config or (config and config.text) or ""
    fontString._suf_frame = frame
    fontString._suf_tagString = tagString

    fontString.UpdateTags = function(fontStr)
        local f = fontStr._suf_frame
        local unit = f and f.unit
        local text = formatTagString(unit, fontStr._suf_tagString or "")
        -- Set font before SetText to avoid taint (RULES: font must be set first)
        if not fontStr:GetFont() then
            local path = "Fonts\\FRIZQT__.ttf"
            local size = 12
            if ShadowUF and ShadowUF.Layout and ShadowUF.Layout.mediaPath then
                path = ShadowUF.Layout.mediaPath.font or path
            end
            if ShadowUF and ShadowUF.db and ShadowUF.db.profile and ShadowUF.db.profile.font then
                local sz = ShadowUF.db.profile.font.size
                if sz and sz > 0 then size = sz end
            end
            fontStr:SetFont(path, size, ShadowUF and ShadowUF.db and ShadowUF.db.profile and ShadowUF.db.profile.font and ShadowUF.db.profile.font.extra or "")
        end
        local ok, err = pcall(fontStr.SetText, fontStr, text)
        if not ok and err and not err:match("Font not set") then
            geterrorhandler()(err)
        end
    end

    -- Event-driven updates for health/power tags so text changes when values do.
    -- We keep a FullUpdate hook via RegisterUpdateFunc, but also listen to specific
    -- UNIT_* events for cheaper and more responsive updates.
    if frame and frame.RegisterUnitEvent and tagString and tagString ~= "" then
        local lower = tagString:lower()
        local needsHealth = lower:find("curhp", 1, true)
            or lower:find("curmaxhp", 1, true)
            or lower:find("perhp", 1, true)
            or lower:find("perchp", 1, true)
        local needsPower = lower:find("curpp", 1, true)
            or lower:find("curmaxpp", 1, true)
            or lower:find("perpp", 1, true)
            or lower:find("percpp", 1, true)

        if needsHealth then
            frame:RegisterUnitEvent("UNIT_HEALTH", fontString, "UpdateTags")
            frame:RegisterUnitEvent("UNIT_MAXHEALTH", fontString, "UpdateTags")
            frame:RegisterUnitEvent("UNIT_CONNECTION", fontString, "UpdateTags")
        end

        if needsPower then
            -- TBC-safe power events: use generic power events only
            frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", fontString, "UpdateTags")
            frame:RegisterUnitEvent("UNIT_MAXPOWER", fontString, "UpdateTags")
            frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", fontString, "UpdateTags")
        end
    end
end

function Tags:Unregister(fontString)
    if not fontString then return end
    local frame = fontString._suf_frame
    if frame and frame.UnregisterAll then
        frame:UnregisterAll(fontString)
    end
    fontString._suf_frame = nil
    fontString._suf_tagString = nil
end

ShadowUF.Tags = Tags
