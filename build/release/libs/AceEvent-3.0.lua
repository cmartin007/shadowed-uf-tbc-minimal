-- AceEvent-3.0 stub
local AceEvent = {}
AceEvent.events = {}

function AceEvent:RegisterMessage(msg, handler)
    self.events[msg] = handler
end

function AceEvent:UnregisterMessage(msg)
    self.events[msg] = nil
end

function AceEvent:SendMessage(msg, ...)
    local handler = self.events[msg]
    if handler then
        handler(...)
    end
end

function AceEvent:RegisterEvent(frame, event, handler)
    if type(frame) == "string" then
        return
    end
    frame:RegisterEvent(event)
end

_G.AceEvent = AceEvent
