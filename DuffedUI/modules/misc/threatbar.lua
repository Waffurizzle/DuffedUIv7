local D, C, L, G = unpack(select(2, ...))
if IsAddOnLoaded("Omen") or not DuffedUIInfoRight or not oUFDuffedUI then return end

local aggroColors = {
	[1] = {12 / 255, 151 / 255,  15 / 255},
	[2] = {166 / 255, 171 / 255,  26 / 255},
	[3] = {163 / 255,  24 / 255,  24 / 255},
}

local DuffedUIThreatBar = CreateFrame("StatusBar", "DuffedUIThreatBar", DuffedUIInfoRight)
if (C["misc"].exp_rep and D.level == MAX_PLAYER_LEVEL) then
	DuffedUIThreatBar:Point("TOPLEFT", DuffedUIExperience, 0, 0)
	DuffedUIThreatBar:Point("BOTTOMRIGHT", DuffedUIExperience, 0, 0)
	DuffedUIThreatBar:SetFrameLevel(DuffedUIExperience:GetFrameLevel() + 1)
	DuffedUIThreatBar:SetFrameStrata("HIGH")
else
	DuffedUIThreatBar:Point("TOPLEFT", 2, -2)
	DuffedUIThreatBar:Point("BOTTOMRIGHT", -2, 2)
	DuffedUIThreatBar:SetFrameLevel(0)
	DuffedUIThreatBar:SetFrameStrata("MEDIUM")
end
G.Misc.ThreatBar = DuffedUIThreatBar

DuffedUIThreatBar:SetStatusBarTexture(C["media"].normTex)
DuffedUIThreatBar:GetStatusBarTexture():SetHorizTile(false)
DuffedUIThreatBar:SetBackdrop({bgFile = C["media"].blank})
if not (C["misc"].exp_rep and D.level == MAX_PLAYER_LEVEL) then DuffedUIThreatBar:SetBackdropColor(0, 0, 0, 0) end
DuffedUIThreatBar:SetMinMaxValues(0, 100)

DuffedUIThreatBar.text = D.SetFontString(DuffedUIThreatBar, C["media"].font, 12)
if (C["misc"].exp_rep and D.level == MAX_PLAYER_LEVEL) then
	DuffedUIThreatBar.text:Point("RIGHT", DuffedUIThreatBar, "RIGHT", -10, 0)
else
	DuffedUIThreatBar.text:Point("RIGHT", DuffedUIThreatBar, "RIGHT", -30, 0)
end

DuffedUIThreatBar.Title = D.SetFontString(DuffedUIThreatBar, C["media"].font, 12)
if (C["misc"].exp_rep and D.level == MAX_PLAYER_LEVEL) then
	DuffedUIThreatBar.Title:SetText(L.unitframes_ouf_threattext2)
	DuffedUIThreatBar.Title:SetPoint("LEFT", DuffedUIThreatBar, "LEFT", D.Scale(10), 0)
else
	DuffedUIThreatBar.Title:SetText(L.unitframes_ouf_threattext)
	DuffedUIThreatBar.Title:SetPoint("LEFT", DuffedUIThreatBar, "LEFT", D.Scale(30), 0)
end
	  
DuffedUIThreatBar.bg = DuffedUIThreatBar:CreateTexture(nil, 'BORDER')
DuffedUIThreatBar.bg:SetAllPoints(DuffedUIThreatBar)
DuffedUIThreatBar.bg:SetTexture(.1, .1, .1)

local function OnEvent(self, event, ...)
	local party = GetNumGroupMembers()
	local raid = GetNumGroupMembers()
	local pet = select(1, HasPetUI())
	if event == "PLAYER_ENTERING_WORLD" then
		self:Hide()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:Hide()
	elseif event == "PLAYER_REGEN_DISABLED" then
		if party > 0 or raid > 0 or pet == 1 then
			self:Show()
		else
			self:Hide()
		end
	else
		if (InCombatLockdown()) and (party > 0 or raid > 0 or pet == 1) then
			self:Show()
		else
			self:Hide()
		end
	end
end

local function OnUpdate(self, event, unit)
	if UnitAffectingCombat(self.unit) then
		local _, _, threatpct, rawthreatpct, _ = UnitDetailedThreatSituation(self.unit, self.tar)
		local threatval = threatpct or 0
		
		self:SetValue(threatval)
		self.text:SetFormattedText("%3.1f", threatval)
		
		local r, g, b = oUFDuffedUI.ColorGradient(threatval, 100, 0, .8, 0, .8, .8, 0, .8, 0, 0)
		self:SetStatusBarColor(r, g, b)

		if threatval > 0 then
			self:SetAlpha(1)
		else
			self:SetAlpha(0)
		end		
	end
end

DuffedUIThreatBar:RegisterEvent("PLAYER_ENTERING_WORLD")
DuffedUIThreatBar:RegisterEvent("PLAYER_REGEN_ENABLED")
DuffedUIThreatBar:RegisterEvent("PLAYER_REGEN_DISABLED")
DuffedUIThreatBar:SetScript("OnEvent", OnEvent)
DuffedUIThreatBar:SetScript("OnUpdate", OnUpdate)
DuffedUIThreatBar.unit = "player"
DuffedUIThreatBar.tar = DuffedUIThreatBar.unit.."target"
DuffedUIThreatBar.Colors = aggroColors
DuffedUIThreatBar:SetAlpha(0)