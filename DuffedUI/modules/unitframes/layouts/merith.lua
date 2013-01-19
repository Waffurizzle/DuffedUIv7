local D, C, L, G = unpack(select(2, ...))
if not C["unitframes"].enable or C["unitframes"].layout ~= 3 then return end

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "DuffedUI was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

------------------------------------------------------------------------
--	local variables
------------------------------------------------------------------------

local normTex = C["media"].normTex
local glowTex = C["media"].glowTex
local bubbleTex = C["media"].bubbleTex

local backdrop = {
	bgFile = C["media"].blank,
	insets = {top = -D.mult, left = -D.mult, bottom = -D.mult, right = -D.mult},
}

------------------------------------------------------------------------
--	Layout
------------------------------------------------------------------------

local function Shared(self, unit)
	-- set our own colors
	self.colors = D.UnitColor
	
	-- register click
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	-- menu? lol
	self.menu = D.SpawnMenu

	------------------------------------------------------------------------
	--	Features we want for all units at the same time
	------------------------------------------------------------------------
	
	-- here we create an invisible frame for all element we want to show over health/power.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()
	
	-- symbols, now put the symbol on the frame we created above.
	local RaidIcon = InvFrame:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetTexture("Interface\\AddOns\\DuffedUI\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
	RaidIcon:SetHeight(20)
	RaidIcon:SetWidth(20)
	RaidIcon:SetPoint("TOP", 0, 11)
	self.RaidIcon = RaidIcon
	
	-- Fader
	if C["unitframes"].fader == true then
		self.FadeCasting = true
		self.FadeCombat = true
		self.FadeTarget = true
		self.FadeHealth = true
		self.FadePower = true
		self.FadeHover = true

		self.FadeSmooth = 0.5
		self.FadeMinAlpha = C["unitframes"].minalpha
		self.FadeMaxAlpha = 1
	end
	
	------------------------------------------------------------------------
	--	Player and Target units layout (mostly mirror'd)
	------------------------------------------------------------------------
	
	if (unit == "player" or unit == "target") then
		-- create a panel
		local panel = CreateFrame("Frame", nil, self)
		if D.lowversion then
			panel:SetTemplate("Default")
			panel:Size(186, 21)
			panel:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
		else
			panel:SetTemplate("Default")
			panel:Size(250, 21)
			panel:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
		end
		panel:SetFrameLevel(2)
		panel:SetFrameStrata("MEDIUM")
		panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		panel:SetAlpha(0)
		self.panel = panel
	
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(20)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for HealthBar
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", D.Scale(-2), D.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder
				
		-- health bar background
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
		
		if C["unitframes"].percent then
			local percHP
			percHP = D.SetFontString(health, C["media"].font, 20, "THINOUTLINE")
			percHP:SetTextColor(unpack(C["media"].datatextcolor1))
			if unit == "player" then
                percHP:SetPoint("LEFT", health, "RIGHT", 25, -10)
			elseif unit == "target" then
				percHP:SetPoint("RIGHT", health, "LEFT", -25, -10)
			end
			self:Tag(percHP, "[DuffedUI:perchp]")
			self.percHP = percHP
		end

		health.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		health.value:Point("RIGHT", health, "RIGHT", -4, -1)
		health.PostUpdate = D.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG

		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		if C["unitframes"].unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorTapping = true
			health.colorClass = true
			health.colorReaction = true
		end
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(18)
		power:Width(228)
		power:Point("TOP", health, "BOTTOM", 2, 9)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 5, -2)
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		power:SetFrameStrata("BACKGROUND")
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", D.Scale(-2), D.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder.shadow:Point("TOPLEFT", -3, 0)
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		if (unit == "player") then power.value:Point("LEFT", health, "LEFT", 4, -1) end
		power.PreUpdate = D.PreUpdatePower
		power.PostUpdate = D.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then power.Smooth = true end
		
		if C["unitframes"].unicolor == true then
			power.colorTapping = true
			power.colorClass = true
		else
			power.colorPower = true
		end
		
		-- portraits
		local portrait = CreateFrame("PlayerModel", nil, health)
		portrait:SetFrameLevel(health:GetFrameLevel())
		portrait:SetAllPoints(health)
		portrait:SetAlpha(.15)
		portrait.PostUpdate = D.PortraitUpdate 
		self.Portrait = portrait
		
		if D.myclass == "PRIEST" and C["unitframes"].weakenedsoulbar then
			local ws = CreateFrame("StatusBar", self:GetName().."_WeakenedSoul", power)
			ws:SetAllPoints(power)
			ws:SetStatusBarTexture(C["media"].normTex)
			ws:GetStatusBarTexture():SetHorizTile(false)
			ws:SetBackdrop(backdrop)
			ws:SetBackdropColor(unpack(C["media"].backdropcolor))
			ws:SetStatusBarColor(205/255, 20/255, 20/255)
			
			self.WeakenedSoul = ws
		end
		
		-- alt power bar
		local AltPowerBar = CreateFrame("StatusBar", self:GetName().."_AltPowerBar", self.Health)
		AltPowerBar:SetFrameLevel(0)
		AltPowerBar:SetFrameStrata("LOW")
		AltPowerBar:SetHeight(5)
		AltPowerBar:SetStatusBarTexture(C["media"].normTex)
		AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
		AltPowerBar:SetStatusBarColor(163/255,  24/255,  24/255)
		AltPowerBar:EnableMouse(true)

		AltPowerBar:Point("LEFT", DuffedUIInfoLeft, 2, -2)
		AltPowerBar:Point("RIGHT", DuffedUIInfoLeft, -2, 2)
		AltPowerBar:Point("TOP", DuffedUIInfoLeft, 2, -2)
		AltPowerBar:Point("BOTTOM", DuffedUIInfoLeft, -2, 2)
		
		AltPowerBar:SetBackdrop({
			bgFile = C["media"].blank, 
			edgeFile = C["media"].blank, 
			tile = false, tileSize = 0, edgeSize = 1, 
			insets = { left = 0, right = 0, top = 0, bottom = D.Scale(-1)}
		})
		AltPowerBar:SetBackdropColor(0, 0, 0)

		self.AltPowerBar = AltPowerBar
			
		if (unit == "player") then
			-- combat icon
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:Height(19)
			Combat:Width(19)
			Combat:SetPoint("TOP", health, "TOPLEFT", 0, 12)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			-- custom info (low mana warning)
			FlashInfo = CreateFrame("Frame", "DuffedUIFlashInfo", self)
			FlashInfo:SetScript("OnUpdate", D.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetAllPoints(health)
			FlashInfo.ManaLevel = D.SetFontString(FlashInfo, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			FlashInfo.ManaLevel:SetPoint("CENTER", health, "CENTER", 0, 1)
			self.FlashInfo = FlashInfo
			
			-- pvp status icon
			local PVP = health:CreateTexture(nil, "OVERLAY")
			PVP:SetHeight(D.Scale(32))
			PVP:SetWidth(D.Scale(32))
			PVP:SetPoint("TOPLEFT", health, "TOPRIGHT", -7, 7)
			self.PvP = PVP
			
			-- leader icon
			local Leader = InvFrame:CreateTexture(nil, "OVERLAY")
			Leader:Height(14)
			Leader:Width(14)
			Leader:Point("TOPLEFT", 2, 8)
			self.Leader = Leader
			
			-- master looter
			local MasterLooter = InvFrame:CreateTexture(nil, "OVERLAY")
			MasterLooter:Height(14)
			MasterLooter:Width(14)
			self.MasterLooter = MasterLooter
			self:RegisterEvent("PARTY_LEADER_CHANGED", D.MLAnchorUpdate)
			self:RegisterEvent("PARTY_MEMBERS_CHANGED", D.MLAnchorUpdate)
			
			-- experience --
			if D.level ~= MAX_PLAYER_LEVEL then
				local Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
				Experience:SetStatusBarTexture(normTex)
				Experience:SetStatusBarColor(0, 0.4, 1, .8)
				Experience:SetBackdrop(backdrop)
				Experience:SetBackdropColor(unpack(C["media"].backdropcolor))
				Experience:SetOrientation("VERTICAL")
				Experience:Size(5, DuffedUIMinimap:GetHeight() + 17)
				Experience:Point("TOPLEFT", DuffedUIMinimap, "TOPLEFT", -9, -2)
				Experience:SetFrameLevel(2)
				Experience.Tooltip = true						
				Experience.Rested = CreateFrame("StatusBar", nil, self)
				Experience.Rested:SetParent(Experience)
				Experience.Rested:SetAllPoints(Experience)
				Experience.Rested:SetStatusBarTexture(normTex)
				Experience.Rested:SetStatusBarColor(1, 0, 1, 0.2)

				-- border for the experience bar
				Experience:CreateBackdrop()
				Experience.backdrop:CreateShadow()

				local Resting = Experience:CreateTexture(nil, "OVERLAY")
				Resting:Size(D.Scale(20))
				Resting:SetPoint("RIGHT", Experience, "LEFT", 0, 0)
				Resting:SetTexture([=[Interface\CharacterFrame\UI-StateIcon]=])
				Resting:SetTexCoord(0, 0.5, 0, 0.421875)
				self.Resting = Resting
				self.Experience = Experience
			end

			-- reputation bar for max level character
			if D.level == MAX_PLAYER_LEVEL then
				local Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
				Reputation:SetStatusBarTexture(normTex)
				Reputation:SetBackdrop(backdrop)
				Reputation:SetBackdropColor(unpack(C["media"].backdropcolor))
				Reputation:SetOrientation("VERTICAL")
				Reputation:Size(5, DuffedUIMinimap:GetHeight() + 17)
				Reputation:Point("TOPLEFT", DuffedUIMinimap, "TOPLEFT", -9, -2)
				Reputation:SetFrameLevel(2)

				-- border for the Reputation bar
				Reputation:CreateBackdrop()
				Reputation.backdrop:CreateShadow()

				Reputation.PostUpdate = D.UpdateReputationColor
				Reputation.Tooltip = true
				self.Reputation = Reputation
			end
			
			-- Vengeance Plugin
			if C["unitframes"].vengeancebar then
				local vge
				if not C["general"].threatbar or C["chat"].background == false or not DuffedUIChatBackgroundRight then
					vge = CreateFrame("StatusBar", "VengeanceBar", DuffedUIInfoRight)
					vge:Point("TOPLEFT", 2, -2)
					vge:Point("BOTTOMRIGHT", -2, 2)
					vge:SetFrameStrata("MEDIUM")
					vge:SetFrameLevel(2)
				else
					vge = CreateFrame("StatusBar", "VengeanceBar", DuffedUITabsRightBackground)
					vge:Point("TOPLEFT", 2, -2)
					vge:Point("BOTTOMRIGHT", -2, 2)
					vge:SetFrameStrata("MEDIUM")
					vge:SetFrameLevel(2)
				end
				vge:SetStatusBarTexture(normTex)
				vge:SetStatusBarColor(163/255,  24/255,  24/255)
				
				vge.Text = vge:CreateFontString(nil, "OVERLAY")
				vge.Text:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
				vge.Text:SetPoint("CENTER")
				
				vge.bg = vge:CreateTexture(nil, 'BORDER')
				vge.bg:SetAllPoints(vge)
				vge.bg:SetTexture(unpack(C["media"].backdropcolor))
				
				self.Vengeance = vge
			end
			
			-- show druid mana when shapeshifted in bear, cat or whatever
			if D.myclass == "DRUID" then
				local DruidManaUpdate = CreateFrame("Frame")
				DruidManaUpdate:SetScript("OnUpdate", function() D.UpdateDruidManaText(self) end)

				local DruidManaText = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
				DruidManaText:SetTextColor( 1, 0.49, 0.04 )
				self.DruidManaText = DruidManaText
			end
			
			-- classbars
			if C["unitframes"].classbar then
				if D.myclass == "MAGE" then
					local mb = CreateFrame("Frame", "DuffedUIArcaneBar", self)
					mb:Point("TOP", power, "BOTTOM", -52, -1)
					mb:Size(100, 5)
					mb:SetBackdrop(backdrop)
					mb:SetBackdropColor(0, 0, 0)
					mb:SetBackdropBorderColor(0, 0, 0)				
					
					for i = 1, 6 do
						mb[i] = CreateFrame("StatusBar", "DuffedUIArcaneBar"..i, mb)
						mb[i]:Height(5)
						mb[i]:SetStatusBarTexture(C["media"].normTex)
						
						if i == 1 then
							mb[i]:Width(176 / 6)
							mb[i]:SetPoint("LEFT", mb, "LEFT", 0, 0)
							mb[i]:CreateBackdrop()
						else
							mb[i]:Width(176 / 6)
							mb[i]:SetPoint("LEFT", mb[i-1], "RIGHT", 6, 0)
							mb[i]:CreateBackdrop()
						end
						
						mb[i].bg = mb[i]:CreateTexture(nil, 'ARTWORK')
					end
					
					mb:SetScript("OnShow", D.UpdateMageClassBarVisibility)
					mb:SetScript("OnHide", D.UpdateMageClassBarVisibility)
					
					self.ArcaneChargeBar = mb

					if C["unitframes"].runeofpower then
						local rp = CreateFrame("Frame", "DuffedUIRunePower", self)
						rp:Point("TOP", power, "BOTTOM", -50, -1)
						rp:SetWidth(100)
						rp:SetHeight(5)
						rp:SetBackdrop(backdrop)
						rp:SetBackdropColor(0, 0, 0)
						rp:SetBackdropBorderColor(0, 0, 0)

						for i = 1, 2 do
							rp[i] = CreateFrame("StatusBar", "DuffedUIRunePower"..i, rp)
							rp[i]:Height(5)
							rp[i]:SetStatusBarTexture(C.media.normTex)

							if i == 1 then
								rp[i]:Width(198 / 2)
								rp[i]:SetPoint("LEFT", rp, "LEFT", 0, 0)
								rp[i]:CreateBackdrop()
							else
								rp[i]:Width(198 / 2)
								rp[i]:SetPoint("LEFT", rp[i - 1], "RIGHT", 6, 0)
								rp[i]:CreateBackdrop()
							end

							rp[i].bg = rp[i]:CreateTexture(nil, 'ARTWORK')
						end

						rp:CreateBackdrop()

						rp:SetScript("OnShow", D.UpdateMageClassBarVisibility)
						rp:SetScript("OnHide", D.UpdateMageClassBarVisibility)

						self.RunePower = rp
					end
				end
				
				if D.myclass == "DRUID" then
					
					local DruidManaBackground = CreateFrame("Frame", nil, self)
					DruidManaBackground:Point("TOP", power, "BOTTOM", 0, -2)
					DruidManaBackground:Size(176, 2)
					DruidManaBackground:SetFrameStrata("MEDIUM")
					DruidManaBackground:SetFrameLevel(8)
					DruidManaBackground:SetTemplate("Default")
					DruidManaBackground:SetBackdropBorderColor(0, 0, 0, 0)

					local DruidManaBarStatus = CreateFrame("StatusBar", nil, DruidManaBackground)
					DruidManaBarStatus:SetPoint("LEFT", DruidManaBackground, "LEFT", 0, 0)
					DruidManaBarStatus:SetSize(DruidManaBackground:GetWidth(), DruidManaBackground:GetHeight())
					DruidManaBarStatus:SetStatusBarTexture(normTex)
					DruidManaBarStatus:SetStatusBarColor(.30, .52, .90)

					self.DruidManaBackground = DruidManaBackground
					self.DruidMana = DruidManaBarStatus

					DruidManaBackground.FrameBackdrop = CreateFrame("Frame", nil, DruidManaBackground)
					DruidManaBackground.FrameBackdrop:SetTemplate("Default")
					DruidManaBackground.FrameBackdrop:SetPoint("TOPLEFT", -2, 2)
					DruidManaBackground.FrameBackdrop:SetPoint("BOTTOMRIGHT", 2, -2)
					DruidManaBackground.FrameBackdrop:SetFrameLevel(DruidManaBackground:GetFrameLevel() - 1)
					
					DruidManaBackground:SetScript("OnShow", function() D.DruidBarDisplay(self, false) end)
					DruidManaBackground:SetScript("OnUpdate", function() D.DruidBarDisplay(self, true) end)
					DruidManaBackground:SetScript("OnHide", function() D.DruidBarDisplay(self, false) end)

					local eclipseBar = CreateFrame('Frame', nil, self)
					eclipseBar:Point("LEFT", DruidManaBackground, "LEFT", 0, 0)
					eclipseBar:Size(176, 5)
					eclipseBar:SetFrameStrata("MEDIUM")
					eclipseBar:SetFrameLevel(8)
					eclipseBar:SetBackdropBorderColor(0,0,0,0)
					
					local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
					lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
					lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
					lunarBar:SetStatusBarTexture(normTex)
					lunarBar:SetStatusBarColor(.30, .52, .90)
					eclipseBar.LunarBar = lunarBar

					local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
					solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
					solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
					solarBar:SetStatusBarTexture(normTex)
					solarBar:SetStatusBarColor(.80, .82,  .60)
					eclipseBar.SolarBar = solarBar

					local eclipseBarText = eclipseBar:CreateFontString(nil, 'OVERLAY')
					eclipseBarText:SetPoint('TOP', eclipseBar, 0, 25)
					eclipseBarText:SetPoint('BOTTOM', eclipseBar)
					eclipseBarText:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
					eclipseBarText:SetShadowOffset(D.mult, -D.mult)
					eclipseBarText:SetShadowColor(0, 0, 0, 0.4)
					eclipseBar.PostUpdatePower = D.EclipseDirection
					
					-- hide "low mana" text on load if eclipseBar is show
					if eclipseBar and eclipseBar:IsShown() then FlashInfo.ManaLevel:SetAlpha(0) end

					self.EclipseBar = eclipseBar
					self.EclipseBar.Text = eclipseBarText
					
					eclipseBar.FrameBackdrop = CreateFrame("Frame", nil, eclipseBar)
					eclipseBar.FrameBackdrop:SetTemplate("Default")
					eclipseBar.FrameBackdrop:CreateShadow("Default")
					eclipseBar.FrameBackdrop:SetPoint("TOPLEFT", D.Scale(-2), D.Scale(2))
					eclipseBar.FrameBackdrop:SetPoint("BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
					eclipseBar.FrameBackdrop:SetFrameLevel(eclipseBar:GetFrameLevel() - 1)
				end

				-- set holy power bar or shard bar
				if D.myclass == "WARRIOR" and C["unitframes"].showstatuebar then
					-- statue bar
					local bar = CreateFrame("StatusBar", "DuffedUIStatueBar", self)
					bar:SetWidth(5)
					bar:SetHeight(29)
					bar:Point("LEFT", power, "RIGHT", 7, 5)
					bar:SetStatusBarTexture(C["media"].normTex)
					bar:SetOrientation("VERTICAL")
					bar.bg = bar:CreateTexture(nil, 'ARTWORK')
					
					bar.background = CreateFrame("Frame", "DuffedUIStatue", bar)
					bar.background:SetAllPoints()
					bar.background:SetFrameLevel(bar:GetFrameLevel() - 1)
					bar.background:SetBackdrop(backdrop)
					bar.background:SetBackdropColor(0, 0, 0)
					bar.background:SetBackdropBorderColor(0,0,0)
					
					bar:CreateBackdrop()
					bar.backdrop:CreateShadow()
					
					self.Statue = bar				
				end

				-- set holy power bar or shard bar
				if D.myclass == "WARLOCK" then
					local wb = CreateFrame("Frame", "DuffedUIWarlockSpecBars", self)
					wb:Point("TOP", power, "BOTTOM", 0, -1)
					wb:Size(150, 5)
					wb:SetBackdrop(backdrop)
					wb:SetBackdropColor(0, 0, 0)
					wb:SetBackdropBorderColor(0, 0, 0)	
					
					for i = 1, 4 do
						wb[i] = CreateFrame("StatusBar", "DuffedUIWarlockSpecBars"..i, wb)
						wb[i]:Height(5)
						wb[i]:SetStatusBarTexture(C["media"].normTex)
						
						if i == 1 then
							wb[i]:Width((150 / 4) - 2)
							wb[i]:SetPoint("LEFT", wb, "LEFT", 0, 0)
							wb[i]:CreateBackdrop()
						else
							wb[i]:Width((150 / 4) - 1)
							wb[i]:SetPoint("LEFT", wb[i - 1], "RIGHT", 6, 0)
							wb[i]:CreateBackdrop()
						end
						
						wb[i].bg = wb[i]:CreateTexture(nil, 'ARTWORK')
					end
					
					self.WarlockSpecBars = wb				
				end
				
				-- set holy power bar or shard bar
				if D.myclass == "PALADIN" then
					local bars = CreateFrame("Frame", nil, self)
					bars:SetPoint("TOP", power, "BOTTOM", 0, -1)
					bars:Width(158)
					bars:Height(5)
					bars:SetBackdrop(backdrop)
					bars:SetBackdropColor(0, 0, 0)
					bars:SetBackdropBorderColor(0,0,0,0)
					
					for i = 1, 5 do					
						bars[i]=CreateFrame("StatusBar", self:GetName().."_HolyPower"..i, bars)
						bars[i]:Height(5)					
						bars[i]:SetStatusBarTexture(normTex)
						bars[i]:GetStatusBarTexture():SetHorizTile(false)
						bars[i]:SetStatusBarColor(228/255,225/255,16/255)

						bars[i].bg = bars[i]:CreateTexture(nil, "BORDER")
						bars[i].bg:SetTexture(228/255,225/255,16/255)
						
						if i == 1 then
							bars[i]:SetPoint("LEFT", bars)
							bars[i]:Width(30)
							bars[i].bg:SetAllPoints(bars[i])
						else
							bars[i]:Point("LEFT", bars[i-1], "RIGHT", 2, 0)
							bars[i]:Width(150 / 5)
							bars[i].bg:SetAllPoints(bars[i])
						end
						
						bars[i].bg:SetTexture(normTex)					
						bars[i].bg:SetAlpha(.15)
					end
					
					bars:CreateBackdrop()
					self.HolyPower = bars
				end

				-- deathknight runes
				if D.myclass == "DEATHKNIGHT" then
					local Runes = CreateFrame("Frame", nil, self)
					Runes:Point("LEFT", power, "BOTTOMLEFT", 15, -3)
					Runes:Size(100, 5)
					Runes:SetFrameLevel(self:GetFrameLevel() + 3)
					Runes:SetFrameStrata("MEDIUM")

					for i = 1, 6 do
						Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
						Runes[i]:SetHeight(D.Scale(5))

						if i == 1 then
							Runes[i]:SetPoint("LEFT", Runes, "LEFT", 0, 0)
							Runes[i]:SetWidth(D.Scale(176 /6))
						else
							Runes[i]:SetPoint("LEFT", Runes[i-1], "RIGHT", D.Scale(5), 0)
							Runes[i]:SetWidth(D.Scale(176 /6))
						end
						Runes[i]:SetStatusBarTexture(normTex)
						Runes[i]:GetStatusBarTexture():SetHorizTile(false)
						Runes[i]:SetBackdrop(backdrop)
						Runes[i]:SetBackdropColor(0,0,0)
						Runes[i]:SetFrameLevel(4)
                    
						Runes[i].bg = Runes[i]:CreateTexture(nil, "BORDER")
						Runes[i].bg:SetAllPoints(Runes[i])
						Runes[i].bg:SetTexture(normTex)
						Runes[i].bg.multiplier = 0.3
					
						Runes[i].border = CreateFrame("Frame", nil, Runes[i])
						Runes[i].border:SetPoint("TOPLEFT", Runes[i], "TOPLEFT", D.Scale(-2), D.Scale(2))
						Runes[i].border:SetPoint("BOTTOMRIGHT", Runes[i], "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
						Runes[i].border:SetFrameStrata("MEDIUM")
						Runes[i].border:SetFrameLevel(4)					
						Runes[i].border:SetTemplate("Default")
					end

                    self.Runes = Runes
					
					-- statue bar
					if C["unitframes"].showstatuebar then
						local bar = CreateFrame("StatusBar", "DuffedUIStatueBar", self)
						bar:SetWidth(5)
						bar:SetHeight(29)
						bar:Point("LEFT", power, "RIGHT", 7, 5)
						bar:SetStatusBarTexture(C["media"].normTex)
						bar:SetOrientation("VERTICAL")
						bar.bg = bar:CreateTexture(nil, 'ARTWORK')
						
						bar.background = CreateFrame("Frame", "DuffedUIStatue", bar)
						bar.background:SetAllPoints()
						bar.background:SetFrameLevel(bar:GetFrameLevel() - 1)
						bar.background:SetBackdrop(backdrop)
						bar.background:SetBackdropColor(0, 0, 0)
						bar.background:SetBackdropBorderColor(0,0,0)
						
						bar:CreateBackdrop()
						bar.backdrop:CreateShadow()
						
						self.Statue = bar
					end
                end
				
				-- Monk harmony bar
				if D.myclass == "MONK" then
					local hb = CreateFrame("Frame", "DuffedUIHarmony", health)
					hb:Point("TOP", power, "BOTTOM", 0, -1)
					hb:Size(155, 5)
					hb:SetBackdrop(backdrop)
					hb:SetBackdropColor(0, 0, 0)
					hb:SetBackdropBorderColor(0, 0, 0)	
					
					for i = 1, 5 do
						hb[i] = CreateFrame("StatusBar", "DuffedUIHarmonyBar"..i, hb)
						hb[i]:Height(5)
						hb[i]:SetStatusBarTexture(C["media"].normTex)
						
						if i == 1 then
							hb[i]:Width(155 / 5)
							hb[i]:SetPoint("LEFT", hb, "LEFT", 0, 0)
						else
							hb[i]:Width((150 / 5))
							hb[i]:SetPoint("LEFT", hb[i - 1], "RIGHT", 2, 0)
						end
					end
					
					hb:CreateBackdrop()
					self.HarmonyBar = hb
					
					if C["unitframes"].showstatuebar then
						-- statue bar
						local bar = CreateFrame("StatusBar", "DuffedUIStatueBar", self)
						bar:SetWidth(5)
						bar:SetHeight(29)
						bar:Point("LEFT", power, "RIGHT", 7, 5)
						bar:SetStatusBarTexture(C["media"].normTex)
						bar:SetOrientation("VERTICAL")
						bar.bg = bar:CreateTexture(nil, 'ARTWORK')
						
						bar.background = CreateFrame("Frame", "DuffedUIStatue", bar)
						bar.background:SetAllPoints()
						bar.background:SetFrameLevel(bar:GetFrameLevel() - 1)
						bar.background:SetBackdrop(backdrop)
						bar.background:SetBackdropColor(0, 0, 0)
						bar.background:SetBackdropBorderColor(0,0,0)
						
						bar:CreateBackdrop()
						bar.backdrop:CreateShadow()
						
						self.Statue = bar
					end
				end
				
				-- priest
				if D.myclass == "PRIEST" then
					local pb = CreateFrame("Frame", "DuffedUIShadowOrbsBar", self)
					pb:Point("TOP", power, "BOTTOM", 0, -1)
					pb:Size(150, 5)
					pb:SetBackdrop(backdrop)
					pb:SetBackdropColor(0, 0, 0)
					pb:SetBackdropBorderColor(0, 0, 0)	
					
					for i = 1, 3 do
						pb[i] = CreateFrame("StatusBar", "DuffedUIShadowOrbsBar"..i, pb)
						pb[i]:Height(5)
						pb[i]:SetStatusBarTexture(C["media"].normTex)
						
						if i == 1 then
							pb[i]:Width((150 / 3) - 2)
							pb[i]:SetPoint("LEFT", pb, "LEFT", 0, 0)
						else
							pb[i]:Width((150 / 3) - 1)
							pb[i]:SetPoint("LEFT", pb[i - 1], "RIGHT", 2, 0)
						end
					end
					
					pb:CreateBackdrop()
					
					self.ShadowOrbsBar = pb
					
					-- statue bar
					if C["unitframes"].showstatuebar then
						local bar = CreateFrame("StatusBar", "DuffedUIStatueBar", self)
						bar:SetWidth(5)
						bar:SetHeight(29)
						bar:Point("LEFT", power, "RIGHT", 7, 5)
						bar:SetStatusBarTexture(C["media"].normTex)
						bar:SetOrientation("VERTICAL")
						bar.bg = bar:CreateTexture(nil, 'ARTWORK')
						
						bar.background = CreateFrame("Frame", "DuffedUIStatue", bar)
						bar.background:SetAllPoints()
						bar.background:SetFrameLevel(bar:GetFrameLevel() - 1)
						bar.background:SetBackdrop(backdrop)
						bar.background:SetBackdropColor(0, 0, 0)
						bar.background:SetBackdropBorderColor(0,0,0)
						
						bar:CreateBackdrop()
						bar.backdrop:CreateShadow()
						
						self.Statue = bar
					end
				end
				
				-- shaman totem bar
				if D.myclass == "SHAMAN" then
					local TotemBar = {}
					TotemBar.Destroy = true
					for i = 1, 4 do
						TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
						TotemBar[i]:SetFrameLevel(self:GetFrameLevel() + 3)
						
						if i == 1 then TotemBar[i]:Point("LEFT", power, "BOTTOMLEFT", 30, -3) else TotemBar[i]:SetPoint("TOPLEFT", TotemBar[i - 1], "TOPRIGHT", D.Scale(6), 0) end
						
						TotemBar[i]:SetStatusBarTexture(normTex)
						TotemBar[i]:SetHeight(D.Scale(5))
						TotemBar[i]:SetWidth(D.Scale(150) / 4)
						TotemBar[i]:SetFrameLevel(4)
				
						TotemBar[i]:SetBackdrop(backdrop)
						TotemBar[i]:SetBackdropColor(0, 0, 0, 1)
						TotemBar[i]:SetMinMaxValues(0, 1)

						TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
						TotemBar[i].bg:SetAllPoints(TotemBar[i])
						TotemBar[i].bg:SetTexture(normTex)
						TotemBar[i].bg.multiplier = 0.2
					
						TotemBar[i].border = CreateFrame("Frame", nil, TotemBar[i])
						TotemBar[i].border:SetPoint("TOPLEFT", TotemBar[i], "TOPLEFT", D.Scale(-2), D.Scale(2))
						TotemBar[i].border:SetPoint("BOTTOMRIGHT", TotemBar[i], "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
						TotemBar[i].border:SetFrameStrata("MEDIUM")
						TotemBar[i].border:SetFrameLevel(4)
						TotemBar[i].border:CreateShadow("Default")
						TotemBar[i].border:SetTemplate("Default")
					end
					
				self.TotemBar = TotemBar
				end
			end	
			
			-- script for pvp status and low mana
			self:SetScript("OnEnter", function(self)
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Hide()
				end
				FlashInfo.ManaLevel:Hide()
				UnitFrame_OnEnter(self) 
			end)
			self:SetScript("OnLeave", function(self) 
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Show()
				end
				FlashInfo.ManaLevel:Show()
				UnitFrame_OnLeave(self) 
			end)
		end
		
		if (unit == "target") then			
			-- Unit name on target
			local Name = health:CreateFontString(nil, "OVERLAY")
			Name:Point("LEFT", health, "LEFT", 4, 0)
			Name:SetJustifyH("LEFT")
			Name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			Name:SetShadowOffset(1.25, -1.25)

			self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namelong] [DuffedUI:diffcolor][level] [shortclassification]')
			self.Name = Name
		end

		if (unit == "target" and C["unitframes"].targetauras) or (unit == "player" and C["unitframes"].playerauras) then
			local buffs = CreateFrame("Frame", nil, self)
			local debuffs = CreateFrame("Frame", nil, self)
			
			if (D.myclass == "SHAMAN" or D.myclass == "DEATHKNIGHT" or D.myclass == "PALADIN" or D.myclass == "WARLOCK") and (C["unitframes"].playerauras) and (unit == "player") then
				if D.lowversion then
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 34)
				else
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 38)
				end
			else
				if D.lowversion then
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 26)
				else
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 30)
				end
			end
			
			if D.lowversion then
				buffs:SetHeight(21.5)
				buffs:SetWidth(186)
				buffs.size = 21.5
				buffs.num = 8
				
				debuffs:SetHeight(21.5)
				debuffs:SetWidth(186)
				debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", 0, 2)
				debuffs.size = 21.5	
				debuffs.num = 24
			else				
				buffs:SetHeight(26)
				buffs:SetWidth(218)
				buffs.size = 26
				buffs.num = 9
				
				debuffs:SetHeight(26)
				debuffs:SetWidth(218)
				debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", 4, 2)
				debuffs.size = 26
				debuffs.num = 27
			end
						
			buffs.spacing = 2
			buffs.initialAnchor = 'TOPLEFT'
			buffs["growth-y"] = "UP"
			buffs["growth-x"] = "RIGHT"
			buffs.PostCreateIcon = D.PostCreateAura
			buffs.PostUpdateIcon = D.PostUpdateAura
			self.Buffs = buffs	
						
			debuffs.spacing = 2
			debuffs.initialAnchor = 'TOPRIGHT'
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = D.PostCreateAura
			debuffs.PostUpdateIcon = D.PostUpdateAura
			
			-- an option to show only our debuffs on target
			if unit == "target" then
				debuffs.onlyShowPlayer = C["unitframes"].onlyselfdebuffs
			end
			
			self.Debuffs = debuffs
		end
		
		-- cast bar for player and target
		if C["castbar"].enable == true then
			-- Anchor for targetcastbar
			local tcb = CreateFrame("Frame", "TCBanchor", UIParent)
			tcb:SetTemplate("Default")
			tcb:Size(225, 18)
			tcb:Point("BOTTOM", UIParent, "BOTTOM", 0, 380)
			tcb:SetClampedToScreen(true)
			tcb:SetMovable(true)
			tcb:SetBackdropColor(0, 0, 0)
			tcb:SetBackdropBorderColor(1, 0, 0)
			tcb.text = D.SetFontString(tcb, C["media"].font, 12)
			tcb.text:SetPoint("CENTER")
			tcb.text:SetText("Move Targetcastbar")
			tcb:Hide()
			tinsert(D.AllowFrameMoving, TCBanchor)
			
			-- castbar of player and target
			local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
			castbar:SetStatusBarTexture(normTex)
			if unit == "player" then
				castbar:Height(21)
			elseif unit == "target" then
				castbar:Width(225)
				castbar:Height(18)
				castbar:Point("LEFT", TCBanchor, "LEFT", 0, 0)
			end
			
			castbar.CustomTimeText = D.CustomTimeText
			castbar.CustomDelayText = D.CustomCastDelayText
			castbar.PostCastStart = D.castbar
			castbar.PostChannelStart = D.castbar

			castbar.time = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			castbar.time:Point("RIGHT", castbar, "RIGHT", -5, 0)
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			castbar.Text:Point("LEFT", castbar, "LEFT", 6, 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			-- Border
			castbar:CreateBackdrop()
			castbar.backdrop:CreateShadow()
			
			if C["castbar"].cbicons then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:SetTemplate("Default")
				castbar.button:CreateShadow()
				
				if unit == "player" then
					castbar.button:Size(25)
					castbar.button:Point("RIGHT",castbar,"LEFT", -4, 0)
				elseif unit == "target" then
					castbar.button:Size(25)
					castbar.button:Point("BOTTOM", castbar, "TOP", 0, 5)
				end

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
				castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			end
			
			-- cast bar latency on player
			if unit == "player" and C["castbar"].cblatency then
				castbar.safezone = castbar:CreateTexture(nil, "ARTWORK")
				castbar.safezone:SetTexture(normTex)
				castbar.safezone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
				castbar.SafeZone = castbar.safezone
			end

			if unit == "player" and C["castbar"].spark then
				castbar.Spark = castbar:CreateTexture(nil, "OVERLAY")
				castbar.Spark:SetHeight(40)
				castbar.Spark:SetWidth(10)
				castbar.Spark:SetBlendMode("ADD")
			end

			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
		
		-- add combat feedback support
		if C["unitframes"].combatfeedback == true then
			local CombatFeedbackText 
			CombatFeedbackText = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			CombatFeedbackText:SetPoint("CENTER", 0, 1)
			CombatFeedbackText.colors = {
				DAMAGE = {0.69, 0.31, 0.31},
				CRUSHING = {0.69, 0.31, 0.31},
				CRITICAL = {0.69, 0.31, 0.31},
				GLANCING = {0.69, 0.31, 0.31},
				STANDARD = {0.84, 0.75, 0.65},
				IMMUNE = {0.84, 0.75, 0.65},
				ABSORB = {0.84, 0.75, 0.65},
				BLOCK = {0.84, 0.75, 0.65},
				RESIST = {0.84, 0.75, 0.65},
				MISS = {0.84, 0.75, 0.65},
				HEAL = {0.33, 0.59, 0.33},
				CRITHEAL = {0.33, 0.59, 0.33},
				ENERGIZE = {0.31, 0.45, 0.63},
				CRITENERGIZE = {0.31, 0.45, 0.63},
			}
			self.CombatFeedbackText = CombatFeedbackText
		end
		
		if C["unitframes"].healcomm then
			local mhpb = CreateFrame('StatusBar', nil, self.Health)
			mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			if D.lowversion then
				mhpb:SetWidth(186)
			else
				mhpb:SetWidth(250)
			end
			mhpb:SetStatusBarTexture(normTex)
			mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
			mhpb:SetMinMaxValues(0,1)

			local ohpb = CreateFrame('StatusBar', nil, self.Health)
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:SetWidth(250)
			ohpb:SetStatusBarTexture(normTex)
			ohpb:SetStatusBarColor(0, 1, 0, 0.25)

			self.HealPrediction = {
				myBar = mhpb,
				otherBar = ohpb,
				maxOverflow = 1,
			}
		end
		
		-- player aggro
		if C["unitframes"].playeraggro == true then
			table.insert(self.__elements, D.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', D.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', D.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', D.UpdateThreat)
		end

		if unit == "player" then
			self:RegisterEvent("PLAYER_ENTERING_WORLD", D.updateAllElements)
		end
	end
	
	------------------------------------------------------------------------
	--	Target of Target unit layout
	------------------------------------------------------------------------
	
	if (unit == "targettarget") then
		-- create panel if higher version
		local panel = CreateFrame("Frame", nil, self)
		if not D.lowversion then
			panel:SetTemplate("Default")
			panel:Size(129, 17)
			panel:Point("BOTTOM", self, "BOTTOM", 0, D.Scale(0))
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			panel:SetAlpha(0)
			self.panel = panel
		end
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(17)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for ToT
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", D.Scale(-2), D.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
		
		self.Health = health
		self.Health.bg = healthBG
		health.PostUpdate = D.PostUpdatePetColor
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		if C["unitframes"].unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorTapping = true
			health.colorClass = true
			health.colorReaction = true
		end
		
		-- Unitframe Lines
		-- Creating an Invisible Line To Anchor Player and Target Frames Properly.
		local line1 = CreateFrame("Frame", "DuffedUIline1", DuffedUITargetTarget)
		line1:SetTemplate("")
		line1:Size(1, 1)
		line1:Point("CENTER", health, "CENTER", 0, 0)
		line1:SetFrameLevel(0)
		line1:SetAlpha(0)
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(3)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 9, 1)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", -9, -2)
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", D.Scale(-2), D.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true
		if C["unitframes"].showsmooth == true then power.Smooth = true end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		if C["unitframes"].unicolor == true then
			power.colorTapping = true
			power.colorClass = true
		else
			power.colorPower = true
		end
				
		self.Power = power
		self.Power.bg = powerBG

		if C["unitframes"].showsmooth == true then power.Smooth = true end
		
		-- name and level
		local Name = health:CreateFontString(nil, "OVERLAY")
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:nameshort] [DuffedUI:diffcolor][level] [shortclassification]')
		Name:SetPoint("CENTER", health, "CENTER", 2, 2)
		Name:SetJustifyH("CENTER")
		Name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		self.Name = Name
		
		-- portraits
		local portrait = CreateFrame("PlayerModel", nil, health)
		portrait.PostUpdate = function(self) self:SetAlpha(0) self:SetAlpha(0.15) end -- edit the 0.15 to the alpha you want
		portrait:SetAllPoints(health)
		table.insert(self.__elements, D.HidePortrait)
		self.Portrait = portrait
		
		if C["unitframes"].totdebuffs == true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:Height(20)
			debuffs:Width(300)
			debuffs.size = C["unitframes"].totdbsize
			debuffs.spacing = 3
			debuffs.num = 5

			debuffs:Point("TOPLEFT", health, "TOPLEFT", -1.5, 24)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = D.PostCreateAura
			debuffs.PostUpdateIcon = D.PostUpdateAura
			self.Debuffs = debuffs
		end
	end
	
	------------------------------------------------------------------------
	--	Pet unit layout
	------------------------------------------------------------------------
	
	if (unit == "pet") then
		-- create panel if higher version
		local panel = CreateFrame("Frame", nil, self)
		if not D.lowversion then
			panel:SetTemplate("Default")
			panel:Size(129, 17)
			panel:Point("BOTTOM", self, "BOTTOM", 0, 0)
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			panel:SetAlpha(0)
			self.panel = panel
		end
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(16)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", D.Scale(-2), D.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder
		
		health.PostUpdate = D.PostUpdatePetColor
		self.Health = health
		self.Health.bg = healthBG
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true	
			health.colorClass = true
			health.colorReaction = true	
			if D.myclass == "HUNTER" then
				health.colorHappiness = true
			end
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", self.Health, "CENTER", 0, -1)
		Name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetJustifyH("CENTER")
		Name:SetShadowOffset(1.25, -1.25)

		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namemedium]')
		self.Name = Name
		
		if (C["castbar"].enable == true) then
			local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
			castbar:SetStatusBarTexture(normTex)
			castbar:Height(3)
			self.Castbar = castbar
			
			castbar:Point("TOPLEFT", health, "BOTTOMLEFT", 0, 16)
			castbar:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, 16)

			castbar.bg = castbar:CreateTexture(nil, "BORDER")
			castbar.bg:SetTexture(normTex)
			castbar.bg:SetVertexColor(0, 0, 0)
			castbar:SetFrameLevel(6)
			
			castbar.CustomTimeText = D.CustomTimeText
			castbar.CustomTimeText = D.CustomCastDelayText
			castbar.PostCastStart = D.castbar
			castbar.PostChannelStart = D.castbar
			
			self.Castbar.Time = castbar.time
		end
		
		-- portraits
		local portrait = CreateFrame("PlayerModel", nil, health)
		portrait.PostUpdate = function(self) self:SetAlpha(0) self:SetAlpha(0.15) end -- edit the 0.15 to the alpha you want
		portrait:SetAllPoints(health)
		table.insert(self.__elements, D.HidePortrait)
		self.Portrait = portrait
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit, health and bar color sometime being "grayish".
		self:RegisterEvent("UNIT_PET", D.updateAllElements)
	end
	
	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(17)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", D.Scale(-2), D.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)

		health.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		health.value:Point("RIGHT", 0, 1)
		health.PostUpdate = D.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end	
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(3)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 85, 0)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", -9, -3)
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", D.Scale(-2), D.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true
		power.colorPower = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("LEFT", health, "LEFT", 2, 0)
		Name:SetJustifyH("CENTER")
		Name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namelong]')
		self.Name = Name
		
		-- create debuff for focus
		if C["unitframes"].focusdebuffs then
			local debuffs = CreateFrame("Frame", nil, self)
			debuffs:SetHeight(26)
			debuffs:SetWidth(200)
			debuffs:Point("RIGHT", self, "LEFT", -4, 6)
			debuffs.size = 21
			debuffs.num = 4
			debuffs.spacing = 2
			debuffs.initialAnchor = "RIGHT"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = D.PostCreateAura
			debuffs.PostUpdateIcon = D.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- castbar
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
		castbar:SetStatusBarTexture(normTex)
		castbar:SetFrameLevel(10)
		castbar:Height(10)
		castbar:Width(201)
		castbar:SetPoint("LEFT", 8, 0)
		castbar:SetPoint("RIGHT", -16, 0)
		castbar:SetPoint("BOTTOM", 0, -12)
			
		castbar:CreateBackdrop()
			
		castbar.time = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0.84, 0.75, 0.65)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = D.CustomTimeText

		castbar.Text = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
		castbar.CustomTimeText = D.CustomCastDelayText
		castbar.PostCastStart = D.castbar
		castbar.PostChannelStart = D.castbar
			
		castbar.button = CreateFrame("Frame", nil, castbar)
		castbar.button:Height(castbar:GetHeight()+4)
		castbar.button:Width(castbar:GetHeight()+4)
		castbar.button:Point("LEFT", castbar, "RIGHT", 4, 0)
		castbar.button:SetTemplate("Default")
		
		castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
		castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
		castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
		castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			
		self.Castbar = castbar
		self.Castbar.Icon = castbar.icon
		self.Castbar.Time = castbar.time
	end
	
	------------------------------------------------------------------------
	--	Focus target unit layout
	------------------------------------------------------------------------

	if (unit == "focustarget") then
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(10)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", D.Scale(-2), D.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)

		self.Health = health
		self.Health.bg = healthBG
		health.PostUpdate = D.PostUpdatePetColor
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
	
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, -1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:nameshort]')
		self.Name = Name
	end

	------------------------------------------------------------------------
	--	Arena or boss units layout (both mirror'd)
	------------------------------------------------------------------------
	
	if (unit and unit:find("arena%d") and C["unitframes"].arena == true) or (unit and unit:find("boss%d") and C["unitframes"].showboss == true) then
		-- Right-click focus on arena or boss units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(22)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)

		-- Border for Health
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", D.Scale(-2), D.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)

		health.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		health.value:Point("LEFT", 2, 0.5)
		health.PostUpdate = D.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(3)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 85, 0)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", -9, -3)
		power:SetStatusBarTexture(normTex)
		power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
		
		-- Border for Power
		local PowerBorder = CreateFrame("Frame", nil, power)
		PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", D.Scale(-2), D.Scale(2))
		PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		PowerBorder:SetTemplate("Default")
		PowerBorder:CreateShadow("Default")
		PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
		self.PowerBorder = PowerBorder
		
		power.frequentUpdates = true
		power.colorPower = true
		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		power.value:Point("RIGHT", -2, 0.5)
		power.PreUpdate = D.PreUpdatePower
		power.PostUpdate = D.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		Name.frequentUpdates = 0.2
		
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:nameshort]')
		self.Name = Name
		
		if (unit and unit:find("boss%d")) then
			-- alt power bar
			local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			AltPowerBar:Height(4)
			AltPowerBar:SetStatusBarTexture(C["media"].normTex)
			AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
			AltPowerBar:SetStatusBarColor(1, 0, 0)

			AltPowerBar:SetPoint("LEFT")
			AltPowerBar:SetPoint("RIGHT")
			AltPowerBar:SetPoint("TOP", self.Health, "TOP")
			
			AltPowerBar:SetBackdrop(backdrop)
			AltPowerBar:SetBackdropColor(0, 0, 0)

			self.AltPowerBar = AltPowerBar
			
			-- create buff at left of unit if they are boss units
			local buffs = CreateFrame("Frame", nil, self)
			buffs:SetHeight(26)
			buffs:SetWidth(252)
			buffs:Point("TOPRIGHT", self, "TOPLEFT", -5, 2)
			buffs.size = 26
			buffs.num = 3
			buffs.spacing = 3
			buffs.initialAnchor = 'RIGHT'
			buffs["growth-x"] = "LEFT"
			buffs.PostCreateIcon = D.PostCreateAura
			buffs.PostUpdateIcon = D.PostUpdateAura
			self.Buffs = buffs
			
			-- because it appear that sometime elements are not correct.
			self:HookScript("OnShow", D.updateAllElements)
		end

		-- create debuff for arena units
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(26)
		debuffs:SetWidth(200)
		debuffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', D.Scale(5), 2)
		debuffs.size = 26
		debuffs.num = 4
		debuffs.spacing = 3
		debuffs.initialAnchor = 'LEFT'
		debuffs["growth-x"] = "RIGHT"
		debuffs.PostCreateIcon = D.PostCreateAura
		debuffs.PostUpdateIcon = D.PostUpdateAura
		debuffs.onlyShowPlayer = true
		self.Debuffs = debuffs
				
		-- trinket feature via trinket plugin
		if (C["unitframes"].arena) and (unit and unit:find('arena%d')) then
			local Trinket = CreateFrame("Frame", nil, self)
			Trinket:Size(26)
			Trinket:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 2)
			Trinket:CreateBackdrop("Default")
			Trinket.trinketUseAnnounce = true
			self.Trinket = Trinket
		end
		
		-- boss & arena frames cast bar!
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)		
		castbar:SetHeight(12)
		castbar:SetStatusBarTexture(normTex)
		castbar:SetFrameLevel(10)
		castbar:SetPoint("LEFT", 23, -1)
		castbar:SetPoint("RIGHT", 0, -1)
		castbar:SetPoint("BOTTOM", 0, -21)
		
		castbar:CreateBackdrop()

		castbar.Text = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		castbar.Text:Point("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.84, 0.75, 0.65)
		
		castbar.time = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0.84, 0.75, 0.65)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = D.CustomTimeText
		
		castbar.CustomTimeText = D.CustomCastDelayText
		castbar.PostCastStart = D.castbar
		castbar.PostChannelStart = D.castbar
		
		castbar.button = CreateFrame("Frame", nil, castbar)
		castbar.button:SetTemplate("Default")
		castbar.button:Size(16, 16)
		castbar.button:Point("BOTTOMRIGHT", castbar, "BOTTOMLEFT",-5,-2)

		castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
		castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
		castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
		castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)

		self.Castbar = castbar
		self.Castbar.Icon = castbar.icon
		self.Castbar.Time = castbar.time
	end

	------------------------------------------------------------------------
	--	Main tanks and Main Assists layout (both mirror'd)
	------------------------------------------------------------------------
	
	if(self:GetParent():GetName():match"DuffedUIMainTank" or self:GetParent():GetName():match"DuffedUIMainAssist") then
		-- Right-click focus on maintank or mainassist units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(20)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)
				
		-- Border for HealthBar
		local HealthBorder = CreateFrame("Frame", nil, health)
		HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", D.Scale(-2), D.Scale(2))
		HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", D.Scale(2), D.Scale(-2))
		HealthBorder:SetTemplate("Default")
		HealthBorder:CreateShadow("Default")
		HealthBorder:SetFrameLevel(2)
		self.HealthBorder = HealthBorder
				
		self.Health = health
		self.Health.bg = healthBG
		health.PostUpdate = D.PostUpdatePetColor
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))
			healthBG:SetTexture(.6, .6, .6)
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(.2, .2, .2)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, 1)
		Name:SetJustifyH("CENTER")
		Name:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:nameshort]')
		self.Name = Name
	end
	
	return self
end

------------------------------------------------------------------------
--	Default position of DuffedUI unitframes
------------------------------------------------------------------------

if C["unitframes"].totdebuffs then totdebuffs = 24 end

oUF:RegisterStyle('DuffedUI', Shared)

-- player
local player = oUF:Spawn('player', "DuffedUIPlayer")
player:SetParent(DuffedUIPetBattleHider)
if D.lowversion then
	player:Point("BOTTOMLEFT", DuffedUIBar1, "TOPLEFT", -275, 120)
else
	if C["actionbar"].layout == 1 then
		player:Point("BOTTOMLEFT", DuffedUIBar1, "TOPLEFT", -40, 140)
	else
		player:Point("BOTTOMLEFT", DuffedUIBar1, "TOPLEFT", -210, 80)
	end
end
player:Size(218, 44)

-- target
local target = oUF:Spawn('target', "DuffedUITarget")
target:SetParent(DuffedUIPetBattleHider)
if D.lowversion then
	target:Point("BOTTOMRIGHT", DuffedUIBar1, "TOPRIGHT", 275, 120)
else
	if C["actionbar"].layout == 1 then
		target:Point("BOTTOMRIGHT", DuffedUIBar1, "TOPRIGHT", 40, 140)
	else
		target:Point("BOTTOMRIGHT", DuffedUIBar1, "TOPRIGHT", 210, 80)
	end
end
target:Size(218, 44)

-- tot
local tot = oUF:Spawn('targettarget', "DuffedUITargetTarget")
if D.lowversion then
	tot:SetPoint("TOPRIGHT", DuffedUITarget, "BOTTOMLEFT", 0, -2)
else
	tot:SetPoint("TOPRIGHT", DuffedUITarget, "BOTTOMLEFT", 0, -2)
end
tot:Size(129, 36)

-- pet
local pet = oUF:Spawn('pet', "DuffedUIPet")
pet:SetParent(DuffedUIPetBattleHider)
pet:SetPoint("TOPLEFT", DuffedUIPlayer, "BOTTOMRIGHT", 0, -2)
pet:Size(129, 36)

-- focus
local focus = oUF:Spawn('focus', "DuffedUIFocus")
focus:SetParent(DuffedUIPetBattleHider)
focus:SetPoint("BOTTOMLEFT", InvDuffedUIActionBarBackground, "BOTTOM", 275, 500)
focus:Size(200, 30)

-- focus target
local focustarget = oUF:Spawn("focustarget", "DuffedUIFocusTarget")
focustarget:SetPoint("TOPRIGHT", focus, "BOTTOMLEFT", 0, -2)
focustarget:Size(75, 10)

if C["unitframes"].arena then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "DuffedUIArena"..i)
		arena[i]:SetParent(DuffedUIPetBattleHider)
		if i == 1 then
			arena[i]:SetPoint("RIGHT", UIParent, "RIGHT", -163, -250)
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 35)
		end
		arena[i]:Size(200, 27)
	end
	
	local DuffedUIPrepArena = {}
	for i = 1, 5 do
		DuffedUIPrepArena[i] = CreateFrame("Frame", "DuffedUIPrepArena"..i, UIParent)
		DuffedUIPrepArena[i]:SetAllPoints(arena[i])
		DuffedUIPrepArena[i]:SetBackdrop(backdrop)
		DuffedUIPrepArena[i]:SetBackdropColor(0,0,0)
		DuffedUIPrepArena[i]:CreateShadow()
		DuffedUIPrepArena[i].Health = CreateFrame("StatusBar", nil, DuffedUIPrepArena[i])
		DuffedUIPrepArena[i].Health:SetAllPoints()
		DuffedUIPrepArena[i].Health:SetStatusBarTexture(normTex)
		DuffedUIPrepArena[i].Health:SetStatusBarColor(.3, .3, .3, 1)
		DuffedUIPrepArena[i].SpecClass = DuffedUIPrepArena[i].Health:CreateFontString(nil, "OVERLAY")
		DuffedUIPrepArena[i].SpecClass:SetFont(C["media"].uffont, 12, "OUTLINE")
		DuffedUIPrepArena[i].SpecClass:SetPoint("CENTER")
		DuffedUIPrepArena[i]:Hide()
	end

	local ArenaListener = CreateFrame("Frame", "DuffedUIArenaListener", UIParent)
	ArenaListener:RegisterEvent("PLAYER_ENTERING_WORLD")
	ArenaListener:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	ArenaListener:RegisterEvent("ARENA_OPPONENT_UPDATE")
	ArenaListener:SetScript("OnEvent", function(self, event)
		if event == "ARENA_OPPONENT_UPDATE" then
			for i=1, 5 do
				local f = _G["DuffedUIPrepArena"..i]
				f:Hide()
			end			
		else
			local numOpps = GetNumArenaOpponentSpecs()
			
			if numOpps > 0 then
				for i=1, 5 do
					local f = _G["DuffedUIPrepArena"..i]
					local s = GetArenaOpponentSpec(i)
					local _, spec, class = nil, "UNKNOWN", "UNKNOWN"
					
					if s and s > 0 then 
						_, spec, _, _, _, _, class = GetSpecializationInfoByID(s)
					end
					
					if (i <= numOpps) then
						if class and spec then
							f.SpecClass:SetText(spec.."  -  "..LOCALIZED_CLASS_NAMES_MALE[class])
							if not C["unitframes"].unicolor then
								local color = arena[i].colors.class[class]
								f.Health:SetStatusBarColor(unpack(color))
							end
							f:Show()
						end
					else
						f:Hide()
					end
				end
			else
				for i=1, 5 do
					local f = _G["DuffedUIPrepArena"..i]
					f:Hide()
				end			
			end
		end
	end)
end


if C["unitframes"].showboss then
	for i = 1,MAX_BOSS_FRAMES do
		local t_boss = _G["Boss"..i.."TargetFrame"]
		t_boss:UnregisterAllEvents()
		t_boss.Show = D.dummy
		t_boss:Hide()
		_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn("boss"..i, "DuffedUIBoss"..i)
		boss[i]:SetParent(DuffedUIPetBattleHider)
		if i == 1 then
			boss[i]:SetPoint("RIGHT", UIParent, "RIGHT", -163, -250)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 35)             
		end
		boss[i]:Size(200, 27)
	end
end

local assisttank_width = 90
local assisttank_height  = 20
if C["unitframes"].maintank == true then
	local tank = oUF:SpawnHeader('DuffedUIMainTank', nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINTANK',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_DuffedUIMtt'
	)
	tank:SetParent(DuffedUIPetBattleHider)
	if C["chat"].background then
		tank:SetPoint("TOPLEFT", DuffedUIChatBackgroundRight, "TOPLEFT", 2, 52)
	else
		tank:SetPoint("TOPLEFT", ChatFrame4, "TOPLEFT", 2, 62)
	end
end
 
if C["unitframes"].mainassist == true then
	local assist = oUF:SpawnHeader("DuffedUIMainAssist", nil, 'raid',
		'oUF-initialConfigFunction', ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(assisttank_width, assisttank_height),
		'showRaid', true,
		'groupFilter', 'MAINASSIST',
		'yOffset', 7,
		'point' , 'BOTTOM',
		'template', 'oUF_DuffedUIMtt'
	)
	assist:SetParent(DuffedUIPetBattleHider)
	if C["unitframes"].maintank == true then
		assist:SetPoint("TOPLEFT", DuffedUIMainTank, "BOTTOMLEFT", 2, -50)
	else
		assist:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

-- this is just a fake party to hide Blizzard frame if no DuffedUI raid layout are loaded.
local party = oUF:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)

------------------------------------------------------------------------
-- Right-Click on unit frames menu. 
-- Doing this to remove SET_FOCUS eveywhere.
-- SET_FOCUS work only on default unitframes.
-- Main Tank and Main Assist, use /maintank and /mainassist commands.
------------------------------------------------------------------------
for _, menu in pairs(UnitPopupMenus) do
	for index = #menu, 1, -1 do
		if menu[index] == "SET_FOCUS" or menu[index] == "CLEAR_FOCUS" or menu[index] == "MOVE_PLAYER_FRAME" or menu[index] == "MOVE_TARGET_FRAME" or (D.myclass == "HUNTER" and menu[index] == "PET_DISMISS") then
			table.remove(menu, index)
		end
	end
end