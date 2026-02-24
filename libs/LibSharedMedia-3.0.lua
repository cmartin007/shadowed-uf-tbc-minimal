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

LibSharedMedia.MediaList = {
    [LibSharedMedia.MediaType.STATUSBAR] = {"Blizzard", "Default"},
    [LibSharedMedia.MediaType.BORDER] = {"Blizzard", "Default"},
    [LibSharedMedia.MediaType.BACKGROUND] = {"Blizzard", "Default"},
    [LibSharedMedia.MediaType.FONT] = {"Blizzard", "Default"},
    [LibSharedMedia.MediaType.SOUND] = {"Blizzard", "Default"}
}

function LibSharedMedia:Register(mediatype, name, path, lang)
    if not self.MediaType[mediatype] then return end
    if not self.MediaList[mediatype] then
        self.MediaList[mediatype] = {}
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
