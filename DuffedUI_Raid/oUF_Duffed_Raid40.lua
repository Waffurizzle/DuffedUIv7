local ADDON_NAME, ns = ...
local oUF = oUFDuffedUI or oUF
assert(oUF, "DuffedUI was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local D, C, L, G = unpack(DuffedUI)
if not C["raid"].enable == true then return end

local backdrop = {
	bgFile = C["media"].blank,
	insets = {top = -D.mult, left = -D.mult, bottom = -D.mult, right = -D.mult},
	}

local function Shared(self, unit)
	self.colors = D.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = D.SpawnMenu
	
	local health = CreateFrame('StatusBar', nil, self)
    health:SetAllPoints(self)
	health:SetStatusBarTexture(C["media"].normTex)
	health:CreateBackdrop()
	self.Health = health

	health.bg = self.Health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(self.Health)
	health.bg:SetTexture(C["media"].blank)
	health.bg.multiplier = (.3)
	
	self.Health.bg = health.bg
	
	health.PostUpdate = D.PostUpdatePetColor
	health.frequentUpdates = true
	
	if C["unitframes"].unicolor == true then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
		health.bg:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
		health.bg:SetTexture(.6, .6, .6)
		if C["unitframes"].ColorGradient then
			health.colorSmooth = true
			health.bg:SetTexture(0, 0, 0)
		end
	else
		health.colorDisconnected = true
		health.colorClass = true
		health.colorReaction = true	
		health.bg:SetTexture(.1, .1, .1)		
	end
		
	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
	name:Point("LEFT", self, "RIGHT", 5, 0)
	if C["unitframes"].unicolor == true then
		self:Tag(name, '[DuffedUI:getnamecolor][DuffedUI:namemedium] [DuffedUI:dead][DuffedUI:afk]')
	else
		self:Tag(name, '[DuffedUI:namemedium] [DuffedUI:dead][DuffedUI:afk]')
	end
	self.Name = name
	
	if C["raid"].showsymbols == true then
		RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(14 * D.raidscale)
		RaidIcon:Width(14 * D.raidscale)
		RaidIcon:SetPoint("CENTER", self, "CENTER")
		RaidIcon:SetTexture("Interface\\AddOns\\DuffedUI\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	if C["raid"].aggro == true then
		table.insert(self.__elements, D.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', D.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', D.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', D.UpdateThreat)
    end
	
	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(6 * D.raidscale)
    LFDRole:Width(6 * D.raidscale)
	LFDRole:Point("TOPLEFT", 2, -2)
	LFDRole:SetTexture("Interface\\AddOns\\DuffedUI\\medias\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	--Resurrect Indicator
    local Resurrect = CreateFrame('Frame', nil, self)
    Resurrect:SetFrameLevel(20)
    local ResurrectIcon = Resurrect:CreateTexture(nil, "OVERLAY")
    ResurrectIcon:Point("CENTER", health, 0, -1)
    ResurrectIcon:Size(20, 15)
    ResurrectIcon:SetDrawLayer('OVERLAY', 7)
    self.ResurrectIcon = ResurrectIcon
	
	local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12 * D.raidscale)
	ReadyCheck:Width(12 * D.raidscale)
	ReadyCheck:SetPoint('CENTER')
	self.ReadyCheck = ReadyCheck
	
	local leader = self.Health:CreateTexture(nil, "OVERLAY")
	leader:Height(12 * D.raidscale)
	leader:Width(12 * D.raidscale)
	leader:SetPoint("TOPLEFT", 0, 8)
	self.Leader = leader
	
	local MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
	MasterLooter:Height(12 * D.raidscale)
	MasterLooter:Width(12 * D.raidscale)
	self.MasterLooter = MasterLooter
	self:RegisterEvent("PARTY_LEADER_CHANGED", D.MLAnchorUpdate)
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", D.MLAnchorUpdate)
	
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = false
	self.DebuffHighlightFilter = true

	if C["unitframes"].showsmooth == true then health.Smooth = true end
	
	if C["raid"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["raid"].raidalphaoor}
		self.Range = range
	end
	
	health:CreateBackdrop()
	self.panel = border
	
	return self
end

oUF:RegisterStyle('DuffedUIDpsR40', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("DuffedUIDpsR40")

	local raid = self:SpawnHeader("oUF_DuffedUIDpsRaid40", nil, "custom [@raid26,exists] show;hide", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', D.Scale(100 * D.raidscale),
		'initial-height', D.Scale(12 * D.raidscale),
		"showRaid", true, 
		"groupFilter", 
		"1,2,3,4,5,6,7,8", 
		"groupingOrder", 
		"1,2,3,4,5,6,7,8", 
		"groupBy", "GROUP", 
		"yOffset", D.Scale(8),
		"point", "BOTTOM"
	)
	if DuffedUIChatBackgroundLeft then
		raid:Point("BOTTOMLEFT", DuffedUIChatBackgroundLeft, "TOPLEFT", 2, 3)
	else
		raid:Point("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 2, 20)
	end
end)