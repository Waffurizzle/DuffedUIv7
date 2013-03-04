local ADDON_NAME, ns = ...
local oUF = oUFDuffedUI or oUF
assert(oUF, "DuffedUI was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local D, C, L, G = unpack(DuffedUI)
if not C["unitframes"].enable == true or C["raid"].gridonly == true then return end

local normTex = C["media"].normTex
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
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:Height(27 * D.raidscale)
	health:SetStatusBarTexture(normTex)
	health:CreateBackdrop()
	self.Health = health
	if C["raid"].gridhealthvertical == true then health:SetOrientation('VERTICAL') end
	
	health.bg = health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(health)
	health.bg:SetTexture(normTex)
	health.bg.multiplier = .3
	self.Health.bg = health.bg
		
	health.value = health:CreateFontString(nil, "OVERLAY")
	health.value:Point("RIGHT", health, -3, 1)
	health.value:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
	health.value:SetTextColor(1, 1, 1)
	health.value:SetShadowOffset(1, -1)
	self.Health.value = health.value
	
	health.PostUpdate = D.PostUpdateHealthRaid
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
	
	local power = CreateFrame("StatusBar", nil, self)
	power:Height(4 * D.raidscale)
	power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, 4)
	power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, 4)
	power:SetStatusBarTexture(normTex)
	power:SetFrameLevel(health:GetFrameLevel() + 1)
	self.Power = power
	
	power.frequentUpdates = true
	power.colorDisconnected = true

	power.bg = self.Power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(normTex)
	power.bg:SetAlpha(1)
	power.bg.multiplier = .4
	self.Power.bg = power.bg
	
	if C["unitframes"].powerClasscolored then
		power.colorClass = true
		power.bg.multiplier = .1			
	else
		power.colorPower = true
	end
	
	local name = health:CreateFontString(nil, "OVERLAY")
    name:Point("LEFT", health, 3, 0)
	name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
	name:SetShadowOffset(1, -1)
	self:Tag(name, "[DuffedUI:namemedium]")
	self.Name = name
	
    local leader = health:CreateTexture(nil, "OVERLAY")
    leader:Height(12 * D.raidscale)
    leader:Width(12 * D.raidscale)
    leader:Point("TOPLEFT", 0, 8)
	self.Leader = leader
	
    local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(6 * D.raidscale)
    LFDRole:Width(6 * D.raidscale)
	LFDRole:Point("TOPRIGHT", -2, -2)
	LFDRole:SetTexture("Interface\\AddOns\\DuffedUI\\medias\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	--Resurrect Indicator
    local Resurrect = CreateFrame('Frame', nil, self)
    Resurrect:SetFrameLevel(20)
    local ResurrectIcon = Resurrect:CreateTexture(nil, "OVERLAY")
    ResurrectIcon:Point("CENTER", health, 0, 0)
    ResurrectIcon:Size(20, 15)
    ResurrectIcon:SetDrawLayer('OVERLAY', 7)
    self.ResurrectIcon = ResurrectIcon
	
	local MasterLooter = health:CreateTexture(nil, "OVERLAY")
    MasterLooter:Height(12 * D.raidscale)
    MasterLooter:Width(12 * D.raidscale)
	self.MasterLooter = MasterLooter
    self:RegisterEvent("PARTY_LEADER_CHANGED", D.MLAnchorUpdate)
    self:RegisterEvent("PARTY_MEMBERS_CHANGED", D.MLAnchorUpdate)
	
	if C["raid"].aggro == true then
		table.insert(self.__elements, D.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', D.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', D.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', D.UpdateThreat)
    end
	
	if C["raid"].showsymbols == true then
		local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(18 * D.raidscale)
		RaidIcon:Width(18 * D.raidscale)
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\DuffedUI\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	local ReadyCheck = self.Power:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12 * D.raidscale)
	ReadyCheck:Width(12 * D.raidscale)
	ReadyCheck:SetPoint('CENTER')
	self.ReadyCheck = ReadyCheck
	
    local debuffs = CreateFrame('Frame', nil, self)
    debuffs:Point('LEFT', self, 'RIGHT', 4, 0)
    debuffs:SetHeight(26)
    debuffs:SetWidth(200)
    debuffs.size = 26
    debuffs.spacing = 2
    debuffs.initialAnchor = 'LEFT'
	debuffs.num = 5
	debuffs.PostCreateIcon = D.PostCreateAura
	debuffs.PostUpdateIcon = D.PostUpdateAura
	self.Debuffs = debuffs
	
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = false
	self.DebuffHighlightFilter = true
	
	if C["raid"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["raid"].raidalphaoor}
		self.Range = range
	end
	
	if C["unitframes"].showsmooth == true then
		health.Smooth = true
		power.Smooth = true
	end
	
	if C["unitframes"].healcomm then
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		mhpb:SetWidth(150 * D.raidscale)
		mhpb:SetStatusBarTexture(normTex)
		mhpb:SetStatusBarColor(0, 1, .5, .25)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		ohpb:SetWidth(140 * D.raidscale)
		ohpb:SetStatusBarTexture(normTex)
		ohpb:SetStatusBarColor(0, 1, 0, .25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
	
	if D.myclass == "PRIEST" and C["unitframes"].weakenedsoulbar then
		local ws = CreateFrame("StatusBar", self:GetName().."_WeakenedSoul", power)
		ws:SetAllPoints(power)
		ws:SetStatusBarTexture(C["media"].normTex)
		ws:GetStatusBarTexture():SetHorizTile(false)
		ws:SetBackdrop(backdrop)
		ws:SetBackdropColor(unpack(C["media"].backdropcolor))
		ws:SetStatusBarColor(191/255, 10/255, 10/255)
    
		self.WeakenedSoul = ws
	end
	
	return self
end

oUF:RegisterStyle('DuffedUIHealR01R15', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("DuffedUIHealR01R15")

	local raid = self:SpawnHeader("oUF_DuffedUIHealRaid0115", nil, "custom [@raid16,exists] hide;show", 
	'oUF-initialConfigFunction', [[
		local header = self:GetParent()
		self:SetWidth(header:GetAttribute('initial-width'))
		self:SetHeight(header:GetAttribute('initial-height'))
	]],
	'initial-width', D.Scale(150 * D.raidscale),
	'initial-height', D.Scale(32 * D.raidscale),	
	"showParty", true, 
	"showPlayer", C["raid"].showplayerinparty, 
	"showRaid", true,
	--"showSolo", true, -- only for dev
	"groupFilter", "1,2,3,4,5,6,7,8", 
	"groupingOrder", "1,2,3,4,5,6,7,8", 
	"groupBy", "GROUP", 
	"yOffset", D.Scale(-8))
	
	if DuffedUIChatBackgroundLeft then
		raid:Point("BOTTOMLEFT", DuffedUIChatBackgroundLeft, "TOPLEFT", 2, 3)
	else
		raid:Point("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 2, 20)
	end
	
	if C["raid"].showraidpets == false then
		local pets = {} 
			pets[1] = oUF:Spawn('partypet1', 'oUF_DuffedUIPartyPet1') 
			pets[1]:Point('BOTTOMLEFT', raid, 'TOPLEFT', 0, 24 * D.raidscale)
			pets[1]:Size(150 * D.raidscale, 32 * D.raidscale)
		for i =2, 4 do 
			pets[i] = oUF:Spawn('partypet'..i, 'oUF_DuffedUIPartyPet'..i) 
			pets[i]:Point('BOTTOM', pets[i-1], 'TOP', 0, 8)
			pets[i]:Size(150 * D.raidscale, 32 * D.raidscale)
		end
	end
		
	local RaidMove = CreateFrame("Frame")
	RaidMove:RegisterEvent("PLAYER_ENTERING_WORLD")
	RaidMove:RegisterEvent("RAID_ROSTER_UPDATE")
	RaidMove:RegisterEvent("PARTY_LEADER_CHANGED")
	RaidMove:RegisterEvent("PARTY_MEMBERS_CHANGED")
	RaidMove:SetScript("OnEvent", function(self)
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			local numraid = GetNumGroupMembers()
			local numparty = GetNumSubgroupMembers()
			if numparty > 0 and numraid == 0 or numraid > 0 and numraid <= 5 then
				if C["raid"].showraidpets == false then for i,v in ipairs(pets) do v:Enable() end end
			elseif numraid > 5 and numraid <= 10 then
				for i,v in ipairs(pets) do v:Disable() end
			elseif numraid > 10 and numraid <= 15 then
				for i,v in ipairs(pets) do v:Disable() end
			elseif numraid > 15 then
				for i,v in ipairs(pets) do v:Disable() end
			end
		end
	end)
end)