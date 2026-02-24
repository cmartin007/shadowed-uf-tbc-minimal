-- CallbackHandler-1.0 - Minimal stub
local CallbackHandler = {}
CallbackHandler VERSION = 1

function CallbackHandler:OnUsed(target, eventname, handler)
    target[eventname] = handler
end

function CallbackHandler:OnUnused(target, eventname)
    target[eventname] = nil
end

local eventtarget = setmetatable({}, {__index = function(t, event) 
    local f = function() end
    t[event] = f
    return f
end})

_G.CallbackHandler_1.0 = function(name,RegisterDispatcher,OnUsed,OnUnused)
    return CallbackHandler
end
