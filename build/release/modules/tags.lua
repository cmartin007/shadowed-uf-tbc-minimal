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

-- Resolve a single tag for unit (TBC API only). Returns string.
local function resolveTag(unit, tag)
    if not unit or not UnitExists(unit) then return "" end
    -- Normalize: strip whitespace and all parentheses (handles [(()afk())], [level()], etc.)
    local t = tag:lower():gsub("%s+", ""):gsub("[%(%)]", "")
    if t == "name" then
        return UnitName(unit) or ""
    elseif t == "curhp" then
        return tostring(UnitHealth(unit) or 0)
    elseif t == "curmaxhp" then
        local c, m = UnitHealth(unit), UnitHealthMax(unit)
        return (tostring(c or 0) .. "/" .. tostring(m or 0))
    elseif t == "perhp" or t == "perchp" then
        local c, m = UnitHealth(unit), UnitHealthMax(unit)
        if m and m > 0 then return tostring(math.floor((c or 0) / m * 100)) .. "%" end
        return "0%"
    elseif t == "curpp" then
        return tostring(UnitPower(unit) or 0)
    elseif t == "curmaxpp" then
        local c, m = UnitPower(unit), UnitPowerMax(unit)
        return (tostring(c or 0) .. "/" .. tostring(m or 0))
    elseif t == "perpp" or t == "percpp" then
        local c, m = UnitPower(unit), UnitPowerMax(unit)
        if m and m > 0 then return tostring(math.floor((c or 0) / m * 100)) .. "%" end
        return "0%"
    elseif t == "level" then
        local l = UnitLevel(unit)
        return (l and l > 0) and tostring(l) or "?"
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
        if c == "rareelite" then return "Rare Elite" end
        if c == "worldboss" then return "Boss" end
        return (c:sub(1, 1):upper() .. c:sub(2))
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
end

function Tags:Unregister(fontString) end

ShadowUF.Tags = Tags
