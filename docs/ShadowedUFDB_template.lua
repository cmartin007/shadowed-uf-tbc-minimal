--[[
  ShadowedUFDB profile template (TBC Minimal)
  SavedVariables name: ShadowedUFDB
  This file is a REFERENCE only. WoW saves the real DB under WTF/Account/.../SavedVariables/ShadowedUFDB.lua
  Use this to see the structure for player/target text (tags), positions, bars, font, and colors.
]]

-- Single profile (AceDB-3.0 may wrap this in .profiles["Default"] and .global)
local profile = {
  locked = true,
  loadedLayout = true,

  -- Frame positions (anchorTo, point, relativePoint, x, y). anchorTo can be "#SUFUnitplayer", "#SUFUnittarget", "UIParent".
  positions = {
    player = { point = "TOPLEFT", relativePoint = "TOPLEFT", anchorPoint = "TL", anchorTo = "UIParent", x = 20, y = -25 },
    target = { point = "TOPLEFT", relativePoint = "TOPRIGHT", anchorPoint = "RC", anchorTo = "#SUFUnitplayer", x = 50, y = 0 },
  },

  -- Bar appearance (texture uses LibSharedMedia; minimal build uses built-in only)
  bars = {
    texture = "Blizzard",
    spacing = -1.25,
    alpha = 1.0,
    backgroundAlpha = 0.20,
  },

  -- Font for tag text (name, level, health, etc.)
  font = {
    name = "Fonts\\FRIZQT__.ttf",
    size = 11,
    extra = "",
    color = { r = 1, g = 1, b = 1, a = 1 },
    shadowColor = { r = 0, g = 0, b = 0, a = 1 },
    shadowX = 1.0,
    shadowY = -1.0,
  },

  -- Frame backdrop
  backdrop = {
    tileSize = 1,
    edgeSize = 5,
    inset = 3,
    backgroundTexture = "Interface\\ChatFrame\\ChatFrameBackground",
    backgroundColor = { r = 0, g = 0, b = 0, a = 0.80 },
    borderTexture = "Interface\\Tooltips\\UI-Tooltip-Border",
    borderColor = { r = 0.30, g = 0.30, b = 0.50, a = 1 },
  },

  -- Which Blizzard frames to hide
  hidden = {
    player = true,
    target = true,
    pet = true,
    party = true,
    raid = false,
    cast = false,
    buffs = false,
    focus = true,
    boss = true,
    arena = true,
    playerPower = true,
    playerAltPower = false,
  },

  visibility = { arena = {}, pvp = {}, party = {}, raid = {}, neighborhood = {} },

  -- Unit config: enabled, size, bars, and TEXT (tag strings). Only player + target used in minimal build.
  units = {
    player = {
      enabled = true,
      width = 200,
      height = 50,
      scale = 1.0,
      healthBar = { enabled = true },
      powerBar = { enabled = true },
      emptyBar = { enabled = false },
      -- text = array of rows; each row: .text = tag string, .anchorTo = "$healthBar" or "$powerBar", .enabled, .width, .x, .y, .anchorPoint, .size
      text = {
        { enabled = true, name = "Left text",  text = "[name]",      anchorPoint = "CLI", anchorTo = "$healthBar", width = 0.50, size = 0, x = 3,  y = 0, default = true },
        { enabled = true, name = "Right text", text = "[curmaxhp]", anchorPoint = "CRI", anchorTo = "$healthBar", width = 0.60, size = 0, x = -3, y = 0, default = true },
        { enabled = true, name = "Left text",  text = "[level] [class]", anchorPoint = "CLI", anchorTo = "$powerBar", width = 0.50, size = 0, x = 3,  y = 0, default = true },
        { enabled = true, name = "Right text", text = "[curmaxpp]", anchorPoint = "CRI", anchorTo = "$powerBar", width = 0.60, size = 0, x = -3, y = 0, default = true },
        { enabled = true, name = "Left text",  text = "", anchorTo = "$emptyBar", anchorPoint = "CLI", width = 0.50, size = 0, x = 3,  y = 0, default = true },
        { enabled = true, name = "Right text", text = "", anchorTo = "$emptyBar", anchorPoint = "CRI", width = 0.60, size = 0, x = -3, y = 0, default = true },
      },
      indicators = { raidTarget = { enabled = true, size = 0 }, status = { enabled = true, size = 19 } },
    },
    target = {
      enabled = true,
      width = 200,
      height = 50,
      scale = 1.0,
      healthBar = { enabled = true },
      powerBar = { enabled = true },
      emptyBar = { enabled = false },
      text = {
        { enabled = true, name = "Left text",  text = "[name]",      anchorPoint = "CLI", anchorTo = "$healthBar", width = 0.50, size = 0, x = 3,  y = 0, default = true },
        { enabled = true, name = "Right text", text = "[curmaxhp]", anchorPoint = "CRI", anchorTo = "$healthBar", width = 0.60, size = 0, x = -3, y = 0, default = true },
        { enabled = true, name = "Left text",  text = "[level] [class]", anchorPoint = "CLI", anchorTo = "$powerBar", width = 0.50, size = 0, x = 3,  y = 0, default = true },
        { enabled = true, name = "Right text", text = "[curmaxpp]", anchorPoint = "CRI", anchorTo = "$powerBar", width = 0.60, size = 0, x = -3, y = 0, default = true },
        { enabled = true, name = "Left text",  text = "", anchorTo = "$emptyBar", anchorPoint = "CLI", width = 0.50, size = 0, x = 3,  y = 0, default = true },
        { enabled = true, name = "Right text", text = "", anchorTo = "$emptyBar", anchorPoint = "CRI", width = 0.60, size = 0, x = -3, y = 0, default = true },
      },
      indicators = { raidTarget = { enabled = true, size = 0 }, class = { enabled = false, size = 19 } },
    },
  },

  -- Colors (used by health/power bars and tags)
  healthColors = {
    red = { r = 0.90, g = 0, b = 0 },
    green = { r = 0.20, g = 0.90, b = 0.20 },
    yellow = { r = 0.93, g = 0.93, b = 0 },
    offline = { r = 0.50, g = 0.50, b = 0.50 },
    aggro = { r = 0.90, g = 0, b = 0 },
    tapped = { r = 0.5, g = 0.5, b = 0.5 },
    hostile = { r = 0.90, g = 0, b = 0 },
    friendly = { r = 0.20, g = 0.90, b = 0.20 },
    neutral = { r = 0.93, g = 0.93, b = 0 },
    static = { r = 0.70, g = 0.20, b = 0.90 },
    inc = { r = 0, g = 0.35, b = 0.23 },
    incAbsorb = { r = 0.93, g = 0.75, b = 0.09 },
    healAbsorb = { r = 0.68, g = 0.47, b = 1 },
    enemyUnattack = { r = 0.60, g = 0.20, b = 0.20 },
  },
  powerColors = {
    MANA = { r = 0.30, g = 0.50, b = 0.85 },
    RAGE = { r = 0.90, g = 0.20, b = 0.30 },
    FOCUS = { r = 1.0, g = 0.50, b = 0.25 },
    ENERGY = { r = 1.0, g = 0.85, b = 0.10 },
    RUNIC_POWER = { r = 0.35, g = 0.45, b = 0.60 },
    COMBOPOINTS = { r = 1.0, g = 0.80, b = 0.0 },
  },
  classColors = {
    WARRIOR = { r = 0.78, g = 0.61, b = 0.43 },
    PALADIN = { r = 0.96, g = 0.55, b = 0.73 },
    HUNTER = { r = 0.67, g = 0.83, b = 0.45 },
    ROGUE = { r = 1.0, g = 0.96, b = 0.41 },
    PRIEST = { r = 1.0, g = 1.0, b = 1.0 },
    SHAMAN = { r = 0.14, g = 0.35, b = 1.0 },
    MAGE = { r = 0.41, g = 0.80, b = 0.94 },
    WARLOCK = { r = 0.58, g = 0.51, b = 0.79 },
    DRUID = { r = 1.0, g = 0.49, b = 0.04 },
  },
}

--[[
  Supported tag strings in .text[].text (TBC Minimal, modules/tags.lua):
  [name]       Unit name
  [curhp]      Current health
  [curmaxhp]   Current / max health
  [perhp]      Health %
  [curpp]      Current power
  [curmaxpp]   Current / max power
  [perpp]      Power %
  [level]      Level (or "?")
  [class]      Class name
  [race]       Race name
  [afk]        "AFK" or ""

  Example: "[name]" or "[level] [class]" or "[curmaxhp]"
]]

return profile
