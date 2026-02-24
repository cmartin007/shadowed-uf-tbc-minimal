-- LibStub.lua
local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2
local LibStub = {}
LibStub.minor = LIBSTUB_MINOR
LibStub.objects = {}

function LibStub:NewLibrary(major, minor)
    -- Handle case where minor is not a number
    if type(minor) ~= "number" then
        minor = 1
    end
    
    if self.objects[major] and self.objects[major].minor >= minor then
        return self.objects[major].obj
    end
    local o = {}
    self.objects[major] = {major = major, minor = minor, obj = o}
    return o
end

function LibStub:GetLibrary(major, silent)
    if not self.objects[major] and not silent then
        error("Cannot find library instance of " .. major)
    end
    return self.objects[major] and self.objects[major].obj
end

function LibStub:IterateLibraries()
    return pairs(self.objects)
end

-- Pre-register common libraries
LibStub:NewLibrary("LibSharedMedia-3.0", 1)
LibStub:NewLibrary("LibDualSpec-1.0", 1)
LibStub:NewLibrary("LibSpellRange-1.0", 1)
LibStub:NewLibrary("AceGUI-3.0", 1)
LibStub:NewLibrary("AceDB-3.0", 1)
LibStub:NewLibrary("AceEvent-3.0", 1)
LibStub:NewLibrary("AceLocale-3.0", 1)

setmetatable(LibStub, {__call = LibStub.NewLibrary})
_G.LibStub = LibStub
