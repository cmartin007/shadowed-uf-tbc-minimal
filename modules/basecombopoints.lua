local Combo = {isComboPoints = true}
ShadowUF.ComboPoints = Combo

-- Register as a module that owns the `comboPoints` widget on the player frame
ShadowUF:RegisterModule(Combo, "comboPoints", ShadowUF.L["Combo points"], false)

-- Simple config describing how many points and which power we read.
-- We initialize this per-frame in OnEnable.

local function createIcons(config, pointsFrame)
	local point, relativePoint, x, y
	local pointsConfig = pointsFrame.cpConfig

	if( config.growth == "LEFT" ) then
		point, relativePoint = "BOTTOMRIGHT", "BOTTOMLEFT"
		x = config.spacing
	elseif( config.growth == "UP" ) then
		point, relativePoint = "BOTTOMLEFT", "TOPLEFT"
		y = config.spacing
	elseif( config.growth == "DOWN" ) then
		point, relativePoint = "TOPLEFT", "BOTTOMLEFT"
		y = config.spacing
	else
		point, relativePoint = "BOTTOMLEFT", "BOTTOMRIGHT"
		x = config.spacing
	end

	x = x or 0
	y = y or 0

	-- Use a built‑in round indicator texture with alpha so it appears circular
	local size = config.size or 10
	local tex = "Interface\\COMMON\\Indicator-Red"

	for id=1, pointsConfig.max do
		pointsFrame.icons[id] = pointsFrame.icons[id] or pointsFrame:CreateTexture(nil, "OVERLAY")
		local texture = pointsFrame.icons[id]

		-- Simple minimal indicator: small round red dot
		texture:SetTexture(tex)
		texture:SetVertexColor(1, 1, 1, 1)
		texture:SetSize(size, size)

		if( id > 1 ) then
			texture:ClearAllPoints()
			texture:SetPoint(point, pointsFrame.icons[id - 1], relativePoint, x, y)
		else
			texture:ClearAllPoints()
			texture:SetPoint("CENTER", pointsFrame, "CENTER", 0, 0)
		end
	end
end

local function createBlocks(config, pointsFrame)
	local pointsConfig = pointsFrame.cpConfig
	if pointsConfig.max == 0 then return end
	pointsFrame.visibleBlocks = pointsConfig.max

	-- Position bars, the 5 accounts for borders
	local blockWidth = (pointsFrame:GetWidth() - ((pointsConfig.max / (pointsConfig.grouping or 1)) - 1)) / pointsConfig.max
	for id=1, pointsConfig.max do
		pointsFrame.blocks[id] = pointsFrame.blocks[id] or pointsFrame:CreateTexture(nil, "OVERLAY")
		local texture = pointsFrame.blocks[id]
		local color = ShadowUF.db.profile.powerColors[pointsConfig.colorKey or "COMBOPOINTS"]
		texture:SetVertexColor(color.r, color.g, color.b, color.a)
		texture:SetHorizTile(false)
		texture:SetTexture(ShadowUF.Layout.mediaPath.statusbar)
		texture:SetHeight(pointsFrame:GetHeight())
		texture:SetWidth(blockWidth)
		texture:ClearAllPoints()

		if not texture.background and config.background then
			texture.background = pointsFrame:CreateTexture(nil, "BORDER")
			texture.background:SetHeight(1)
			texture.background:SetWidth(1)
			texture.background:SetAllPoints(texture)
			texture.background:SetHorizTile(false)
			texture.background:SetVertexColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.backgroundAlpha)
			texture.background:SetTexture(ShadowUF.Layout.mediaPath.statusbar)
		end

		if texture.background then
			texture.background:SetShown(config.background)
		end

		local offset = 1
		if pointsConfig.grouping and ((id - 1) % pointsConfig.grouping ~= 0) then
			offset = 0
		end
		if( config.growth == "LEFT" ) then
			if( id > 1 ) then
				texture:SetPoint("TOPRIGHT", pointsFrame.blocks[id - 1], "TOPLEFT", -offset, 0)
			else
				texture:SetPoint("TOPRIGHT", pointsFrame, "TOPRIGHT", 0, 0)
			end
		else
			if( id > 1 ) then
				texture:SetPoint("TOPLEFT", pointsFrame.blocks[id - 1], "TOPRIGHT", offset, 0)
			else
				texture:SetPoint("TOPLEFT", pointsFrame, "TOPLEFT", 0, 0)
			end
		end
	end
end

-- Which widget key this module uses on the frame
function Combo:GetComboPointType()
	return "comboPoints"
end

-- Return current combo points for player on their target (rogue / cat form)
function Combo:GetPoints(unit)
	if unit ~= "player" then return 0 end
	if not GetComboPoints then return 0 end
	local points = GetComboPoints("player", "target")
	return points or 0
end

function Combo:OnEnable(frame)
	-- Only attach to the player frame, and only for rogue/druid
	if frame.unitType ~= "player" or frame.unit ~= "player" then return end
	local class = select(2, UnitClass("player"))
	if class ~= "ROGUE" and class ~= "DRUID" then return end

	local key = self:GetComboPointType()
	local pointsFrame = frame[key]
	if not pointsFrame then
		pointsFrame = CreateFrame("Frame", nil, frame.highFrame or frame)
		frame[key] = pointsFrame
	end

	pointsFrame.cpConfig = pointsFrame.cpConfig or {}
	local cfg = pointsFrame.cpConfig
	cfg.max = cfg.max or 5
	cfg.grouping = cfg.grouping or 1
	cfg.colorKey = cfg.colorKey or "COMBOPOINTS"
	cfg.powerType = cfg.powerType or 4 -- COMBO_POINTS in modern API; in TBC GetComboPoints uses player/target and this is only for max

	pointsFrame.blocks = pointsFrame.blocks or {}
	pointsFrame.icons = pointsFrame.icons or {}

	-- Events: target change and power changes (we recompute combo points each time)
	frame:RegisterNormalEvent("PLAYER_TARGET_CHANGED", self, "Update")
	frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", self, "Update")

	-- Also keep in full-update list so new frames initialize correctly
	frame:RegisterUpdateFunc(self, "Update")
end

function Combo:OnLayoutApplied(frame, config)
	local key = self:GetComboPointType()
	local pointsFrame = frame[key]
	if( not pointsFrame ) then return end

	pointsFrame:SetFrameLevel(frame.topFrameLevel + 1)

	local pointsConfig = pointsFrame.cpConfig
	config = config[key]

	-- Not a bar so set the containers frame configuration
	if( config and not config.isBar ) then
		ShadowUF.Layout:ToggleVisibility(pointsFrame, frame.visibility[key])
	end

	if( not frame.visibility[key] ) then return end

	-- Hide any existing combo point textures before rebuilding
	if pointsFrame.icons then
		for _, texture in pairs(pointsFrame.icons) do
			texture:Hide()
			texture:ClearAllPoints()
		end
	end

	-- Setup for bar display!
	if( config.isBar ) then
		pointsFrame.blocks = pointsFrame.blocks or {}
		pointsFrame.points = pointsFrame.blocks

		createBlocks(config, pointsFrame)

	-- guess not, will have to do icons :(
	else
		pointsFrame.icons = pointsFrame.icons or {}
		pointsFrame.points = pointsFrame.icons

		createIcons(config, pointsFrame, pointsConfig.max)

		-- Position the main frame
		pointsFrame:SetSize(0.1, 0.1)

		ShadowUF.Layout:AnchorFrame(frame, pointsFrame, config)
	end
end

function Combo:OnDisable(frame)
	frame:UnregisterAll(self)
	local key = self:GetComboPointType()
	if frame[key] then
		frame[key]:Hide()
	end
end

function Combo:UpdateBarBlocks(frame, event, unit, powerType)
	local key = self:GetComboPointType()
	local pointsFrame = frame[key]
	if( not pointsFrame or not pointsFrame.cpConfig.eventType or not pointsFrame.blocks ) then return end
	if( event and powerType ~= pointsFrame.cpConfig.eventType ) then return end

	local max = self.GetMaxPoints and self:GetMaxPoints() or UnitPowerMax("player", pointsFrame.cpConfig.powerType)
	if( max == 0 or pointsFrame.visibleBlocks == max ) then return end

	pointsFrame.cpConfig.max = max

	if( not ShadowUF.db.profile.units[frame.unitType][key].isBar ) then
		createIcons(ShadowUF.db.profile.units[frame.unitType][key], pointsFrame)
		pointsFrame.visibleBlocks = max
		return
	else
		createBlocks(ShadowUF.db.profile.units[frame.unitType][key], pointsFrame)
		pointsFrame.visibleBlocks = max
	end

	local blockWidth = (pointsFrame:GetWidth() - (max - 1)) / max
	for id=1, max do
		pointsFrame.blocks[id]:SetWidth(blockWidth)
		pointsFrame.blocks[id]:Show()
	end

	for id=max+1, #pointsFrame.blocks do
		pointsFrame.blocks[id]:Hide()
	end

end

function Combo:Update(frame, event, unit, powerType)
	local key = self:GetComboPointType()
	if not frame[key] or not frame[key].points then return end
	-- Filter by power type if this bar is power-based (we don't set eventType so we always update)
	if( event and frame[key].cpConfig.eventType and frame[key].cpConfig.eventType ~= powerType ) then return end

	local points = self:GetPoints(frame.unit or "player")

	-- Bar display: show bar when we have points or showAlways is set
	if( ShadowUF.db.profile.units[frame.unitType][key].isBar ) then
		ShadowUF.Layout:SetBarVisibility(frame, key, ShadowUF.db.profile.units[frame.unitType][key].showAlways or (points and points > 0))
	end

	for id, pointTexture in pairs(frame[key].points) do
		if( id <= points ) then
			pointTexture:Show()
		else
			pointTexture:Hide()
		end
	end
end

function Combo:OnLayoutWidgets(frame)
	local key = self:GetComboPointType()
	if( not frame.visibility[key] or not ShadowUF.db.profile.units[frame.unitType][key].isBar or not frame[key].blocks) then return end

	local height = frame[key]:GetHeight()
	for _, block in pairs(frame[key].blocks) do
		block:SetHeight(height)
	end
end
