-- Auras module: buff/debuff icons on unit frames.
local Auras = {}
ShadowUF:RegisterModule(Auras, "auras")

local Layout = ShadowUF.Layout
local DEFAULT_SIZE = 18
local DEFAULT_PER_ROW = 8
local SPACING = 5
local SIZE_MULTIPLIER = 2
local BORDER_SIZE = 2

local function addIconBorder(slot)
	slot.borderTop = slot:CreateTexture(nil, "OVERLAY")
	slot.borderTop:SetPoint("TOPLEFT", slot, "TOPLEFT", -BORDER_SIZE, BORDER_SIZE)
	slot.borderTop:SetPoint("TOPRIGHT", slot, "TOPRIGHT", BORDER_SIZE, BORDER_SIZE)
	slot.borderTop:SetHeight(BORDER_SIZE)

	slot.borderBottom = slot:CreateTexture(nil, "OVERLAY")
	slot.borderBottom:SetPoint("BOTTOMLEFT", slot, "BOTTOMLEFT", -BORDER_SIZE, -BORDER_SIZE)
	slot.borderBottom:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", BORDER_SIZE, -BORDER_SIZE)
	slot.borderBottom:SetHeight(BORDER_SIZE)

	slot.borderLeft = slot:CreateTexture(nil, "OVERLAY")
	slot.borderLeft:SetPoint("TOPLEFT", slot, "TOPLEFT", -BORDER_SIZE, BORDER_SIZE)
	slot.borderLeft:SetPoint("BOTTOMLEFT", slot, "BOTTOMLEFT", -BORDER_SIZE, -BORDER_SIZE)
	slot.borderLeft:SetWidth(BORDER_SIZE)

	slot.borderRight = slot:CreateTexture(nil, "OVERLAY")
	slot.borderRight:SetPoint("TOPRIGHT", slot, "TOPRIGHT", BORDER_SIZE, BORDER_SIZE)
	slot.borderRight:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", BORDER_SIZE, -BORDER_SIZE)
	slot.borderRight:SetWidth(BORDER_SIZE)
end

local function setIconBorderColor(slot, auraType, kind)
	local r, g, b, a = 0, 0, 0, 1
	if kind == "debuffs" and DebuffTypeColor then
		local color = DebuffTypeColor[auraType or "none"] or DebuffTypeColor.none
		if color then r, g, b = color.r, color.g, color.b end
	end
	slot.borderTop:SetColorTexture(r, g, b, a)
	slot.borderBottom:SetColorTexture(r, g, b, a)
	slot.borderLeft:SetColorTexture(r, g, b, a)
	slot.borderRight:SetColorTexture(r, g, b, a)
end

local function getConfig(frame, kind)
	local unitConfig = ShadowUF.db.profile.units[frame.unitType]
	local parent = ShadowUF.db.profile.parentUnit
	local auras = unitConfig and unitConfig.auras
	if not auras then return nil end
	local cfg = auras[kind]
	if not cfg or not cfg.enabled then return nil end
	-- Merge with parentUnit defaults for missing keys
	local parentCfg = parent and parent.auras and parent.auras[kind] or {}
	return {
		enabled = true,
		anchorPoint = cfg.anchorPoint or parentCfg.anchorPoint or "BL",
		anchorTo = cfg.anchorTo or parentCfg.anchorTo or "$parent",
		x = cfg.x or parentCfg.x or 0,
		y = cfg.y or parentCfg.y or 0,
		size = (cfg.size or parentCfg.size or DEFAULT_SIZE) * SIZE_MULTIPLIER,
		perRow = cfg.perRow or parentCfg.perRow or DEFAULT_PER_ROW,
		maxRows = cfg.maxRows or parentCfg.maxRows or 1,
	}
end

local function createIconSlot(parent, size, index)
	local slot = CreateFrame("Frame", nil, parent)
	slot:SetSize(size, size)
	slot.icon = slot:CreateTexture(nil, "ARTWORK")
	slot.icon:SetAllPoints()
	slot.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	slot.count = slot:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	slot.count:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 1, 0)
	slot.count:SetJustifyH("RIGHT")
	slot.count:SetText("")
	-- Cooldown frame: OmniCC (and similar addons) hook this to show timer text and style
	slot.cooldown = CreateFrame("Cooldown", nil, slot)
	slot.cooldown:SetAllPoints(slot)
	slot.duration = slot:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	slot.duration:SetPoint("TOP", slot, "BOTTOM", 0, 0)
	slot.duration:SetText("")
	addIconBorder(slot)
	slot:Hide()
	return slot
end

local function positionSlots(container, config, slots)
	local growth = Layout:GetAuraGrowth(config.anchorPoint)
	local size = config.size or DEFAULT_SIZE
	local perRow = config.perRow or DEFAULT_PER_ROW
	local gap = SPACING
	local step = size + gap
	local point, relPoint, dx, dy, rowDx, rowDy
	if growth == "RIGHT" then
		point, relPoint, dx, dy = "LEFT", "RIGHT", gap, 0
		rowDx, rowDy = 0, -step
	elseif growth == "LEFT" then
		point, relPoint, dx, dy = "RIGHT", "LEFT", -gap, 0
		rowDx, rowDy = 0, -step
	elseif growth == "TOP" then
		point, relPoint, dx, dy = "BOTTOM", "TOP", 0, gap
		rowDx, rowDy = step, 0
	else
		point, relPoint, dx, dy = "TOP", "BOTTOM", 0, -gap
		rowDx, rowDy = step, 0
	end
	local pointAnchor, relativeAnchor = ShadowUF.ResolveAnchorPoints(config.anchorPoint)
	for i, slot in ipairs(slots) do
		slot:ClearAllPoints()
		if i == 1 then
			slot:SetPoint(pointAnchor, container, relativeAnchor, 0, 0)
		else
			local col = (i - 1) % perRow
			if col == 0 then
				local rowStart = slots[i - perRow]
				slot:SetPoint(pointAnchor, rowStart, relativeAnchor, rowDx, rowDy)
			else
				slot:SetPoint(point, slots[i - 1], relPoint, dx, dy)
			end
		end
	end
end

local function getAuraByIndex(unit, kind, index)
	if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex and AuraUtil and AuraUtil.UnpackAuraData then
		local filter = (kind == "buffs") and "HELPFUL" or "HARMFUL"
		local auraData = C_UnitAuras.GetAuraDataByIndex(unit, index, filter)
		if not auraData then return nil end
		local name, icon, count, _, duration, expirationTime = AuraUtil.UnpackAuraData(auraData)
		local auraType = auraData.dispelName
		return name, icon, count, duration, expirationTime, auraType
	end

	if kind == "buffs" then
		local name, _, icon, count, _, duration, expirationTime = UnitBuff(unit, index)
		return name, icon, count, duration, expirationTime, nil
	end

	local name, _, icon, count, auraType, duration, expirationTime = UnitDebuff(unit, index)
	return name, icon, count, duration, expirationTime, auraType
end

local function updateAuraList(frame, kind)
	local unit = frame.unit
	if not unit or not UnitExists(unit) then return end
	local container = frame.auras and frame.auras[kind]
	if not container or not container.icons then return end
	local cfg = getConfig(frame, kind)
	if not cfg then
		container:Hide()
		return
	end
	local maxSlots = (cfg.perRow or DEFAULT_PER_ROW) * (cfg.maxRows or 1)
	local slots = container.icons
	local shown = 0
	for i = 1, maxSlots do
		if not slots[i] then
			break
		end

		local name, icon, count, duration, expirationTime, auraType = getAuraByIndex(unit, kind, i)
		if not name then
			slots[i]:Hide()
			break
		end
		local slot = slots[i]
		setIconBorderColor(slot, auraType, kind)
		slot.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
		slot.icon:SetShown(icon and true)
		if count and count > 1 then
			slot.count:SetText(tostring(count))
			slot.count:Show()
		else
			slot.count:SetText("")
			slot.count:Hide()
		end
		if duration and duration > 0 and expirationTime and (expirationTime - GetTime()) > 0 then
			-- Set cooldown so OmniCC (and default spiral) can show the timer
			slot.cooldown:SetCooldown(expirationTime - duration, duration)
			slot.duration:Hide()
		else
			slot.cooldown:SetCooldown(0, 0)
			slot.duration:SetText("")
			slot.duration:Hide()
		end
		slot:Show()
		shown = shown + 1
	end
	for i = shown + 1, maxSlots do
		if slots[i] then slots[i]:Hide() end
	end
	container:SetShown(shown > 0)
end

function Auras:UpdateFilter(frame)
	-- No-op: required by units.lua when frame.visibility.auras is true. Filtering (whitelist/blacklist) not implemented.
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
	local parent = frame
	for _, kind in ipairs({"debuffs", "buffs"}) do
		local cfg = getConfig(frame, kind)
		if cfg then
			local container = CreateFrame("Frame", nil, parent)
			container:SetSize(1, 1)
			local pointAnchor, relativeAnchor = ShadowUF.ResolveAnchorPoints(cfg.anchorPoint)
			container:SetPoint(pointAnchor, parent, relativeAnchor, cfg.x or 0, cfg.y or 0)
			container.icons = {}
			local maxSlots = (cfg.perRow or DEFAULT_PER_ROW) * (cfg.maxRows or 1)
			for i = 1, maxSlots do
				container.icons[i] = createIconSlot(container, cfg.size or DEFAULT_SIZE, i)
			end
			positionSlots(container, cfg, container.icons)
			frame.auras[kind] = container
		end
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
