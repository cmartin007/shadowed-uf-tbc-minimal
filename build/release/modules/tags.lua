-- Minimal Tags stub
local Tags = {}

-- Common tag functions - return basic values
local function GetTag(tag, unit)
    if tag == "power" then
        return UnitPower(unit) or 0
    elseif tag == "powerpercent" then
        local max = UnitPowerMax(unit)
        if max == 0 then return 0 end
        return floor(UnitPower(unit) / max * 100)
    elseif tag == "powerdeficit" then
        return UnitPowerMax(unit) - UnitPower(unit)
    elseif tag == "pp" then
        return floor(UnitPower(unit) / UnitPowerMax(unit) * 100)
    end
    return ""
end

Tags.GetTag = GetTag

-- Pre-cache some tags
function Tags:RegisterTranslations()
    -- No-op for minimal version
end

Tags.prototypes = {}

_G.ShadowUF.Tags = Tags
