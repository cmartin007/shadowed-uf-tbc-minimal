-- AceDB-3.0 stub (register with LibStub so core can GetLibrary("AceDB-3.0"))
local AceDB = LibStub:NewLibrary("AceDB-3.0", 1)
if not AceDB then return end

AceDB.db = {}

function AceDB:New(name, default, db)
    -- Third arg can be true (use defaults) or an existing table; only use as instance if it's a table
    local instance = (type(db) == "table" and db) or {}
    setmetatable(instance, {__index = default or {}})
    self.db[name] = instance
    -- AceDB-3.0 db objects have RegisterCallback; stub it so core does not error
    if not instance.RegisterCallback then
        instance.RegisterCallback = function() end
    end
    return instance
end

function AceDB:RegisterNamespace(name, ns)
    return self:New(name, nil, ns or {})
end
