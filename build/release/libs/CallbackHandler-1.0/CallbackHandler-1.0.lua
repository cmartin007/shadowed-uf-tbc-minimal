-- CallbackHandler-1.0
local MAJOR, MINOR = "CallbackHandler-1.0", 1

local Callbacks = {}
Callbacks.handlers = {}

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Player logged in
    end
end)

function Callbacks:Register(event, handler)
    self.handlers[event] = handler
end

function Callbacks:Fire(event, ...)
    local handler = self.handlers[event]
    if handler then
        handler(...)
    end
end

function Callbacks:Unregister(event)
    self.handlers[event] = nil
end

_G.CallbackHandler_1.0 = Callbacks
