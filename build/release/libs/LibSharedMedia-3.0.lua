-- LibSharedMedia-3.0
local LibSharedMedia = LibStub:NewLibrary("LibSharedMedia-3.0", 1)
if not LibSharedMedia then return end

LibSharedMedia.MediaType = {
    STATUSBAR = "statusbar",
    BORDER = "border",
    BACKGROUND = "background",
    FONT = "font",
    SOUND = "sound"
}

-- TBC Anniversary: use built-in paths only (no addon media folder). Fetch() must return these when key missing.
local T = LibSharedMedia.MediaType
LibSharedMedia.MediaList = {
    [T.STATUSBAR]  = { Blizzard = "Interface\\TargetingFrame\\UI-StatusBar", Default = "Interface\\TargetingFrame\\UI-StatusBar" },
    [T.BORDER]     = { Blizzard = "Interface\\Tooltips\\UI-Tooltip-Border", Default = "Interface\\Tooltips\\UI-Tooltip-Border" },
    [T.BACKGROUND] = { Blizzard = "Interface\\ChatFrame\\ChatFrameBackground", Default = "Interface\\ChatFrame\\ChatFrameBackground" },
    [T.FONT]      = { Blizzard = "Fonts\\FRIZQT__.ttf", Default = "Fonts\\FRIZQT__.ttf" },
    [T.SOUND]     = { Blizzard = "Sound\\Spells\\AuctionWindowOpen.ogg", Default = "Sound\\Spells\\AuctionWindowOpen.ogg" },
}

function LibSharedMedia:Register(mediatype, name, path, lang)
    if not self.MediaType[mediatype] then return end
    if not self.MediaList[mediatype] then
        self.MediaList[mediatype] = {}
    end
    -- TBC minimal: addon media folder was removed; redirect addon paths to Blizzard built-in
    local fallback = self.MediaList[mediatype].Blizzard
    if path and path:find("ShadowedUnitFrames\\media") and fallback then
        path = fallback
    end
    self.MediaList[mediatype][name] = path
end

function LibSharedMedia:Fetch(mediatype, key)
    if not self.MediaList[mediatype] then
        return nil
    end
    return self.MediaList[mediatype][key] or self.MediaList[mediatype]["Blizzard"]
end

function LibSharedMedia:IsValid(mediatype, key)
    if not self.MediaList[mediatype] then return false end
    return self.MediaList[mediatype][key] ~= nil
end

-- Stub so layout.lua LoadSML can call SML.RegisterCallback without error
function LibSharedMedia:RegisterCallback(handler, event, method)
end

function LibSharedMedia:UnregisterCallback(handler, event)
end
