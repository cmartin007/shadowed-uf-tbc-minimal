-- LibStub.lua - Minimal stub for loading
local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2
local LibStub = {}
LibStub.minor = LIBSTUB_MINOR

function LibStub:NewLibrary(major, minor)
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

LibStub.objects = {}
-- LibStub("Major", true) = get library (silent); LibStub("Major", minor) = new library (minor = number)
setmetatable(LibStub, {
    __call = function(self, major, arg2)
        if type(arg2) == "boolean" then
            return self:GetLibrary(major, arg2)
        end
        return self:NewLibrary(major, arg2)
    end
})

_G.LibStub = LibStub
