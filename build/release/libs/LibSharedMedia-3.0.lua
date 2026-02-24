-- LibSharedMedia-3.0 - Minimal stub
local lib = {}
lib.LSM = lib

function lib:Register(event, mediatype, key, path)
    -- Stub - don't register anything
end

function lib:Fetch(mediatype, key, texture)
    return texture or "Interface\\Icons\\INV_Misc_QuestionMark"
end

_G.LibStub = _G.LibStub or {}
setmetatable(lib.LSM, {__call = function(self, ...) return self end})
