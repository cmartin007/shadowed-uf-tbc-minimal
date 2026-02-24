-- SUF TBC Minimal - Hardcoded Config
-- Target: WoW Classic Anniversary TBC. No options menu - all settings are hardcoded.

local _, SUF = ...
local SUFconfig = {}

-- Player Frame (Bottom Center)
SUFconfig.player = {
    anchor = "BOTTOM",
    x = 0,
    y = 200,
    width = 200,
    height = 50,
    healthColor = { r = 0.2, g = 0.8, b = 0.2 }, -- Green
    powerColor = "class", -- Class color
    showPower = true,
    showHealth = true,
    healthOrientation = "RIGHT",
    powerOrientation = "RIGHT"
}

-- Target Frame (Right of Player)
SUFconfig.target = {
    anchor = "LEFT", -- Relative to player
    x = 220,
    y = 0,
    width = 200,
    height = 50,
    healthColor = { r = 0.2, g = 0.8, b = 0.2 }, -- Green
    powerColor = "class",
    showPower = true,
    showHealth = true,
    healthOrientation = "RIGHT",
    powerOrientation = "RIGHT"
}

-- Frame Settings
SUFconfig.frames = {
    player = true,
    target = true,
    focus = false,
    pet = false,
    party = false,
    raid = false,
    arena = false,
    boss = false,
    nastier = false
}

-- Combat Fader (Disabled by default for speed)
SUFconfig.fader = {
    enabled = false
}

_G.SUFconfig = SUFconfig
