-- Range fader: fades unit frames when the unit is out of range.
-- Friendly units: UnitInRange (40 yd heal/buff range).
-- Hostile units: IsSpellInRange with a per-class max-range attack spell.
-- Polls on a shared 0.5 s throttle (no range-change event in TBC).
local Range = {}
ShadowUF:RegisterModule(Range, "range", ShadowUF.L["Range fader"])

local POLL_INTERVAL = 0.5

-- Longest-range attack spell per class for hostile range checks.
-- IsSpellInRange returns 1 (in range), 0 (OOR), nil (unknown/unlearned/wrong target).
-- nil is treated as in-range so unlearned spells never cause false fading.
local CLASS_RANGE_SPELL = {
	DRUID   = "Wrath",
	MAGE    = "Fireball",
	WARLOCK = "Shadow Bolt",
	PRIEST  = "Smite",
	SHAMAN  = "Lightning Bolt",
	HUNTER  = "Arcane Shot",
	PALADIN = "Exorcism",
	-- WARRIOR and ROGUE have no meaningful ranged spells; hostile range check skipped
}

local playerClass = select(2, UnitClass("player"))
local hostileRangeSpell = CLASS_RANGE_SPELL[playerClass]

local updater
local activeFrames = {}

local function isInRange(frame)
	if not UnitExists(frame.unit) then return true end
	if UnitIsUnit(frame.unit, "player") then return true end
	if UnitIsFriend("player", frame.unit) then
		-- UnitInRange only works for party*/raid* tokens; returns false for "target" even when adjacent
		if frame.unit:match("^party%d") or frame.unit:match("^raid%d") then
			return UnitInRange(frame.unit) ~= false
		end
		return true
	else
		-- IsSpellInRange: 1 = in range, 0 = OOR, nil = unlearned/N/A (treat as in-range)
		if not hostileRangeSpell then return true end
		return IsSpellInRange(hostileRangeSpell, frame.unit) ~= 0
	end
end

local function startUpdater()
	if updater then return end
	updater = CreateFrame("Frame", nil, UIParent)
	local elapsed = 0
	updater:SetScript("OnUpdate", function(_, dt)
		elapsed = elapsed + dt
		if elapsed < POLL_INTERVAL then return end
		elapsed = 0
		for frame in pairs(activeFrames) do
			local cfg = ShadowUF.db.profile.units[frame.unitType] and ShadowUF.db.profile.units[frame.unitType].range
			if cfg and frame.unit then
				local alpha = isInRange(frame) and (cfg.inAlpha or 1.0) or (cfg.oorAlpha or 0.4)
				frame:SetRangeAlpha(alpha)
			end
		end
	end)
end

local function stopUpdater()
	if not next(activeFrames) and updater then
		updater:SetScript("OnUpdate", nil)
		updater = nil
	end
end

function Range:OnEnable(frame)
	activeFrames[frame] = true
	startUpdater()
end

function Range:OnDisable(frame)
	activeFrames[frame] = nil
	frame:SetAlpha(1.0)
	stopUpdater()
end
