local D, C, L, G = unpack(select(2, ...))
if not C["unitframes"].enable or C["unitframes"].layout ~= 1 then return end

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "DuffedUI was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

------------------------------------------------------------------------
--	local variables
------------------------------------------------------------------------

local font1 = C["media"].uffont
local font2 = C["media"].font
local normTex = C["media"].normTex
local glowTex = C["media"].glowTex
local bubbleTex = C["media"].bubbleTex
local playerwidth = C["unitframes"].framewidth
if D.lowversion and not C["general"].overridelowtohigh then playerwidth = C["unitframes"].framewidth - 25 end 
local nameoffset = 4

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
	RaidIcon:SetHeight(18)
	RaidIcon:SetWidth(18)
	RaidIcon:SetPoint("TOP", 0, 8)
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
		panel:Height(17)
		panel:SetFrameLevel(2)
		panel:SetFrameStrata("MEDIUM")
		self.panel = panel
	
		-- health bar
		local health = CreateFrame("StatusBar", nil, self)
		health:Height(23)
		health:Point("TOPLEFT", 0, -16)
		health:Point("TOPRIGHT", 0, -16)
		health:SetStatusBarTexture(normTex)
		
		-- health border
		health:CreateBackdrop()
		
		-- health bar background
		local healthBG = health:CreateTexture(nil, "BORDER")
		healthBG:SetAllPoints()
		healthBG:SetTexture(0, 0, 0)

		if C["unitframes"].percent then
			local percHP
			percHP = D.SetFontString(health, C["media"].font, 20, "THINOUTLINE")
			percHP:SetTextColor(unpack(C["media"].datatextcolor1))
			if unit == "player" then
                percHP:SetPoint("LEFT", health, "RIGHT", 20, 0)
			elseif unit == "target" then
				percHP:SetPoint("RIGHT", health, "LEFT", -20, 0)
			end
			self:Tag(percHP, "[DuffedUI:perchp]")
			self.percHP = percHP
		end
		
		health.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		if unit == "player" then health.value:Point("RIGHT", health, "RIGHT", -4, 0) elseif unit == "target" then health.value:Point("LEFT", health, "LEFT", 4, 0) end
		health.PostUpdate = D.PostUpdateHealth
		
		self.Health = health
		self.Health.bg = healthBG

		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		-- Raidicon repositioning
		RaidIcon:Point("TOP", health, "TOP", 0, 12)
		
		if C["unitframes"].unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor)) 
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(0, 0, 0)
			end			
		else
			health.colorDisconnected = true
			health.colorTapping = true	
			health.colorClass = true
			health.colorReaction = true
			healthBG:SetTexture(.1, .1, .1)			
		end

		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(2)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
		power:SetStatusBarTexture(normTex)
		
		-- powerbar border
		power:CreateBackdrop()
		
		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = D.SetFontString(panel, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		if unit == "player" then power.value:Point("LEFT", panel, "LEFT", 4, 0) elseif unit == "target" then power.value:Point("RIGHT", panel, "RIGHT", -4, 0) end
		power.PreUpdate = D.PreUpdatePower
		power.PostUpdate = D.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then power.Smooth = true end
		
		if C["unitframes"].powerClasscolored then
			power.colorTapping = true
			power.colorClass = true		
		else
			power.colorPower = true
		end

		-- Panel position
		panel:Point("BOTTOMLEFT", health, "TOPLEFT", -2, 2)
		panel:Point("BOTTOMRIGHT", health, "TOPRIGHT", 2, 2)	
	
		-- portraits
		if C["unitframes"].charportrait == true then
			local graphic = GetCVar("gxapi")
			local isMac = IsMacClient()
			if isMac or graphic == "D3D11" then
				local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
				portrait:SetFrameLevel(8)
				portrait:Size(55)
				portrait:SetAlpha(1)
				if unit == "player" then
					portrait:Point("TOPRIGHT", panel, "TOPLEFT", -5, -4)
					portrait:Point("BOTTOMRIGHT", power, "BOTTOMLEFT", -5, 0)
				elseif unit == "target" then
					portrait:Point("TOPLEFT", panel, "TOPRIGHT", 5, -4)
					portrait:Point("BOTTOMLEFT", power, "BOTTOMRIGHT", 5, 0)
				end
				table.insert(self.__elements, D.HidePortrait)
				portrait.PostUpdate = D.PortraitUpdate --Worgen Fix (Hydra)
				
				-- Portrait Border
				portrait:CreateBackdrop()
				
				self.Portrait = portrait
			else
				local pb = CreateFrame("Frame", self:GetName().."_PortraitBorder", self)
				pb:SetTemplate("Default")
				pb:Size(47)
				if unit == "player" then
					pb:Point("BOTTOMLEFT", power, "BOTTOMLEFT", -51, -2)
				else
					pb:Point("BOTTOMRIGHT", power, "BOTTOMRIGHT", 51, -2)
				end

				local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", pb)
				portrait:Point("TOPLEFT", 2, -2)
				portrait:Point("BOTTOMRIGHT", -2, 2)
				portrait:SetHeight(35)
				portrait:SetWidth(35)

				self.Portrait = portrait
			end
		end
		
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
		
		if unit == "target" then
			-- alt power bar for target
			local AltPowerBar = CreateFrame("StatusBar", "DuffedUIAltPowerBar", self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			AltPowerBar:SetStatusBarTexture(C["media"].normTex)
			AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
			AltPowerBar:SetStatusBarColor(0, .7, 0)
			AltPowerBar:SetHeight(3)
			AltPowerBar:SetPoint("LEFT")
			AltPowerBar:SetPoint("RIGHT")
			AltPowerBar:SetPoint("TOP", self.Health, "TOP")
			
			AltPowerBar:SetBackdrop({bgFile = C["media"].blank})
			AltPowerBar:SetBackdropColor(.1, .1, .1)

			self.AltPowerBar = AltPowerBar
		end
			
		if (unit == "player") then
			-- combat icon
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:Height(19)
			Combat:Width(19)
			Combat:SetPoint("LEFT",0,1)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			-- custom info (low mana warning)
			FlashInfo = CreateFrame("Frame", "DuffedUIFlashInfo", self)
			FlashInfo:SetScript("OnUpdate", D.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetAllPoints(panel)
			FlashInfo.ManaLevel = D.SetFontString(FlashInfo, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			FlashInfo.ManaLevel:Point("RIGHT", panel, "RIGHT", -4, 0)
			self.FlashInfo = FlashInfo
			
			-- pvp status text
			self.PvP = D.SetFontString(panel, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			self.PvP:Point("RIGHT", panel, "RIGHT", -4, 0)
        	self.PvP:SetTextColor(0.69, 0.31, 0.31)
        	self.PvP:Hide()
        	self.PvP.Override = D.dummy
        	self:HookScript("OnUpdate", D.PvPUpdate)
			
			-- leader icon
			local Leader = InvFrame:CreateTexture(nil, "OVERLAY")
			Leader:Height(14)
			Leader:Width(14)
			Leader:Point("TOPLEFT", 2, -6)
			self.Leader = Leader
			
			-- master looter
			local MasterLooter = InvFrame:CreateTexture(nil, "OVERLAY")
			MasterLooter:Height(14)
			MasterLooter:Width(14)
			self.MasterLooter = MasterLooter
			self:RegisterEvent("PARTY_LEADER_CHANGED", D.MLAnchorUpdate)
			self:RegisterEvent("PARTY_MEMBERS_CHANGED", D.MLAnchorUpdate)
			
			-- Vengeance Plugin
			if C["unitframes"].vengeancebar then
				local vge
				if not C["general"].threatbar or C["chat"].rbackground == false or not DuffedUIChatBackgroundRight then
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
				vge.bg:SetTexture(unpack(C.media.backdropcolor))
				
				self.Vengeance = vge
			end
			
			-- experience --
			if C["misc"].exp_rep == false then
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
					Experience.Rested:SetOrientation("VERTICAL")

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
			end
			
			-- show druid mana when shapeshifted in bear, cat or whatever
			if D.myclass == "DRUID" then
				local DruidManaUpdate = CreateFrame("Frame")
				DruidManaUpdate:SetScript("OnUpdate", function() D.UpdateDruidManaText(self) end)
				local DruidManaText = D.SetFontString(health, font1, 12)
				DruidManaText:SetTextColor(1, 0.49, 0.04)
				self.DruidManaText = DruidManaText
			end
			
			if C["unitframes"].classbar then
				if D.myclass == "MAGE" then
					local mb = CreateFrame("Frame", "DuffedUIArcaneBar", self)
					mb:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -6)
					mb:SetWidth(playerwidth)
					mb:SetHeight(5)
					mb:SetBackdrop(backdrop)
					mb:SetBackdropColor(0, 0, 0)
					mb:SetBackdropBorderColor(0, 0, 0)				
					
					for i = 1, 4 do
						mb[i] = CreateFrame("StatusBar", "DuffedUIArcaneBar"..i, mb)
						mb[i]:Height(5)
						mb[i]:SetStatusBarTexture(C["media"].normTex)
						
						if i == 1 then
							mb[i]:Width(playerwidth / 4)
							mb[i]:SetPoint("LEFT", mb, "LEFT", 0, 0)
						else
							mb[i]:Width((playerwidth / 4) - 1)
							mb[i]:SetPoint("LEFT", mb[i-1], "RIGHT", 1, 0)
						end
						
						mb[i].bg = mb[i]:CreateTexture(nil, 'ARTWORK')
					end
					
					mb:CreateBackdrop()

					mb:SetScript("OnShow", D.UpdateMageClassBarVisibility)
					mb:SetScript("OnHide", D.UpdateMageClassBarVisibility)
					
					self.ArcaneChargeBar = mb

					if C["unitframes"].runeofpower then
						local rp = CreateFrame("Frame", "DuffedUIRunePower", self)
						rp:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -6)
						rp:SetWidth(playerwidth)
						rp:SetHeight(5)
						rp:SetBackdrop(backdrop)
						rp:SetBackdropColor(0, 0, 0)
						rp:SetBackdropBorderColor(0, 0, 0)

						for i = 1, 2 do
							rp[i] = CreateFrame("StatusBar", "DuffedUIRunePower"..i, rp)
							rp[i]:Height(5)
							rp[i]:SetStatusBarTexture(C.media.normTex)

							if i == 1 then
								rp[i]:Width(playerwidth / 2 - 1)
								rp[i]:SetPoint("LEFT", rp, "LEFT", 0, 0)
							else
								rp[i]:Width(playerwidth / 2)
								rp[i]:SetPoint("LEFT", rp[i-1], "RIGHT", 1, 0)
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
					-- DRUID MANA BAR
					local DruidManaBackground = CreateFrame("Frame", nil, self)
					DruidManaBackground:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
					DruidManaBackground:Size(playerwidth, 5)
				
					DruidManaBackground:SetFrameLevel(8)
					DruidManaBackground:SetFrameStrata("MEDIUM")
					DruidManaBackground:SetBackdrop(backdrop)
					DruidManaBackground:SetBackdropColor(0, 0, 0)
					DruidManaBackground:SetBackdropBorderColor(0,0,0,0)
					DruidManaBackground.bg = DruidManaBackground:CreateTexture(nil, 'ARTWORK')
					DruidManaBackground.bg:SetAllPoints()
					DruidManaBackground.bg:SetAlpha(.20)
					DruidManaBackground.bg:SetTexture(.30, .52, .90)
					
					local DruidManaBarStatus = CreateFrame("StatusBar", nil, DruidManaBackground)
					DruidManaBarStatus:SetPoint("LEFT", DruidManaBackground, "LEFT", 0, 0)
					DruidManaBarStatus:SetSize(DruidManaBackground:GetWidth(), DruidManaBackground:GetHeight())
					DruidManaBarStatus:SetStatusBarTexture(normTex)
					DruidManaBarStatus:SetStatusBarColor(.30, .52, .90)
					
					DruidManaBarStatus:SetScript("OnShow", function() D.DruidBarDisplay(self, false) end)
					DruidManaBarStatus:SetScript("OnUpdate", function() D.DruidBarDisplay(self, true) end) -- just forcing 1 update on login for buffs/shadow/etc.
					DruidManaBarStatus:SetScript("OnHide", function() D.DruidBarDisplay(self, false) end)
					
					DruidManaBackground:CreateBackdrop()
					
					self.DruidManaBackground = DruidManaBackground
					self.DruidMana = DruidManaBarStatus
				
					local eclipseBar = CreateFrame('Frame', nil, self)
					eclipseBar:Point("LEFT", DruidManaBackground, "LEFT", 0, 0)
					eclipseBar:Size(playerwidth, 5)
					eclipseBar:SetFrameStrata("MEDIUM")
					eclipseBar:SetFrameLevel(8)
					
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

					local eclipseBarText = D.SetFontString(eclipseBar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
					eclipseBarText:Point("RIGHT", panel, "RIGHT", -4, 0)
					eclipseBar.PostUpdatePower = D.EclipseDirection
					
					-- hide "low mana" text on load if eclipseBar is show
					if eclipseBar and eclipseBar:IsShown() then FlashInfo.ManaLevel:SetAlpha(0) end
					
					-- border
					eclipseBar:CreateBackdrop()

					self.EclipseBar = eclipseBar
					self.EclipseBar.Text = eclipseBarText
					
					if C["unitframes"].druidmushroombar then	
						local m = CreateFrame("Frame", "DuffedUIWildMushroomBar", self)
						m:Point("TOPLEFT", self, "BOTTOMLEFT", 0, 1)
						m:SetWidth(playerwidth)
						m:SetHeight(5)
						m:SetBackdrop(backdrop)
						m:SetBackdropColor(0, 0, 0)
						m:SetBackdropBorderColor(0, 0, 0)
						
						for i = 1, 3 do
							m[i] = CreateFrame("StatusBar", "DuffedUIWildMushroomBar"..i, m)
							m[i]:Height(5)
							m[i]:SetStatusBarTexture(C["media"].normTex)
							
							if i == 1 then
								m[i]:Width((playerwidth / 3) - 1)
								m[i]:SetPoint("LEFT", m, "LEFT", 0, 0)
							else
								m[i]:Width((playerwidth / 3) - 1)
								m[i]:SetPoint("LEFT", m[i-1], "RIGHT", 1, 0)
							end
							m[i].bg = m[i]:CreateTexture(nil, 'ARTWORK')
						end
						
						m:SetScript("OnShow", D.UpdateMushroomVisibility)
						m:SetScript("OnHide", D.UpdateMushroomVisibility)

						m:CreateBackdrop()
						
						self.WildMushroom = m
					end
				end
				
				if D.myclass == "WARRIOR" and C["unitframes"].showstatuebar then
					-- statue bar
					local bar = CreateFrame("StatusBar", "DuffedUIStatueBar", self)
					bar:SetWidth(5)
					bar:SetHeight(40)
					bar:Point("BOTTOMLEFT", power, "BOTTOMRIGHT", 7, 0)
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
					wb:Point("TOPLEFT", power, "BOTTOMLEFT", 0, -5)
					wb:SetWidth(playerwidth)
					wb:SetHeight(5)
					wb:SetBackdrop(backdrop)
					wb:SetBackdropColor(0, 0, 0)
					wb:SetBackdropBorderColor(0, 0, 0)	
					
					for i = 1, 4 do
						wb[i] = CreateFrame("StatusBar", "DuffedUIWarlockSpecBars"..i, wb)
						wb[i]:Height(5)
						wb[i]:SetStatusBarTexture(C["media"].normTex)
						
						if i == 1 then
							wb[i]:Width((playerwidth / 4) - 2)
							wb[i]:SetPoint("LEFT", wb, "LEFT", 0, 0)
						else
							wb[i]:Width((playerwidth / 4) - 1)
							wb[i]:SetPoint("LEFT", wb[i-1], "RIGHT", 1, 0)
						end
						
						wb[i].bg = wb[i]:CreateTexture(nil, 'ARTWORK')
					end
					
					wb:CreateBackdrop()
					
					self.WarlockSpecBars = wb				
				end
				
				-- set holy power bar or shard bar
				if D.myclass == "PALADIN" then
					local bars = CreateFrame("Frame", nil, self)
					bars:SetPoint("TOPLEFT", power, "BOTTOMLEFT", 0, -5)
					bars:Width(playerwidth)
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
							bars[i]:Width(38)
							bars[i].bg:SetAllPoints(bars[i])
						else
							bars[i]:Point("LEFT", bars[i-1], "RIGHT", 1, 0)
							bars[i]:Width(playerwidth / 5)
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
					if C["runes"].enable == false then
						local Runes = CreateFrame("Frame", nil, self)
						Runes:Point("TOPLEFT", power, "BOTTOMLEFT", 0, -5)
						Runes:Height(5)
						Runes:SetWidth(playerwidth)
						Runes:SetBackdrop(backdrop)
						Runes:SetBackdropColor(0, 0, 0)

						for i = 1, 6 do
							Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, Runes)
							Runes[i]:SetHeight(5)
							if i == 1 then Runes[i]:SetWidth(playerwidth / 6) else Runes[i]:SetWidth((playerwidth / 6) - 1) end
							if i == 1 then Runes[i]:Point("TOPLEFT", power, "BOTTOMLEFT", 0, -5) else Runes[i]:Point("TOPLEFT", Runes[i-1], "TOPRIGHT", 1, 0) end
							Runes[i]:SetStatusBarTexture(normTex)
							Runes[i]:GetStatusBarTexture():SetHorizTile(false)
						end
						
						Runes:CreateBackdrop()

						self.Runes = Runes
					end
					
					if C["unitframes"].showstatuebar then
						-- statue bar
						local bar = CreateFrame("StatusBar", "DuffedUIStatueBar", self)
						bar:SetWidth(5)
						bar:SetHeight(40)
						bar:Point("BOTTOMLEFT", power, "BOTTOMRIGHT", 7, 0)
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
					hb:Point("TOPLEFT", power, "BOTTOMLEFT", 0, -5)
					hb:SetWidth(playerwidth)
					hb:SetHeight(5)
					hb:SetBackdrop(backdrop)
					hb:SetBackdropColor(0, 0, 0)
					hb:SetBackdropBorderColor(0, 0, 0)	
					
					for i = 1, 5 do
						hb[i] = CreateFrame("StatusBar", "DuffedUIHarmonyBar"..i, hb)
						hb[i]:Height(5)
						hb[i]:SetStatusBarTexture(C["media"].normTex)
						
						if i == 1 then
							hb[i]:Width(playerwidth / 5)
							hb[i]:SetPoint("LEFT", hb, "LEFT", 0, 0)
						else
							hb[i]:Width((playerwidth / 5) - 1)
							hb[i]:SetPoint("LEFT", hb[i-1], "RIGHT", 1, 0)
						end
					end
					
					-- harmonybar border
					hb:CreateBackdrop()
					
					self.HarmonyBar = hb
					
					if C["unitframes"].showstatuebar then
						-- statue bar
						local bar = CreateFrame("StatusBar", "DuffedUIStatueBar", self)
						bar:SetWidth(5)
						bar:SetHeight(40)
						bar:Point("BOTTOMLEFT", power, "BOTTOMRIGHT", 7, 0)
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
					pb:Point("TOPLEFT", power, "BOTTOMLEFT", 0, -5)
					pb:SetWidth(playerwidth)
					pb:SetHeight(5)
					pb:SetBackdrop(backdrop)
					pb:SetBackdropColor(0, 0, 0)
					pb:SetBackdropBorderColor(0, 0, 0)	
					
					for i = 1, 3 do
						pb[i] = CreateFrame("StatusBar", "DuffedUIShadowOrbsBar"..i, pb)
						pb[i]:Height(5)
						pb[i]:SetStatusBarTexture(C["media"].normTex)
						
						if i == 1 then
							pb[i]:Width((playerwidth / 3) - 1)
							pb[i]:SetPoint("LEFT", pb, "LEFT", 0, 0)
						else
							pb[i]:Width((playerwidth / 3) - 1)
							pb[i]:SetPoint("LEFT", pb[i-1], "RIGHT", 1, 0)
						end
					end
					
					pb:CreateBackdrop()
					
					self.ShadowOrbsBar = pb
					
					-- statue bar
					if C["unitframes"].showstatuebar then
						local bar = CreateFrame("StatusBar", "DuffedUIStatueBar", self)
						bar:SetWidth(5)
						bar:SetHeight(40)
						bar:Point("BOTTOMLEFT", power, "BOTTOMRIGHT", 7, 0)
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
						if i == 1 then TotemBar[i]:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -7) else TotemBar[i]:Point("TOPLEFT", TotemBar[i-1], "TOPRIGHT", 3, 0) end
						TotemBar[i]:SetStatusBarTexture(normTex)
						TotemBar[i]:Height(5)
						TotemBar[i]:Width(((playerwidth) / 4)-3)
						if i == 4 then TotemBar[i]:Width(TotemBar[1]:GetWidth()+1) end
						TotemBar[i]:SetMinMaxValues(0, 1)

						TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
						TotemBar[i].bg:SetAllPoints(TotemBar[i])
						TotemBar[i].bg:SetTexture(normTex)
						TotemBar[i].bg.multiplier = 0.2
						
						-- border
						TotemBar[i].border = CreateFrame("Frame", nil, TotemBar[i])
						TotemBar[i].border:SetTemplate("Default")
						TotemBar[i].border:Size(1, 1)
						TotemBar[i].border:SetFrameLevel(TotemBar[i]:GetFrameLevel() - 1)
						TotemBar[i].border:Point("TOPLEFT", TotemBar[i], "TOPLEFT", -2, 2)
						TotemBar[i].border:Point("BOTTOMRIGHT", 2, -2)
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
				self.PvP:Show()
				UnitFrame_OnEnter(self) 
			end)
			self:SetScript("OnLeave", function(self) 
				if self.EclipseBar and self.EclipseBar:IsShown() then 
					self.EclipseBar.Text:Show()
				end
				FlashInfo.ManaLevel:Show()
				self.PvP:Hide()
				UnitFrame_OnLeave(self) 
			end)
		end
		
		if (unit == "target") then			
			-- Unit name on target
			local Name = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			Name:Point("LEFT", panel, "LEFT", 4, 0)
			Name:SetJustifyH("LEFT")

			self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namelong] [DuffedUI:diffcolor][level] [shortclassification]')
			self.Name = Name
		end

		if (unit == "target" and C["unitframes"].targetauras) or (unit == "player" and C["unitframes"].playerauras) then
			local buffs = CreateFrame("Frame", nil, self)
			local debuffs = CreateFrame("Frame", nil, self)
			
			buffs:Point("BOTTOMLEFT", self, "TOPLEFT", -2, 4)
			buffs.size = 22
			buffs.spacing = 3
			buffs:Height((buffs.size + buffs.spacing) * C["unitframes"].buffrows)
			buffs:Width(playerwidth + 3)
			buffs.num = (playerwidth / (buffs.size + buffs.spacing)) * C["unitframes"].buffrows
			
			debuffs.size = 22
			debuffs.spacing = 3
			debuffs:Height((debuffs.size + debuffs.spacing) * C["unitframes"].debuffrows)
			debuffs:Width(playerwidth + 3)
			debuffs:Point("BOTTOMLEFT", buffs, "TOPLEFT", 1, 0)
			if C["classtimer"].targetdebuffs then
				debuffs.num = (playerwidth / (buffs.size + buffs.spacing))
			else
				debuffs.num = (playerwidth / (buffs.size + buffs.spacing)) * C["unitframes"].debuffrows
			end
			
			buffs.initialAnchor = 'BOTTOMLEFT'
			buffs.PostCreateIcon = D.PostCreateAura
			buffs.PostUpdateIcon = D.PostUpdateAura
			self.Buffs = buffs
						
			debuffs.initialAnchor = 'BOTTOMRIGHT'
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			debuffs.PostCreateIcon = D.PostCreateAura
			debuffs.PostUpdateIcon = D.PostUpdateAura
			
			-- an option to show only our debuffs on target
			if unit == "target" then debuffs.onlyShowPlayer = C["unitframes"].onlyselfdebuffs end
			
			self.Debuffs = debuffs
		end
		
		-- cast bar for player and target
		if C["castbar"].enable == true then
			-- Anchor for targetcastbar
			local tcb = CreateFrame("Frame", "TCBanchor", UIParent)
			tcb:SetTemplate("Default")
			tcb:Size(225, 18)
			tcb:Point("BOTTOM", UIParent, "BOTTOM", 0, 395)
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
			
			castbar.CustomTimeText = D.CustomCastTime
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
			CombatFeedbackText:SetPoint("CENTER", 0, 0)
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
			mhpb:SetWidth(playerwidth)
			mhpb:SetStatusBarTexture(normTex)
			mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
			mhpb:SetMinMaxValues(0,1)

			local ohpb = CreateFrame('StatusBar', nil, self.Health)
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:SetWidth(playerwidth)
			ohpb:SetStatusBarTexture(normTex)
			ohpb:SetStatusBarColor(0, 1, 0, 0.25)

			local absb = CreateFrame("StatusBar", nil, self.Health)
			absb:SetPoint("TOPLEFT", ohpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			absb:SetPoint("BOTTOMLEFT", ohpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			absb:SetWidth(playerwidth)
			absb:SetStatusBarTexture(normTex)
			absb:SetStatusBarColor(1, 1, 0, 0.25)

			self.HealPrediction = {
				myBar = mhpb,
				otherBar = ohpb,
				absBar = absb,
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
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(16)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- health border
		health:CreateBackdrop()
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		self.Health = health
		self.Health.bg = healthBG
		health.PostUpdate = D.PostUpdatePetColor
		
		health.frequentUpdates = true if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		if C["unitframes"].unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(0, 0, 0)
			end			
		else
			health.colorDisconnected = true
			health.colorTapping = true	
			health.colorClass = true
			health.colorReaction = true
		end
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(1)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, 1)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, 1)
		power:SetFrameLevel(health:GetFrameLevel() + 1)
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true if C["unitframes"].showsmooth == true then power.Smooth = true end
		
		if C["unitframes"].powerClasscolored then
			power.colorTapping = true
			power.colorClass = true		
		else
			power.colorPower = true
		end
		self.Power = power
		
		-- Unit name
		local Name = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetPoint("CENTER", health, "CENTER", 0, -1)
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namemedium]')
		self.Name = Name
		
		if C["unitframes"].totdebuffs == true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = C["unitframes"].totdbsize
			debuffs.spacing = 4
			debuffs.num = 6

			debuffs:Point("TOPLEFT", power, "BOTTOMLEFT", -2, -5)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = D.PostCreateAura
			debuffs.PostUpdateIcon = D.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- Lines
		if C["unitframes"].totandpetlines == true and playerwidth > 155 then
			line1 = CreateFrame("Frame", nil, health)
			line1:SetTemplate("Default")
			line1:Size(13, 2)
			line1:Point("RIGHT", health, "LEFT", -3, 0)
			
			line2 = CreateFrame("Frame", nil, health)
			line2:SetTemplate("Default")
			line2:Size(2, 14)
			line2:Point("BOTTOM", line1, "LEFT", 0, -1)
		end
		
		-- portrait
		if C["unitframes"].charportrait == true then
			local graphic = GetCVar("gxapi")
			local isMac = IsMacClient()
			if isMac or graphic == "D3D11" then
				local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
				portrait:SetFrameLevel(8)
				portrait:Size(21)
				portrait:SetAlpha(1)
				portrait:Point("TOPLEFT", health, "TOPRIGHT", 7, 0)
				portrait:Point("BOTTOMLEFT", power, "BOTTOMRIGHT", 7, 0)
				table.insert(self.__elements, D.HidePortrait)
				portrait.PostUpdate = D.PortraitUpdate --Worgen Fix (Hydra)
				
				-- portrait border
				portrait:CreateBackdrop()
				
				self.Portrait = portrait
			else
				local pb = CreateFrame("Frame", self:GetName().."_PortraitBorder", self)
				pb:SetTemplate("Default")
				pb:Size(20)
				pb:Point("BOTTOMRIGHT", power, "BOTTOMRIGHT", 24, -2)

				local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", pb)
				portrait:Point("TOPLEFT", 2, -2)
				portrait:Point("BOTTOMRIGHT", -2, 2)
				portrait:SetHeight(35)
				portrait:SetWidth(35)

				self.Portrait = portrait
			end
		end
	end
	
	------------------------------------------------------------------------
	--	Pet unit layout
	------------------------------------------------------------------------
	
	if (unit == "pet") then
		-- health bar panel
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(16)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		-- health border
		health:CreateBackdrop()
		
		health.PostUpdate = D.PostUpdatePetColor
				
		self.Health = health
		self.Health.bg = healthBG
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		health.frequentUpdates = true if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(0, 0, 0)
			end			
		else
			health.colorDisconnected = true	
			health.colorClass = true
			health.colorReaction = true	
		end
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(1)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, 1)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, 1)
		power:SetFrameLevel(health:GetFrameLevel() + 1)
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true
		power.colorPower = true
		if C["unitframes"].showsmooth == true then power.Smooth = true end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
				
		self.Power = power
		self.Power.bg = powerBG
				
		-- Unit name
		local Name = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetPoint("CENTER", health, "CENTER", 0, -1)
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namemedium] [DuffedUI:diffcolor][level]')
		self.Name = Name
		
		if C["unitframes"].unicolor then
			self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namemedium]  [DuffedUI:diffcolor][level]')
			self.Name = Name
		else
			self:Tag(Name, '[DuffedUI:namemedium]  [DuffedUI:diffcolor][level]')
			self.Name = Name
		end
		
		-- Lines
		if (C["unitframes"].totandpetlines == true and playerwidth > 155) then
			line1 = CreateFrame("Frame", nil, health)
			line1:SetTemplate("Default")
			line1:Size(15, 2)
			line1:Point("LEFT", health, "RIGHT", 3, 0)
			
			line2 = CreateFrame("Frame", nil, health)
			line2:SetTemplate("Default")
			line2:Size(2, 14)
			line2:Point("BOTTOM", line1, "RIGHT", 0, -1)
		end
		
		if C["castbar"].petenable == true then
			local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
			castbar:SetStatusBarTexture(normTex)
			self.Castbar = castbar
			castbar:Height(16)
			castbar:SetFrameLevel(health:GetFrameLevel() + 4)
			castbar:CreateBackdrop()
			
			castbar:Point("TOPLEFT", health, "BOTTOMLEFT", 0, 16)
			castbar:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, 16)

			castbar.time = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			castbar.time:Point("RIGHT", castbar, "RIGHT", -5, 0)
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			castbar.Text:Point("LEFT", castbar, "LEFT", 6, 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			castbar.CustomTimeText = D.CustomCastTime
			castbar.CustomDelayText = D.CustomCastDelayText
			castbar.PostCastStart = D.castbar
			castbar.PostChannelStart = D.castbar

			self.Castbar.Time = castbar.time			
		end
		
		if C["unitframes"].charportrait == true then
			local graphic = GetCVar("gxapi")
			local isMac = IsMacClient()
			if isMac or graphic == "D3D11" then
				local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
				portrait:SetFrameLevel(8)
				portrait:Size(21)
				portrait:SetAlpha(1)
				portrait:Point("TOPRIGHT", health,"TOPLEFT",-7,0)
				portrait:Point("BOTTOMRIGHT", power,"BOTTOMLEFT",-7,0)
				table.insert(self.__elements, D.HidePortrait)
				portrait.PostUpdate = D.PortraitUpdate --Worgen Fix (Hydra)
				
				-- Portrait Border
				portrait:CreateBackdrop()
				
				self.Portrait = portrait
			else
				local pb = CreateFrame("Frame", self:GetName().."_PortraitBorder", self)
				pb:SetTemplate("Default")
				pb:Size(20)
				pb:Point("BOTTOMLEFT", power, "BOTTOMLEFT", -24, -2)

				local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", pb)
				portrait:Point("TOPLEFT", 2, -2)
				portrait:Point("BOTTOMRIGHT", -2, 2)
				portrait:SetHeight(35)
				portrait:SetWidth(35)

				self.Portrait = portrait
			end
		end
		
		if C["unitframes"].totdebuffs == true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = 19.5
			debuffs.spacing = 4
			debuffs.num = 6

			debuffs:Point("TOPLEFT", power, "BOTTOMLEFT", -2, -5)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = D.PostCreateAura
			debuffs.PostUpdateIcon = D.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit, health and bar color sometime being "grayish".
		self:RegisterEvent("UNIT_PET", D.updateAllElements)
	end


	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		local lafo = C["unitframes"].largefocus
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		if lafo then
			health:Height(19)
			health:SetPoint("TOPLEFT",0 , -15)
			health:SetPoint("TOPRIGHT",0 , -15)
		else
			health:Height(16)
			health:SetPoint("TOPLEFT")
			health:SetPoint("TOPRIGHT")
		end
		health:SetStatusBarTexture(normTex)
		
		-- health border
		health:CreateBackdrop()

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)

		health.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		if lafo then health.value:Point("LEFT", health, "LEFT", 2, 0) else health.value:Point("RIGHT", -2, 0) end
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
				healthBG:SetTexture(0, 0, 0)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
		
		-- names
		local Name = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		if lafo then Name:Point("BOTTOMLEFT", health, "TOPLEFT", 2, nameoffset) else Name:Point("LEFT", health, "LEFT", 4, 0) end
		Name:SetJustifyH("LEFT")
		
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namelong] [DuffedUI:diffcolor][level] [shortclassification]')
		self.Name = Name
	
		-- create castbar
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)
		
		-- power
		if lafo then
			local power = CreateFrame('StatusBar', nil, self)
			power:Height(2)
			power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
			power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
			power:SetStatusBarTexture(normTex)
			
			power.frequentUpdates = true
			if C["unitframes"].showsmooth == true then power.Smooth = true end
			
			if C["unitframes"].powerClasscolored then
				power.colorTapping = true
				power.colorClass = true		
			else
				power.colorPower = true
			end

			local powerBG = power:CreateTexture(nil, 'BORDER')
			powerBG:SetAllPoints(power)
			powerBG:SetTexture(normTex)
			powerBG.multiplier = 0.3
			
			power.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			power.value:Point("BOTTOMRIGHT", health, "TOPRIGHT", -2, nameoffset)
			power.PreUpdate = D.PreUpdatePower
			power.PostUpdate = D.PostUpdatePower
					
			self.Power = power
			self.Power.bg = powerBG
			
			-- power border
			power:CreateBackdrop()
			
			-- portrait
		if lafo then
			local graphic = GetCVar("gxapi")
			local isMac = IsMacClient()
			local pf = CreateFrame("Frame", self:GetName() .. "_PortraitFrame", self)
			if isMac or graphic == "D3D11" then
				pf:Size(38)
				pf:Point("BOTTOMRIGHT", health, "BOTTOMLEFT", -7, -5)
				
				if C["unitframes"].portraitstyle == "MODEL" then	
					local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", pf)
					portrait:SetFrameLevel(8)
					portrait:Size(37)
					portrait:Point("TOPLEFT", 0, 0)
					portrait:Point("BOTTOMRIGHT", 0, 0)
					portrait:SetAlpha(1)
					table.insert(self.__elements, D.HidePortrait)
					portrait.PostUpdate = D.PortraitUpdate --Worgen Fix (Hydra)
					
					self.Portrait = portrait
				else
					local class = pf:CreateTexture(self:GetName().."_ClassIcon", "ARTWORK")
					class:Point("TOPLEFT", 0, 0)
					class:Point("BOTTOMRIGHT", 0, 0)
					
					self.ClassIcon = class
				end
				
				-- Portrait Border
				pf:CreateBackdrop()

				local AuraTracker = CreateFrame("Frame", nil, self)
				AuraTracker:Size(45)
				AuraTracker:Point("BOTTOMRIGHT", pf, "BOTTOMLEFT", -2, -3)
				
				AuraTracker.icon = AuraTracker:CreateTexture(nil, "OVERLAY")
				AuraTracker.icon:Point("TOPLEFT", 2, -2)
				AuraTracker.icon:Point("BOTTOMRIGHT", -2, 2)
				AuraTracker.icon:SetTexCoord(0.07,0.93,0.07,0.93)
				
				AuraTracker.text = D.SetFontString(AuraTracker, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
				AuraTracker.text:SetPoint("CENTER", AuraTracker, 0, 0)
				AuraTracker:SetScript("OnUpdate", updateAuraTrackerTime)
			else
				local pb = CreateFrame("Frame", self:GetName().."_PortraitBorder", self)
				pb:SetTemplate("Default")
				pb:Size(40)
				pb:Point("BOTTOMLEFT", health, "BOTTOMLEFT", -43, 0)

				local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", pb)
				portrait:Point("TOPLEFT", 2, -2)
				portrait:Point("BOTTOMRIGHT", -2, 2)
				portrait:SetHeight(35)
				portrait:SetWidth(35)

				self.Portrait = portrait
			end
		end
		end
		
		-- Border
		if not lafo then health:CreateBackdrop() end

		-- create debuffs
		if C["unitframes"].focusdebuffs then
			local debuffs = CreateFrame("Frame", nil, self)
			debuffs.spacing = 3
			if lafo then
				debuffs.size = 26
				debuffs:SetHeight(22)
				debuffs:Point('LEFT', health, 'RIGHT', 5, -3)
				debuffs.initialAnchor = 'LEFT'
				debuffs["growth-x"] = "RIGHT"
				debuffs.num = 4
			else
				debuffs:Point("RIGHT", self, "LEFT", -5, 0)
				debuffs.initialAnchor = 'RIGHT'
				debuffs["growth-x"] = "LEFT"
				debuffs.num = 4
				debuffs.size = 20
				debuffs:SetHeight(20)
			end
			debuffs:SetWidth((debuffs.size + debuffs.spacing) * debuffs.num)
			debuffs.PostCreateIcon = D.PostCreateAura
			debuffs.PostUpdateIcon = D.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- castbar
		if C["castbar"].enable == true then
			-- Anchor for focuscastbar
			local fcb = CreateFrame("Frame", "FCBanchor", UIParent)
			fcb:SetTemplate("Default")
			fcb:Size(225, 18)
			fcb:Point("TOP", UIParent, "TOP", 0, -320)
			fcb:SetClampedToScreen(true)
			fcb:SetMovable(true)
			fcb:SetBackdropColor(0, 0, 0)
			fcb:SetBackdropBorderColor(1, 0, 0)
			fcb.text = D.SetFontString(fcb, C["media"].font, 12)
			fcb.text:SetPoint("CENTER")
			fcb.text:SetText("Move Focuscastbar")
			fcb:Hide()
			tinsert(D.AllowFrameMoving, FCBanchor)
			
			castbar:SetStatusBarTexture(normTex)
			castbar:SetFrameLevel(10)
			castbar:Height(18)
			castbar:Width(225)
			castbar:Point("LEFT", FCBanchor, "LEFT", 0, 0)
			
			castbar:CreateBackdrop()
			
			castbar.time = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")
			castbar.CustomTimeText = D.CustomCastTime

			castbar.Text = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			castbar.CustomDelayText = D.CustomCastDelayText
			castbar.PostCastStart = D.castbar
			castbar.PostChannelStart = D.castbar
	
			if C["castbar"].cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:Size(31)
				castbar.button:Point("BOTTOM", castbar, "TOP",0,5)
				castbar.button:SetTemplate("Default")
				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
				castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			end

			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
	end
	
	------------------------------------------------------------------------
	--	Focus target unit layout
	------------------------------------------------------------------------

	if (unit == "focustarget") then
		local lafo = C["unitframes"].largefocus
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:SetPoint("TOPLEFT")
		health:SetPoint("BOTTOMRIGHT")
		health:SetStatusBarTexture(normTex)

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)

		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		health.PostUpdate = D.PostUpdatePetColor
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(0, 0, 0)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true
		end
			
		-- names
		local Name = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0)
		Name:SetJustifyH("CENTER")
		
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:nameshort]')
		self.Name = Name
		
		-- Border
		health:CreateBackdrop(self)
	end

	------------------------------------------------------------------------
	--	Arena or boss units layout (both mirror'd)
	------------------------------------------------------------------------
	
	if (unit and unit:find("arena%d") and C["raid"].arena == true) or (unit and unit:find("boss%d") and C["raid"].showboss == true) then
		-- Right-click focus on arena or boss units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:Height(19)
		health:Point("TOPLEFT",0 ,-15)
		health:Point("TOPRIGHT",0 ,-15)
		health:SetStatusBarTexture(normTex)
		
		-- health border
		health:CreateBackdrop()

		health.frequentUpdates = true
		health.colorDisconnected = true
		if C["unitframes"].showsmooth == true then health.Smooth = true end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)

		health.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		health.value:Point("LEFT", health, "LEFT", 2, 0)
		health.PostUpdate = D.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true if C["unitframes"].showsmooth == true then health.Smooth = true end
		
		-- Raidicon repositioning
		RaidIcon:Point("TOP", health, "TOP", 0, 9)
		
		if C["unitframes"].unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthbarcolor))
			healthBG:SetVertexColor(unpack(C["unitframes"].deficitcolor))	
			healthBG:SetTexture(.6, .6, .6)	
			if C["unitframes"].ColorGradient then
				health.colorSmooth = true
				healthBG:SetTexture(0, 0, 0)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:Height(2)
		power:Point("TOPLEFT", health, "BOTTOMLEFT", 0, -3)
		power:Point("TOPRIGHT", health, "BOTTOMRIGHT", 0, -3)
		power:SetStatusBarTexture(normTex)
		
		-- power border
		power:CreateBackdrop()
		
		power.frequentUpdates = true if C["unitframes"].showsmooth == true then power.Smooth = true end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		power.value:Point("BOTTOMRIGHT", health, "TOPRIGHT", -2, nameoffset)
		power.PreUpdate = D.PreUpdatePower
		power.PostUpdate = D.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:Point("BOTTOMLEFT", health, "TOPLEFT", 2, nameoffset)
		Name:SetJustifyH("LEFT")
		Name.frequentUpdates = 0.2
		
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:namelong]')
		self.Name = Name
		
		if (unit and unit:find("boss%d")) then
			power.colorPower = true
		
			-- alt power bar
			local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
			AltPowerBar:SetFrameLevel(self.Health:GetFrameLevel() + 1)
			AltPowerBar:Height(3)
			AltPowerBar:SetStatusBarTexture(C.media.normTex)
			AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
			AltPowerBar:SetStatusBarColor(1, 0, 0)

			AltPowerBar:SetPoint("LEFT")
			AltPowerBar:SetPoint("RIGHT")
			AltPowerBar:SetPoint("TOP", self.Health, "TOP")
			self.AltPowerBar = AltPowerBar
			
			if C["unitframes"].charportrait == true then
				local graphic = GetCVar("gxapi")
				local isMac = IsMacClient()
				if isMac or graphic == "D3D11" then
					local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
					portrait:SetFrameLevel(8)
					portrait:Size(40)
					portrait:SetAlpha(1)
					portrait:Point("BOTTOMRIGHT", health, "BOTTOMLEFT", -5, -5)
					table.insert(self.__elements, D.HidePortrait)
					portrait.PostUpdate = D.PortraitUpdate --Worgen Fix (Hydra)
					
					-- Portrait Border
					portrait:CreateBackdrop()
					
					self.Portrait = portrait
				else
					local pb = CreateFrame("Frame", self:GetName().."_PortraitBorder", self)
				pb:SetTemplate("Default")
				pb:Size(42)
				pb:Point("BOTTOMLEFT", power, "BOTTOMLEFT", -46, -2)

				local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", pb)
				portrait:Point("TOPLEFT", 2, -2)
				portrait:Point("BOTTOMRIGHT", -2, 2)
				portrait:SetHeight(35)
				portrait:SetWidth(35)

				self.Portrait = portrait
				end
			end
			
			-- create buff at left of unit if they are boss units
			local buffs = CreateFrame("Frame", nil, self)
			buffs:SetHeight(40)
			buffs:SetWidth(252)
			buffs:Point("BOTTOMRIGHT", health.border, "BOTTOMLEFT", -3, 0)
			buffs.size = 40
			buffs.num = 3
			buffs.spacing = 2
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
		debuffs:SetHeight(22)
		debuffs:SetWidth(200)
		debuffs:Point('LEFT', health, 'RIGHT', 4, -3)
		debuffs.size = 25
		debuffs.num = 5
		debuffs.spacing = 2
		debuffs.initialAnchor = 'LEFT'
		debuffs["growth-x"] = "RIGHT"
		debuffs.PostCreateIcon = D.PostCreateAura
		debuffs.PostUpdateIcon = D.PostUpdateAura
		debuffs.onlyShowPlayer = true
		self.Debuffs = debuffs
				
		-- trinket feature via trinket plugin
		if (C["raid"].arena) and (unit and unit:find('arena%d')) then
			if C["unitframes"].powerClasscolored then
				power.colorTapping = true
				power.colorClass = true		
			else
				power.colorPower = true
			end
		
			RaidIcon:Hide()
			
			-- Auratracker Frame
			local AuraTracker = CreateFrame("Frame", nil, self)
			AuraTracker:Size(40)
			AuraTracker:Point("BOTTOMRIGHT", health.border, "BOTTOMLEFT", -3, 0)
			AuraTracker:SetTemplate("Default")
			AuraTracker:CreateShadow("Default")
			self.AuraTracker = AuraTracker
			
			AuraTracker.icon = AuraTracker:CreateTexture(nil, "OVERLAY")
			AuraTracker.icon:SetAllPoints(AuraTracker)
			AuraTracker.icon:Point("TOPLEFT", AuraTracker, 2, -2)
			AuraTracker.icon:Point("BOTTOMRIGHT", AuraTracker, -2, 2)
			AuraTracker.icon:SetTexCoord(0.07,0.93,0.07,0.93)
			
			AuraTracker.text = D.SetFontString(AuraTracker, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			AuraTracker.text:SetPoint("CENTER", AuraTracker, 0, 0)
			AuraTracker:SetScript("OnUpdate", updateAuraTrackerTime)
			
			-- ClassIcon			
			local class = AuraTracker:CreateTexture(nil, "ARTWORK")
			class:SetAllPoints(AuraTracker.icon)
			self.ClassIcon = class
		
			-- Trinket Frame
			local Trinketbg = CreateFrame("Frame", nil, self)
			Trinketbg:Size(40)
			Trinketbg:Point("BOTTOMRIGHT", health.border, "BOTTOMLEFT", -3, 0)
			Trinketbg:SetTemplate("Default")
			Trinketbg:SetFrameLevel(health:GetFrameLevel()+1)
			self.Trinketbg = Trinketbg
			
			local Trinket = CreateFrame("Frame", nil, self)
			Trinket:Point("TOPLEFT", Trinketbg, 1, -1)
			Trinket:Point("BOTTOMRIGHT", Trinketbg, -1, 1)
			Trinket:SetFrameLevel(Trinketbg:GetFrameLevel()+1)
			Trinket.trinketUseAnnounce = true
			self.Trinket = Trinket
			
			-- Spec info
			Talents = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
			Talents:Point("TOPRIGHT", health, "BOTTOMRIGHT", -2, -3)
			Talents:SetTextColor(1,1,1,.6)
			self.Talents = Talents
		end
		
		-- boss & arena frames cast bar!
		local castbar = CreateFrame("StatusBar", self:GetName().."CastBar", self)		
		castbar:SetHeight(12)
		castbar:SetStatusBarTexture(normTex)
		castbar:SetFrameLevel(10)
		
		castbar:CreateBackdrop()

		castbar.Text = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		castbar.Text:Point("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(0.84, 0.75, 0.65)
		
		castbar.time = D.SetFontString(castbar, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		castbar.time:Point("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.time:SetTextColor(0.84, 0.75, 0.65)
		castbar.time:SetJustifyH("RIGHT")
		castbar.CustomTimeText = D.CustomCastTime
		
		castbar.CustomDelayText = D.CustomCastDelayText
		castbar.PostCastStart = D.castbar
		castbar.PostChannelStart = D.castbar
		
		local Ax = 0
		if C["castbar"].cbicons == true then
			Ax = 19
			castbar.button = CreateFrame("Frame", nil, castbar)
			castbar.button:SetTemplate("Default")
			castbar.button:Size(16, 16)
			castbar.button:Point("BOTTOMRIGHT", castbar, "BOTTOMLEFT", -5, -2)

			castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
			castbar.icon:Point("TOPLEFT", castbar.button, 2, -2)
			castbar.icon:Point("BOTTOMRIGHT", castbar.button, -2, 2)
			castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
		end
		castbar:Point("TOPLEFT", power, "TOPLEFT", Ax, -9)
		castbar:Point("TOPRIGHT", power, "TOPRIGHT", 0, -9)

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
		
		-- health border
		health:CreateBackdrop()
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
				
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
				healthBG:SetTexture(0, 0, 0)
			end
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true
		end
		
		-- names
		local Name = D.SetFontString(health, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		Name:SetPoint("CENTER", health, "CENTER", 0, 0)
		Name:SetJustifyH("CENTER")
		
		self:Tag(Name, '[DuffedUI:getnamecolor][DuffedUI:nameshort]')
		self.Name = Name
	end
	
	return self
end

------------------------------------------------------------------------
--	Default position of DuffedUI unitframes
------------------------------------------------------------------------
oUF:RegisterStyle("DuffedUI", Shared)

-- player
local player = oUF:Spawn("player", "DuffedUIPlayer")
player:SetParent(DuffedUIPetBattleHider)
if D.lowversion then
	player:Point("BOTTOMLEFT", DuffedUIBar1, "TOPLEFT", -130, 135)
else
	if C["actionbar"].layout == 1 then
		player:Point("BOTTOMLEFT", DuffedUIBar1, "TOPLEFT", 2, 140)
	else
		player:Point("BOTTOMLEFT", DuffedUIBar1, "TOPLEFT", -210, 80)
	end
end
player:Size(playerwidth, 43)


-- target
local target = oUF:Spawn("target", "DuffedUITarget")
target:SetParent(DuffedUIPetBattleHider)
if D.lowversion then
	target:Point("BOTTOMRIGHT", DuffedUIBar1, "TOPRIGHT", 130,135)
else
	if C["actionbar"].layout == 1 then
		target:Point("BOTTOMRIGHT", DuffedUIBar1, "TOPRIGHT", -2, 140)
	else
		target:Point("BOTTOMRIGHT", DuffedUIBar1, "TOPRIGHT", 210, 80)
	end
end
target:Size(playerwidth, 43)

-- tot
local tot = oUF:Spawn("targettarget", "DuffedUITargetTarget")
tot:Point("TOPRIGHT", DuffedUITarget, "BOTTOMRIGHT", 0,-8)
tot:Size(125, 18)

-- pet
local pet = oUF:Spawn("pet", "DuffedUIPet")
pet:SetParent(DuffedUIPetBattleHider)
if D.myclass == "WARLOCK" or D.myclass == "DEATHKNIGHT" or D.myclass == "SHAMAN" or D.myclass == "DRUID" then
	pet:Point("TOPLEFT", DuffedUIPlayer, "BOTTOMLEFT", 0, -19)
else
	pet:Point("TOPLEFT", DuffedUIPlayer, "BOTTOMLEFT", 0,-7)
end
pet:Size(125, 18)

-- focus & focustarget
local focus = oUF:Spawn("focus", "DuffedUIFocus")
local focustarget = oUF:Spawn("focustarget", "DuffedUIFocusTarget")	
focus:SetParent(DuffedUIPetBattleHider)
if C["unitframes"].largefocus then
	focus:Size(playerwidth-20, 39)
	focus:Point("TOPLEFT", UIParent, "TOPLEFT", 560, -370)
	focustarget:Size(110, 14)
	focustarget:Point("TOPRIGHT", DuffedUIFocus, "BOTTOMRIGHT", 0, -7)
else
	focustarget:Size(80, 16)
	focustarget:Point("BOTTOMRIGHT", DuffedUIPlayer, "TOPRIGHT", 0,6)
	focus:Point("BOTTOMRIGHT", DuffedUIFocusTarget, "BOTTOMLEFT", -7, 0)
	if C["unitframes"].charportrait ~= true then
		focus:Size((playerwidth - 7) - 80, 16)
	else
		focus:Size((playerwidth + 55) - 80, 16)
	end
end

if C["raid"].arena then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "DuffedUIArena"..i)
		arena[i]:SetParent(DuffedUIPetBattleHider)
		if i == 1 then
			arena[i]:Point("RIGHT", UIParent, "RIGHT", -163, -250)
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 35)
		end
		arena[i]:Size(playerwidth-20, 39)
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

if C["raid"].showboss then
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
			boss[i]:Point("RIGHT", UIParent, "RIGHT", -163, -250)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 35)             
		end
		boss[i]:Size(playerwidth-20, 39)
	end
end

local assisttank_width = 90
local assisttank_height  = 20
if C["raid"].maintank == true then
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
	if C["chat"].rbackground then
		tank:SetPoint("TOPLEFT", DuffedUIChatBackgroundRight, "TOPLEFT", 2, 52)
	else
		tank:SetPoint("TOPLEFT", ChatFrame4, "TOPLEFT", 2, 62)
	end
end
 
if C["raid"].mainassist == true then
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
	if C["raid"].maintank == true then
		assist:SetPoint("TOPLEFT", DuffedUIMainTank, "BOTTOMLEFT", 2, -50)
	else
		assist:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

-- this is just a fake party to hide Blizzard frame if no DuffedUI raid layout are loaded.
local party = oUF:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)