-- Cast bar module: player and target cast/channel bars using UnitCastingInfo/UnitChannelInfo (TBC APIs).
local Cast = {}
ShadowUF:RegisterModule(Cast, "castBar", ShadowUF.L["Cast bar"], true)

local Layout = ShadowUF.Layout
local SML = LibStub:GetLibrary("LibSharedMedia-3.0")

local CAST_BAR_BORDER_SIZE = 2

-- Single shared frame to drive per-frame cast bar updates (ensures smooth animation like Blizzard cast bar)
local castBarUpdater = nil
local activeCastBars = {}

local function updateCastBarSparkPosition(bar)
	if not bar.spark then return end
	local minV, maxV = bar:GetMinMaxValues()
	local range = maxV - minV
	if range <= 0 then return end
	local val = bar:GetValue()
	local pct = (val - minV) / range
	local w = bar:GetWidth()
	local x = w * pct
	bar.spark:ClearAllPoints()
	bar.spark:SetHeight(bar:GetHeight() + 4)
	bar.spark:SetPoint("CENTER", bar, "LEFT", x, 0)
end

local function ensureCastBarUpdater()
	if castBarUpdater then return end
	castBarUpdater = CreateFrame("Frame", nil, UIParent)
	castBarUpdater:Hide()
	castBarUpdater:SetScript("OnUpdate", function()
		local now = GetTime()
		for bar, _ in pairs(activeCastBars) do
			if not bar.castEndTime or now >= bar.castEndTime then
				activeCastBars[bar] = nil
				bar:SetScript("OnUpdate", nil)
				bar.castStartTime = nil
				bar.castEndTime = nil
				bar:Hide()
			else
				if bar.isChannel then
					bar:SetValue(bar.castEndTime - now)
				else
					bar:SetValue(now - bar.castStartTime)
				end
				updateCastBarSparkPosition(bar)
				if bar.timeStr and bar.timeStr:IsShown() then
					bar.timeStr:SetText(string.format("%.1f", bar.castEndTime - now))
				end
			end
		end
		if not next(activeCastBars) then
			castBarUpdater:Hide()
		end
	end)
end

local function registerCastBarForUpdates(bar)
	ensureCastBarUpdater()
	activeCastBars[bar] = true
	castBarUpdater:Show()
end

local function unregisterCastBarFromUpdates(bar)
	activeCastBars[bar] = nil
	if castBarUpdater and not next(activeCastBars) then
		castBarUpdater:Hide()
	end
end

local function applyCastBarTexture(bar, frame)
	local path = Layout.mediaPath and (Layout.mediaPath.statusbar or Layout.mediaPath[SML.MediaType.STATUSBAR]) or "Interface\\TargetingFrame\\UI-StatusBar"
	bar:SetStatusBarTexture(path)
	local tex = bar:GetStatusBarTexture()
	if tex then tex:SetHorizTile(false) end
	if bar.background then
		bar.background:Hide()
	end
	local config = frame and ShadowUF.db.profile.units[frame.unitType] and ShadowUF.db.profile.units[frame.unitType].castBar
	if config then
		bar:SetOrientation(config.vertical and "VERTICAL" or "HORIZONTAL")
		bar:SetReverseFill(config.reverse and true or false)
	end
end

local function ensureCastBarBorder(bar)
	if bar.borderTop then return end
	bar.borderTop = bar:CreateTexture(nil, "OVERLAY")
	bar.borderTop:SetPoint("TOPLEFT", bar, "TOPLEFT", -CAST_BAR_BORDER_SIZE, CAST_BAR_BORDER_SIZE)
	bar.borderTop:SetPoint("TOPRIGHT", bar, "TOPRIGHT", CAST_BAR_BORDER_SIZE, CAST_BAR_BORDER_SIZE)
	bar.borderTop:SetHeight(CAST_BAR_BORDER_SIZE)
	bar.borderBottom = bar:CreateTexture(nil, "OVERLAY")
	bar.borderBottom:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -CAST_BAR_BORDER_SIZE, -CAST_BAR_BORDER_SIZE)
	bar.borderBottom:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", CAST_BAR_BORDER_SIZE, -CAST_BAR_BORDER_SIZE)
	bar.borderBottom:SetHeight(CAST_BAR_BORDER_SIZE)
	bar.borderLeft = bar:CreateTexture(nil, "OVERLAY")
	bar.borderLeft:SetPoint("TOPLEFT", bar, "TOPLEFT", -CAST_BAR_BORDER_SIZE, CAST_BAR_BORDER_SIZE)
	bar.borderLeft:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -CAST_BAR_BORDER_SIZE, -CAST_BAR_BORDER_SIZE)
	bar.borderLeft:SetWidth(CAST_BAR_BORDER_SIZE)
	bar.borderRight = bar:CreateTexture(nil, "OVERLAY")
	bar.borderRight:SetPoint("TOPRIGHT", bar, "TOPRIGHT", CAST_BAR_BORDER_SIZE, CAST_BAR_BORDER_SIZE)
	bar.borderRight:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", CAST_BAR_BORDER_SIZE, -CAST_BAR_BORDER_SIZE)
	bar.borderRight:SetWidth(CAST_BAR_BORDER_SIZE)
end

local function setCastBarBorderColor(bar)
	local r, g, b, a = 0.6, 0.5, 0, 1  -- dark yellow border
	bar.borderTop:SetColorTexture(r, g, b, a)
	bar.borderBottom:SetColorTexture(r, g, b, a)
	bar.borderLeft:SetColorTexture(r, g, b, a)
	bar.borderRight:SetColorTexture(r, g, b, a)
end

local function ensureCastBarSpark(bar)
	if bar.spark then return end
	bar.spark = bar:CreateTexture(nil, "OVERLAY")
	bar.spark:SetWidth(4)
	bar.spark:SetColorTexture(1, 0.95, 0.7, 1)  -- bright yellow-white spark
	bar.spark:SetBlendMode("ADD")
end

function Cast:OnEnable(frame)
	if not frame.castBar then
		frame.castBar = ShadowUF.Units:CreateBar(frame)
	end

	local unitType = frame.unitType
	local config = ShadowUF.db.profile.units[unitType].castBar
	if not config then return end

	ensureCastBarBorder(frame.castBar)
	setCastBarBorderColor(frame.castBar)
	ensureCastBarSpark(frame.castBar)

	-- Optional name and time font strings (anchored to cast bar per config)
	frame.castBar.nameStr = frame.castBar.nameStr or frame.castBar:CreateFontString(nil, "ARTWORK")
	frame.castBar.timeStr = frame.castBar.timeStr or frame.castBar:CreateFontString(nil, "ARTWORK")

	local nameCfg = config.name
	local timeCfg = config.time
	if nameCfg and nameCfg.enabled then
		Layout:SetupFontString(frame.castBar.nameStr, nameCfg.size or 0)
		frame.castBar.nameStr:SetTextColor(ShadowUF.db.profile.font.color.r, ShadowUF.db.profile.font.color.g, ShadowUF.db.profile.font.color.b, ShadowUF.db.profile.font.color.a)
		frame.castBar.nameStr:SetJustifyH(Layout:GetJustify(nameCfg))
		Layout:AnchorFrame(frame.castBar, frame.castBar.nameStr, nameCfg)
		frame.castBar.nameStr:Show()
	else
		frame.castBar.nameStr:Hide()
	end
	if timeCfg and timeCfg.enabled then
		Layout:SetupFontString(frame.castBar.timeStr, timeCfg.size or 0)
		frame.castBar.timeStr:SetTextColor(ShadowUF.db.profile.font.color.r, ShadowUF.db.profile.font.color.g, ShadowUF.db.profile.font.color.b, ShadowUF.db.profile.font.color.a)
		frame.castBar.timeStr:SetJustifyH(Layout:GetJustify(timeCfg))
		Layout:AnchorFrame(frame.castBar, frame.castBar.timeStr, timeCfg)
		frame.castBar.timeStr:Show()
	else
		frame.castBar.timeStr:Hide()
	end

	-- Use RegisterNormalEvent: TBC Anniversary does not support all UNIT_SPELLCAST_* as unit events.
	-- UNIT_SPELLCAST_FAIL does not exist (unknown event). Filter by unit in Update.
	frame:RegisterNormalEvent("UNIT_SPELLCAST_START", self, "Update")
	frame:RegisterNormalEvent("UNIT_SPELLCAST_STOP", self, "Update")
	frame:RegisterNormalEvent("UNIT_SPELLCAST_INTERRUPTED", self, "Update")
	frame:RegisterNormalEvent("UNIT_SPELLCAST_DELAYED", self, "Update")
	frame:RegisterNormalEvent("UNIT_SPELLCAST_CHANNEL_START", self, "Update")
	frame:RegisterNormalEvent("UNIT_SPELLCAST_CHANNEL_STOP", self, "Update")
	frame:RegisterNormalEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", self, "Update")

	frame:RegisterUpdateFunc(self, "Update")
	-- Player cast bar: detach from frame and position 80px below the player frame
	if unitType == "player" then
		local bar = frame.castBar
		bar:SetParent(frame:GetParent())
		bar:ClearAllPoints()
		bar:SetPoint("TOP", frame, "BOTTOM", 0, -80)
		bar.detachedPlayer = true
	elseif unitType == "target" then
		local bar = frame.castBar
		bar:SetParent(frame:GetParent())
		bar:ClearAllPoints()
		bar:SetPoint("TOP", frame, "BOTTOM", 0, -80)
		bar.detachedTarget = true
	end
	self:Update(frame)
end

function Cast:OnDisable(frame)
	frame:UnregisterAll(self)
	if frame.castBar then
		unregisterCastBarFromUpdates(frame.castBar)
		frame.castBar:Hide()
	end
end

function Cast:Update(frame, event, unit)
	-- When fired by event, only update if the event's unit is our frame's unit
	if event and unit and unit ~= frame.unit then
		return
	end
	local bar = frame.castBar
	if not bar then
		return
	end

	local unit = frame.unit
	local name, text, texture, startTime, endTime, notInterruptible

	-- UnitCastingInfo: normal cast (startTime -> endTime, bar 0 -> 1)
	name, text, texture, startTime, endTime = UnitCastingInfo(unit)
	if name and startTime and endTime and endTime > startTime then
		notInterruptible = select(8, UnitCastingInfo(unit))
		local duration = (endTime - startTime) / 1000
		bar.castStartTime = startTime / 1000
		bar.castEndTime = endTime / 1000
		bar.isChannel = nil
		if bar.detachedPlayer or bar.detachedTarget then
			bar:SetWidth(frame:GetWidth())
			bar:SetHeight(14)
		end
		applyCastBarTexture(bar, frame)
		bar:SetMinMaxValues(0, duration)
		bar:SetValue(GetTime() - bar.castStartTime)
		local cc = (notInterruptible and ShadowUF.db.profile.castColors.uninterruptible) or ShadowUF.db.profile.castColors.cast
		if cc then
			bar:SetStatusBarColor(cc.r, cc.g, cc.b)
		end
		if bar.nameStr and bar.nameStr:IsShown() then
			bar.nameStr:SetText(name)
		end
		bar:SetScript("OnUpdate", nil)
		registerCastBarForUpdates(bar)
		bar:Show()
		return
	end

	-- UnitChannelInfo: channel (bar drains 1 -> 0)
	name, text, texture, startTime, endTime = UnitChannelInfo(unit)
	if name and startTime and endTime and endTime > startTime then
		local duration = (endTime - startTime) / 1000
		bar.castStartTime = startTime / 1000
		bar.castEndTime = endTime / 1000
		bar.isChannel = true
		if bar.detachedPlayer or bar.detachedTarget then
			bar:SetWidth(frame:GetWidth())
			bar:SetHeight(14)
		end
		applyCastBarTexture(bar, frame)
		bar:SetMinMaxValues(0, duration)
		bar:SetValue(duration - (GetTime() - bar.castStartTime))
		local cc = ShadowUF.db.profile.castColors.channel
		if cc then
			bar:SetStatusBarColor(cc.r, cc.g, cc.b)
		end
		if bar.nameStr and bar.nameStr:IsShown() then
			bar.nameStr:SetText(name)
		end
		bar:SetScript("OnUpdate", nil)
		registerCastBarForUpdates(bar)
		bar:Show()
		return
	end

	unregisterCastBarFromUpdates(bar)
	bar:SetScript("OnUpdate", nil)
	bar.castStartTime = nil
	bar.castEndTime = nil
	bar:Hide()
end
