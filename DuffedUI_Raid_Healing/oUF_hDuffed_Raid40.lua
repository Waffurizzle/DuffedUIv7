local ADDON_NAME, ns = ...
local oUF = oUFDuffedUI or oUF
assert(oUF, "DuffedUI was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local D, C, L, G = unpack(DuffedUI)
if not C["raid"].enable == true then return end

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
	if unit:find("partypet") then health:Height(18) else health:Height(36 * C["raid"].gridscale * D.raidscale) end
	health:SetStatusBarTexture(normTex)
	health:CreateBackdrop()
	self.Health = health
	if C["raid"].gridhealthvertical == true then health:SetOrientation('VERTICAL') end
	
	health.bg = health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(health)
	health.bg:SetTexture(normTex)
	health.bg.multiplier = (.3)
	self.Health.bg = health.bg
	
	health.value = health:CreateFontString(nil, "OVERLAY")
	if not unit:find("partypet") then health.value:Point("BOTTOM", health, 1, 2) end
	health.value:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
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
	if unit:find("partypet") then power:SetHeight(0) else power:SetHeight(3) end
	power:Point("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -3)
	power:Point("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -3)
	power:SetStatusBarTexture(normTex)
	self.Power = power

	power.frequentUpdates = true
	power.colorDisconnected = true

	power.bg = power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(normTex)
	power.bg:SetAlpha(1)
	power.bg.multiplier = .3
	
	if C["unitframes"].powerClasscolored then power.colorClass = true else power.colorPower = true end

	-- border
	local panel = CreateFrame("Frame", nil, self)
	panel:SetTemplate("Default")
	panel:Size(1, 1)
	panel:Point("TOPLEFT", health, "TOPLEFT", -2, 2)
	if unit:find("partypet") then panel:Point("BOTTOMRIGHT", health, "BOTTOMRIGHT", 2, -2) else panel:Point("BOTTOMRIGHT", power, "BOTTOMRIGHT", 2, -2) end
	panel:CreateShadow("Default")
	self.panel = panel
	
	if not unit:find("partypet") then
		local ppanel = CreateFrame("Frame", nil, self)
		ppanel:CreateLine(power:GetWidth(), 1)
		ppanel:Point("BOTTOMLEFT", -1, 4)
		ppanel:Point("BOTTOMRIGHT", 1, 4)
		self.panel2 = ppanel
	end
	
	local name = health:CreateFontString(nil, "OVERLAY")
	local name = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
	if unit:find("partypet") then name:SetPoint("CENTER") else name:Point("CENTER", health, "TOP", 0, -7) end
	self:Tag(name, "[DuffedUI:getnamecolor][DuffedUI:nameshort]")
	self.Name = name
	
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
	
	local ReadyCheck = power:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12 * C["raid"].gridscale * D.raidscale)
	ReadyCheck:Width(12 * C["raid"].gridscale * D.raidscale)
	ReadyCheck:SetPoint('CENTER') 	
	self.ReadyCheck = ReadyCheck
	
	local leader = health:CreateTexture(nil, "OVERLAY")
    leader:Height(12 * D.raidscale)
    leader:Width(12 * D.raidscale)
    leader:Point("TOPLEFT", 0, 8)
	self.Leader = leader
	
	local MasterLooter = health:CreateTexture(nil, "OVERLAY")
    MasterLooter:Height(12 * D.raidscale)
    MasterLooter:Width(12 * D.raidscale)
	self.MasterLooter = MasterLooter
    self:RegisterEvent("PARTY_LEADER_CHANGED", D.MLAnchorUpdate)
    self:RegisterEvent("PARTY_MEMBERS_CHANGED", D.MLAnchorUpdate)
	
	if not C["raid"].raidunitdebuffwatch == true then
		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightBackdrop = true
		self.DebuffHighlightFilter = true
	end
	
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
		if C["raid"].gridhealthvertical then
			mhpb:SetOrientation("VERTICAL")
			mhpb:SetPoint('BOTTOM', self.Health:GetStatusBarTexture(), 'TOP', 0, 0)
			mhpb:Width(68 * C["raid"].gridscale * D.raidscale)
			mhpb:Height(31 * C["raid"].gridscale * D.raidscale)		
		else
			mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			mhpb:Width(68 * C["raid"].gridscale * D.raidscale)
		end				
		mhpb:SetStatusBarTexture(normTex)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		if C["raid"].gridhealthvertical then
			ohpb:SetOrientation("VERTICAL")
			ohpb:SetPoint('BOTTOM', mhpb:GetStatusBarTexture(), 'TOP', 0, 0)
			ohpb:Width(68 * C["raid"].gridscale * D.raidscale)
			ohpb:Height(31 * C["raid"].gridscale * D.raidscale)
		else
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:Width(68 * C["raid"].gridscale * D.raidscale)
		end
		ohpb:SetStatusBarTexture(normTex)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		local absb = CreateFrame("StatusBar", nil, self.Health)
		if C["raid"].gridhealthvertical then
			absb:SetOrientation("VERTICAL")
			absb:SetPoint("BOTTOM", ohpb:GetStatusBarTexture(), "TOP", 0, 0)
			absb:Width(68 * C["raid"].gridscale * D.raidscale)
			absb:Height(31 * C["raid"].gridscale * D.raidscale)
		else
			absb:SetPoint("TOPLEFT", ohpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			absb:SetPoint("BOTTOMLEFT", ohpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			absb:SetWidth(68 * C["raid"].gridscale * D.raidscale)
		end
		absb:SetStatusBarTexture(normTex)
		absb:SetStatusBarColor(1, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			absBar = absb,
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
	
	if C["raid"].raidunitdebuffwatch == true then
		-- AuraWatch (corner icon)
		D.createAuraWatch(self,unit)
		
		-- Raid Debuffs (big middle icon)
		local RaidDebuffs = CreateFrame('Frame', nil, self)
		RaidDebuffs:Height(24 * C["raid"].gridscale)
		RaidDebuffs:Width(24 * C["raid"].gridscale)
		RaidDebuffs:Point('CENTER', health, 1,0)
		RaidDebuffs:SetFrameStrata(health:GetFrameStrata())
		RaidDebuffs:SetFrameLevel(health:GetFrameLevel() + 2)
		
		RaidDebuffs:SetTemplate("Default")
		
		RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		RaidDebuffs.icon:SetTexCoord(.1,.9,.1,.9)
		RaidDebuffs.icon:Point("TOPLEFT", 2, -2)
		RaidDebuffs.icon:Point("BOTTOMRIGHT", -2, 2)
		
		RaidDebuffs:FontString('time', C["media"].font, 10, "THINOUTLINE")
		RaidDebuffs.time:Point('CENTER', 1, 0)
		RaidDebuffs.time:SetTextColor(1, .9, 0)
		
		RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, 'OVERLAY')
		RaidDebuffs.count:SetFont(C["media"].uffont, 9 * C["raid"].gridscale, "THINOUTLINE")
		RaidDebuffs.count:Point('BOTTOMRIGHT', RaidDebuffs, 'BOTTOMRIGHT', 0, 2)
		RaidDebuffs.count:SetTextColor(1, .9, 0)
		
		self.RaidDebuffs = RaidDebuffs
    end

	return self
end

oUF:RegisterStyle('DuffedUIHealR25R40', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("DuffedUIHealR25R40")
	
	local spawnG = "solo,raid,party"
	if C["raid"].gridonly ~= true then spawnG = "custom [@raid16,exists] show;hide" end
	
	local pointG = "LEFT"
	if C["raid"].gridvertical then pointG = "BOTTOM" end
	
	local capG = "BOTTOM"
	if C["raid"].gridvertical then capG = "LEFT" end
	
	local raid = self:SpawnHeader("DuffedUIGrid", nil, spawnG,
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', D.Scale(65 * C["raid"].gridscale * D.raidscale),
		'initial-height', D.Scale(42 * C["raid"].gridscale * D.raidscale),
		"showParty", true,
		"showPlayer", C["raid"].showplayerinparty, 
		"showRaid", true, 
		"xoffset", D.Scale(8),
		"yOffset", D.Scale(8),
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"maxColumns", 8,
		"unitsPerColumn", 5,
		"columnSpacing", D.Scale(8),
		"point", pointG,
		"columnAnchorPoint", capG,
		"showSolo", C["raid"].gridsolo
	)
	if DuffedUIChatBackgroundLeft then
		raid:Point("BOTTOMLEFT", DuffedUIChatBackgroundLeft, "TOPLEFT", 2, 6)
	else
		raid:Point("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 2, 23)
	end
	
	if C["raid"].showraidpets == false and not C["raid"].gridvertical then
		local pets = {} 
			pets[1] = oUF:Spawn('partypet1', 'oUF_DuffedUIPartyPet1') 
			pets[1]:Point('BOTTOMLEFT', raid, 'TOPLEFT', 0, 8)
			pets[1]:Size(65 * C["raid"].gridscale * D.raidscale, 18 * C["raid"].gridscale * D.raidscale)
		for i =2, 4 do 
			pets[i] = oUF:Spawn('partypet'..i, 'oUF_DuffedUIPartyPet'..i) 
			pets[i]:Point('LEFT', pets[i-1], 'RIGHT', 8, 0)
			pets[i]:Size(65 * C["raid"].gridscale * D.raidscale, 18 * C["raid"].gridscale * D.raidscale)
		end
		
		local ShowPet = CreateFrame("Frame")
		ShowPet:RegisterEvent("PLAYER_ENTERING_WORLD")
		ShowPet:RegisterEvent("RAID_ROSTER_UPDATE")
		ShowPet:RegisterEvent("PARTY_LEADER_CHANGED")
		ShowPet:RegisterEvent("PARTY_MEMBERS_CHANGED")
		ShowPet:SetScript("OnEvent", function(self)
			if InCombatLockdown() then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			else
				self:UnregisterEvent("PLAYER_REGEN_ENABLED")
				local numraid = GetNumGroupMembers()
				local numparty = GetNumSubgroupMembers()
				if numparty > 0 and numraid == 0 or numraid > 0 and numraid <= 5 then
					for i,v in ipairs(pets) do v:Enable() end
				else
					for i,v in ipairs(pets) do v:Disable() end
				end
			end
		end)
	end
end)

-- only show 5 groups in raid (25 mans raid)
local MaxGroup = CreateFrame("Frame")
MaxGroup:RegisterEvent("PLAYER_ENTERING_WORLD")
MaxGroup:RegisterEvent("ZONE_CHANGED_NEW_AREA")
MaxGroup:SetScript("OnEvent", function(self)
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	if inInstance and instanceType == "raid" and maxPlayers ~= 40 then
		DuffedUIGrid:SetAttribute("groupFilter", "1,2,3,4,5")
	else
		DuffedUIGrid:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
	end
end)