-- AceDB-3.0 stub
local AceDB = {}
AceDB.db = {}

function AceDB:New(name, default, db)
    local db = db or {}
    setmetatable(db, {__index = default or {}})
    self.db[name] = db
    return db
end

function AceDB:RegisterNamespace(name, db)
    return self:New(name, nil, db)
end

_G.AceDB = AceDB
_G.AceDB-3.0 = AceDB
