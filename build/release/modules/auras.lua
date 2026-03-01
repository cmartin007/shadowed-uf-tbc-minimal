-- Auras module: buff/debuff icons on unit frames.
local Auras = {}
ShadowUF:RegisterModule(Auras, "auras")

local Layout = ShadowUF.Layout
local DEFAULT_SIZE = 18
local DEFAULT_PER_ROW = 8
local SPACING = 5
local SIZE_MULTIPLIER = 2
local BORDER_SIZE = 2

local playerUnits = {player = true, pet = true}
local SELF_SCALE = 1.30

local function addIconBorder(button)
	button.borderTop = button:CreateTexture(nil, "OVERLAY")
	button.borderTop:SetPoint("TOPLEFT", button, "TOPLEFT", -BORDER_SIZE, BORDER_SIZE)
	button.borderTop:SetPoint("TOPRIGHT", button, "TOPRIGHT", BORDER_SIZE, BORDER_SIZE)
	button.borderTop:SetHeight(BORDER_SIZE)

	button.borderBottom = button:CreateTexture(nil, "OVERLAY")
	button.borderBottom:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -BORDER_SIZE, -BORDER_SIZE)
	button.borderBottom:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", BORDER_SIZE, -BORDER_SIZE)
	button.borderBottom:SetHeight(BORDER_SIZE)

	button.borderLeft = button:CreateTexture(nil, "OVERLAY")
	button.borderLeft:SetPoint("TOPLEFT", button, "TOPLEFT", -BORDER_SIZE, BORDER_SIZE)
	button.borderLeft:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -BORDER_SIZE, -BORDER_SIZE)
	button.borderLeft:SetWidth(BORDER_SIZE)

	button.borderRight = button:CreateTexture(nil, "OVERLAY")
	button.borderRight:SetPoint("TOPRIGHT", button, "TOPRIGHT", BORDER_SIZE, BORDER_SIZE)
	button.borderRight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", BORDER_SIZE, -BORDER_SIZE)
	button.borderRight:SetWidth(BORDER_SIZE)
end

local function setBorderColor(button, r, g, b)
	button.borderTop:SetColorTexture(r, g, b, 1)
	button.borderBottom:SetColorTexture(r, g, b, 1)
	button.borderLeft:SetColorTexture(r, g, b, 1)
	button.borderRight:SetColorTexture(r, g, b, 1)
end

local function getConfig(frame, kind)
	local unitConfig = ShadowUF.db.profile.units[frame.unitType]
	local parent = ShadowUF.db.profile.parentUnit
	local auras = unitConfig and unitConfig.auras
	if not auras then return nil end
	local cfg = auras[kind]
	if not cfg or not cfg.enabled then return nil end
	local parentCfg = parent and parent.auras and parent.auras[kind] or {}
	local enlarge = cfg.enlarge or parentCfg.enlarge
	if kind == "debuffs" then
		if not enlarge then enlarge = {SELF = true} end
		if enlarge.SELF == nil then enlarge.SELF = true end
	end
	local whitelist = cfg.whitelist or parentCfg.whitelist
	if whitelist and not next(whitelist) then whitelist = nil end
	return {
		anchorPoint = cfg.anchorPoint or parentCfg.anchorPoint or "BL",
		anchorTo = cfg.anchorTo or parentCfg.anchorTo or "$parent",
		x = cfg.x or parentCfg.x or 0,
		y = cfg.y or parentCfg.y or 0,
		size = (cfg.size or parentCfg.size or DEFAULT_SIZE) * SIZE_MULTIPLIER,
		perRow = cfg.perRow or parentCfg.perRow or DEFAULT_PER_ROW,
		maxRows = cfg.maxRows or parentCfg.maxRows or 1,
		enlarge = enlarge,
		selfScale = cfg.selfScale or parentCfg.selfScale or SELF_SCALE,
		whitelist = whitelist,
	}
end

local function createButton(parent, size, index)
	local button = CreateFrame("Button", nil, parent)
	button:SetHeight(size)
	button:SetWidth(size)
	button:EnableMouse(true)
	button.index = index
	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints(button)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.count = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, 0)
	button.count:SetJustifyH("RIGHT")
	button.count:SetText("")
	button.cooldown = CreateFrame("Cooldown", nil, button)
	button.cooldown:SetAllPoints(button)
	addIconBorder(button)
	button:SetScript("OnEnter", function(self)
		local container = self:GetParent()
		local frame = container:GetParent()
		local unit = frame and frame.unit
		if not unit or not UnitExists(unit) or (GameTooltip.IsForbidden and GameTooltip:IsForbidden()) then return end
		if not GameTooltip.SetUnitAura then return end
		local idx = self.index
		local kind = container.kind
		local filter = (kind == "buffs") and "HELPFUL" or "HARMFUL"
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetUnitAura(unit, idx, filter)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		if not (GameTooltip.IsForbidden and GameTooltip:IsForbidden()) then
			GameTooltip:Hide()
		end
	end)
	button:Hide()
	return button
end

local function positionButtons(container, config, buttons)
	local growth = Layout:GetAuraGrowth(config.anchorPoint)
	local size = config.size or DEFAULT_SIZE
	local perRow = config.perRow or DEFAULT_PER_ROW
	local gap = SPACING
	local step = size + gap
	local point, relPoint, dx, dy, rowDx, rowDy
	if growth == "RIGHT" then
		point, relPoint, dx, dy = "BOTTOMLEFT", "BOTTOMRIGHT", gap, 0
		rowDx, rowDy = 0, -step
	elseif growth == "LEFT" then
		point, relPoint, dx, dy = "BOTTOMRIGHT", "BOTTOMLEFT", -gap, 0
		rowDx, rowDy = 0, -step
	elseif growth == "TOP" then
		point, relPoint, dx, dy = "BOTTOMLEFT", "TOPLEFT", 0, gap
		rowDx, rowDy = step, 0
	else
		point, relPoint, dx, dy = "TOPLEFT", "BOTTOMLEFT", 0, -gap
		rowDx, rowDy = step, 0
	end
	local pointAnchor, relativeAnchor = ShadowUF.ResolveAnchorPoints(config.anchorPoint)
	for i, button in ipairs(buttons) do
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint(pointAnchor, container, relativeAnchor, 0, 0)
		else
			local col = (i - 1) % perRow
			if col == 0 then
				local rowStart = buttons[i - perRow]
				button:SetPoint(pointAnchor, rowStart, relativeAnchor, rowDx, rowDy)
			else
				button:SetPoint(point, buttons[i - 1], relPoint, dx, dy)
			end
		end
	end
end

local function buildContainer(frame, kind)
	local cfg = getConfig(frame, kind)
	if not cfg then return end
	local container = CreateFrame("Frame", nil, frame)
	container:SetSize(1, 1)
	container.kind = kind
	local pointAnchor, relativeAnchor = ShadowUF.ResolveAnchorPoints(cfg.anchorPoint)
	local anchorTo = frame
	if cfg.anchorTo and string.sub(cfg.anchorTo, 1, 1) == "$" and cfg.anchorTo ~= "$parent" then
		local key = string.sub(cfg.anchorTo, 2)
		anchorTo = frame[key] or frame
	end
	container:SetPoint(pointAnchor, anchorTo, relativeAnchor, cfg.x or 0, cfg.y or 0)
	container.buttons = {}
	local maxButtons = (cfg.perRow or DEFAULT_PER_ROW) * (cfg.maxRows or 1)
	for i = 1, maxButtons do
		container.buttons[i] = createButton(container, cfg.size or DEFAULT_SIZE, i)
	end
	positionButtons(container, cfg, container.buttons)
	frame.auras[kind] = container
end

local function scanAuras(unit, kind, index)
	local filter = (kind == "buffs") and "HELPFUL" or "HARMFUL"

	if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex and AuraUtil and AuraUtil.UnpackAuraData then
		local auraData = C_UnitAuras.GetAuraDataByIndex(unit, index, filter)
		if not auraData then return nil end
		local name, icon, count, _, duration, expirationTime = AuraUtil.UnpackAuraData(auraData)
		local auraType = auraData.dispelName
		local caster = auraData.sourceUnit
		return name, icon, count, auraType, duration, expirationTime, caster, auraData.spellId
	end

	-- positions: name, texture, count, auraType, duration, endTime, caster, isStealable, shouldConsolidate, spellId
	local name, texture, count, auraType, duration, endTime, caster, _, _, spellId = UnitAura(unit, index, filter)
	if not name then return nil end
	return name, texture, count, auraType, duration, endTime, caster, spellId
end

local function updateAuraList(frame, kind)
	local unit = frame.unit
	if not unit or not UnitExists(unit) then return end
	if not frame.auras then return end
	if not frame.auras[kind] then
		buildContainer(frame, kind)
	end
	local container = frame.auras[kind]
	if not container or not container.buttons then return end
	local cfg = getConfig(frame, kind)
	if not cfg then
		container:Hide()
		return
	end
	local maxButtons = (cfg.perRow or DEFAULT_PER_ROW) * (cfg.maxRows or 1)
	local buttons = container.buttons
	local shown = 0
	for auraIndex = 1, 40 do
		if shown >= maxButtons then break end
		local name, texture, count, auraType, duration, endTime, caster, spellId = scanAuras(unit, kind, auraIndex)
		if not name then break end
		if not cfg.whitelist or cfg.whitelist[spellId] or cfg.whitelist[name] then
			local button = buttons[shown + 1]
			if not button then break end
			button.index = auraIndex

			local color = kind == "debuffs" and DebuffTypeColor and (DebuffTypeColor[auraType or "none"] or DebuffTypeColor.none)
			if color then
				setBorderColor(button, color.r, color.g, color.b)
			else
				setBorderColor(button, 0, 0, 0)
			end

			if playerUnits[caster] and cfg.enlarge.SELF then
				button:SetScale(cfg.selfScale)
			else
				button:SetScale(1)
			end

			button:SetHeight(cfg.size)
			button:SetWidth(cfg.size)

			button.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
			button.icon:SetShown(texture and true)
			if count and count > 1 then
				button.count:SetText(tostring(count))
				button.count:Show()
			else
				button.count:SetText("")
				button.count:Hide()
			end
			if duration and duration > 0 and endTime and (endTime - GetTime()) > 0 then
				button.cooldown:SetCooldown(endTime - duration, duration)
			else
				button.cooldown:SetCooldown(0, 0)
			end
			button:Show()
			shown = shown + 1
		end
	end
	for i = shown + 1, maxButtons do
		if buttons[i] then
			buttons[i]:SetScale(1)
			buttons[i]:Hide()
		end
	end
	container:SetShown(shown > 0)
end

function Auras:UpdateFilter(frame)
	-- No-op: required by units.lua when frame.visibility.auras is true.
end

function Auras:Update(frame)
	if not frame.auras then return end
	updateAuraList(frame, "debuffs")
	updateAuraList(frame, "buffs")
end

function Auras:OnEnable(frame)
	local unitConfig = ShadowUF.db.profile.units[frame.unitType]
	if not unitConfig or not unitConfig.auras then return end
	frame.auras = {}
	for _, kind in ipairs({"debuffs", "buffs"}) do
		buildContainer(frame, kind)
	end
	frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
	frame:RegisterUpdateFunc(self, "Update")
	self:Update(frame)
end

function Auras:OnDisable(frame)
	frame:UnregisterAll(self)
	if frame.auras then
		for _, container in pairs(frame.auras) do
			container:Hide()
		end
	end
end
