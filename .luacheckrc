-- Luacheck config for Shadowed Unit Frames TBC Minimal (WoW addon).
-- WoW provides many globals at runtime; declare them so luacheck doesn't warn.

std = "lua51"
max_line_length = 400

-- Writable globals (addon namespace, slash commands, etc.)
globals = {
    "ShadowUF", "SUFconfig", "CONFIGMODE_CALLBACKS", "_G",
    "SLASH_SHADOWEDUF1", "SLASH_SHADOWEDUF2", "SLASH_SHADOWEDUF3", "SLASH_SHADOWEDUF4",
    "SlashCmdList", "ClickCastFrames",
}

-- Read-only globals provided by WoW client at runtime
read_globals = {
    -- Unit / API
    "UnitClass", "UnitRace", "UnitHealth", "UnitHealthMax", "UnitPower", "UnitPowerMax",
    "UnitPowerType", "UnitName", "UnitExists", "UnitIsUnit", "UnitTarget", "UnitAura",
    "UnitBuff", "UnitDebuff", "UnitCastingInfo", "UnitChannelInfo", "UnitIsAFK", "UnitIsConnected",
    "UnitIsFriend", "UnitIsPlayer", "UnitLevel", "UnitClassification", "UnitReaction",
    "UnitHasVehicleUI", "UnitHasVehiclePlayerFrameUI", "GetTime", "GetBuildInfo",
    "CreateFrame", "RegisterEvent", "UIParent", "InCombatLockdown",
    "PlayerFrame", "TargetFrame", "PetFrame", "FocusFrame", "PartyFrame",
    "PlayerCastingBarFrame", "PetCastingBarFrame", "BuffFrame", "DebuffFrame",
    "RuneFrame", "WarlockPowerFrame", "MonkHarmonyBarFrame", "PaladinPowerBarFrame",
    "MageArcaneChargesFrame", "EssencePlayerFrame", "ComboFrame", "TargetFrameToT",
    "FocusFrameToT", "AlternatePowerBar", "PlayerPowerBarAlt",
    "BossTargetFrameContainer", "CompactPartyFrame", "CompactRaidFrameManager",
    "CompactRaidFrameContainer", "CompactRaidFrameManager_GetSetting", "CompactRaidFrameManager_SetSetting",
    "ArenaEnemyFramesContainer", "ArenaEnemyPrepFramesContainer", "ArenaEnemyMatchFramesContainer",
    "GameTooltip", "UnitFrame_OnEnter", "UnitFrame_OnLeave",
    "RAID_CLASS_COLORS", "CLASS_SORT_ORDER", "LOCALIZED_CLASS_NAMES_MALE",
    "MAX_COMBO_POINTS", "MAX_PARTY_MEMBERS", "MAX_RAID_MEMBERS", "MAX_BOSS_FRAMES",
    "MEMBERS_PER_RAID_GROUP", "GetMaxLevelForPlayerExpansion", "PET_TYPE_SUFFIX",
    "SecureButton_GetModifiedUnit", "SecureHandler_OnLoad", "ClickCastHeader",
    "hooksecurefunc", "DebuffTypeColor", "BackdropTemplateMixin",
    "C_AddOns", "Enum", "IsPlayerSpell", "IsSpellKnown",
    "RegisterUnitWatch", "UnregisterUnitWatch", "RegisterStateDriver",
    "IsInInstance", "CanHearthAndResurrectFromArea", "GetNumArenaOpponentSpecs",
    "UnitIsDeadOrGhost", "DEFAULT_CHAT_FRAME", "time",
    "CopyTable", "LibStub", "UnitGUID", "C_Timer", "GetArenaOpponentSpec",
    "UnitThreatSituation", "UnitPlayerControlled", "UnitIsTapDenied", "UnitCanAttack",
    "UnitPlayerOrPetInRaid", "UnitPlayerOrPetInParty", "AuraUtil", "C_UnitAuras",
    "GetLocale", "GetSpecializationInfoByID", "format", "pairs", "ipairs", "select", "type", "tostring",
    "next", "rawget", "rawset", "setmetatable", "getmetatable", "error", "pcall",
    "table", "string", "math", "print", "_G",
}

-- Allow unused args in callbacks (common in WoW addons)
ignore = {
    "212",  -- unused argument
    "213",  -- unused loop variable
}
