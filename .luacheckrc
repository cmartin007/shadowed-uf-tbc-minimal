-- Luacheck configuration for SUF TBC Minimal
-- https://luacheck.readthedocs.io/

-- Define all WoW globals to suppress false positives
read_globals = {
    -- Unit APIs
    "UnitHealth", "UnitHealthMax", "UnitPower", "UnitPowerMax", "UnitPowerType",
    "UnitName", "UnitExists", "UnitIsUnit", "UnitReaction", "UnitTarget",
    "UnitCastingInfo", "UnitChannelInfo", "UnitAura", "GetAuraInfo",
    "CombatLogGetCurrentEvent", "UnitClassification", "UnitLevel",
    "UnitDebuff", "UnitBuff", "UnitGUID", "UnitIsPlayer", "UnitIsFriend",
    "UnitPlayerControlled", "UnitIsPVPSanctuary", "UnitIsDeadOrGhost",
    "UnitInVehicle", "UnitHasVehicleUI", "UnitUsingVehicle",
    "IsUnitOnQuest", "GetQuestsCompleted",
    
    -- Frame APIs  
    "CreateFrame", "SecureMixin", "Mixin", "RegisterStateDriver", "UnregisterStateDriver",
    "UIParent", "GameFontHighlight", "GameFontNormal", "GameFontHighlightSmall",
    "RegisterUnitWatch", "UnregisterUnitWatch",
    
    -- Spell/Item APIs
    "GetSpellInfo", "GetItemInfo", "GetItemIcon", "GetTexCoords", "GetActionInfo",
    "IsSpellKnown", "IsPlayerSpell",
    
    -- Timer APIs
    "C_Timer", "GetTime", "time",
    
    -- Math
    "floor", "ceil", "sqrt", "abs", "random", "math", "string", "table",
    
    -- Utility
    "tinsert", "tremove", "wipe", "pairs", "ipairs", "type", "tostring", "tonumber",
    "select", "strfind", "strsub", "strlower", "strupper", "gmatch", "gsub", "format",
    "date", "next", "pcall", "error",
    
    -- Ace/Lib
    "LibStub", "AceAddon", "AceGUI", "AceDB", "AceEvent", "AceHook",
    
    -- WoW globals
    "ChatFrame1", "DEFAULT_CHAT_FRAME", "UnitPopupMenus", "UIF",
    "InCombatLockdown", "HasVehicleUI",
    
    -- Constants
    "MAX_PARTY_MEMBERS", "MAX_RAID_MEMBERS", "MAX_BOSS_FRAMES", "MAX_ARENA_ENEMIES",
    "COMBATLOG_FILTER_ME", "COMBATLOG_FILTER_MY_PET", "COMBATLOG_FILTER_HOSTILE_PLAYERS",
    "LE_AURA_TYPE_BUFF", "LE_AURA_TYPE_DEBUFF",
    
    -- C_ APIs
    "C_UnitAuras", "C_Timer", "C_MountJournal", "C_Item", "C_Spell",
    "C_QuestLog", "C_Map", "C_News", "AuraUtil",
    "C_ArtifactUI", "C_AzeriteEmpoweredItem", "C_AzeriteItem",
    
    -- Build
    "GetBuildInfo", "GetBuildNumber",
    
    -- Instance
    "IsInInstance", "CanHearthAndResurrectFromArea",
    
    -- PvP
    "GetBattlefieldScore", "GetNumBattlefieldScores", "GetArenaOpponentSpec",
    "GetNumArenaOpponentSpecs",
    
    -- The addon global itself
    "ShadowUF", "ShadowedUF", "SUF",
}

-- Also allow setting these
write_globals = {
    "ShadowUF", "ShadowedUF", "SUF",
}

-- Files to ignore
exclude_files = {
    "test/",
    "docs/",
    "phase1/",
    "phase2/",
    "phase3/",
    "build/",
    "libs/",
}

-- Disable noisy warnings
disable = {
    "111", -- setting non-standard global
    "112", -- mutating non-standard global  
    "113", -- accessing undefined variable
    "122", -- globals accessed but not set
    "124", -- setting read-only global
    "211", -- unused function
    "212", -- unused function argument
    "213", -- unused loop variable
    "214", -- unused table field
    "215", -- unused
    "311", -- trailing whitespace
    "321", -- shadowing declaration
    "331", -- shadowing upvalue
    "411", -- shadowing global
    "421", -- shadowing
    "431", -- shadowing
    "432", -- shadowing
    "511", -- shadowing
    "521", -- shadowing
    "531", -- shadowing
    "581", -- shadowing a variable
    "631", -- line too long (WoW tables are long)
}

-- Don't limit line length for this project
max_line_length = false
