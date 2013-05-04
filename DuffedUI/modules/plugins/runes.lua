local D, C, L, G = unpack(select(2, ...))

if D.myclass ~= "DEATHKNIGHT" then return end

local colors = {
	{ 0.69, 0.31, 0.31 }, -- blood
	{ 0.33, 0.59, 0.33 }, -- unholy
	{ 0.31, 0.45, 0.63 }, -- frost
	{ 0.84, 0.75, 0.65 }, -- death
	{ 0, 0.82, 1 }, -- runic power
}
local movable = false
local runes = {}
local runemap = { 1, 2, 3, 4, 5, 6 }

if C["runes"].enable == true then
	local dRunesAnchorFrame = CreateFrame("Frame", "dRunesAnchorFrame", UIParent)
	dRunesAnchorFrame:Size(100, 15)
	dRunesAnchorFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
	dRunesAnchorFrame:SetFrameStrata("TOOLTIP")
	dRunesAnchorFrame:SetFrameLevel(20)
	dRunesAnchorFrame:SetTemplate("Default")
	dRunesAnchorFrame:SetBackdropColor(0, 0, 0)
	dRunesAnchorFrame:SetBackdropBorderColor(1, 0, 0)
	dRunesAnchorFrame.Text = D.SetFontString(dRunesAnchorFrame, C["media"].uffont, 12)
	dRunesAnchorFrame.Text:SetText("Move dRunes")
	dRunesAnchorFrame.Text:SetPoint("CENTER")
	dRunesAnchorFrame:SetMovable(true)
	dRunesAnchorFrame:SetUserPlaced(true)
	dRunesAnchorFrame:SetClampedToScreen(true)
	dRunesAnchorFrame:Hide()
	tinsert(D.AllowFrameMoving, dRunesAnchorFrame)

	dRunes = CreateFrame("Frame", "dRunes", UIParent)
	if C["runes"].displayrpbar then
		dRunes:SetPoint("BOTTOM", dRunesAnchorFrame, "TOP", 0, 6 + (C["runes"].rpbarthickness))
	else
		dRunes:SetPoint("BOTTOM", dRunesAnchorFrame, "TOP", 0, 3)
	end
	if C["runes"].growthdirection == "VERTICAL" then
		dRunes:SetSize(C["runes"].barthickness * 6 + 9, C["runes"].barlength)
	else
		dRunes:SetSize(C["runes"].barlength, C["runes"].barthickness * 6 + 9)
	end
	dRunes:SetTemplate("Transparent")
	dRunes:CreateShadow("Default")

	for i = 1, 6 do
		local rune = CreateFrame("StatusBar", "dRunesRune"..i, dRunes)
		rune:SetStatusBarTexture(C["media"].normTex)
		rune:SetStatusBarColor(unpack(colors[math.ceil(runemap[i] / 2) ]))
		rune:SetMinMaxValues(0, 10)

		if C["runes"].growthdirection == "VERTICAL" then
			rune:SetOrientation("VERTICAL")
			rune:SetWidth(C["runes"].barthickness)
		else
			rune:SetOrientation("HORIZONTAL")
			rune:SetHeight(C["runes"].barthickness)
		end

		if i == 1 then
			rune:SetPoint("TOPLEFT", dRunes, "TOPLEFT", 2, -2)
			if C["runes"].growthdirection == "VERTICAL" then
				rune:SetPoint("BOTTOMLEFT", dRunes, "BOTTOMLEFT", 2, 2)
			else
				rune:SetPoint("TOPRIGHT", dRunes, "TOPRIGHT", -2, -2)
			end
		else
			if C["runes"].growthdirection == "VERTICAL" then
				rune:SetHeight(runes[1]:GetHeight())
				rune:SetPoint("LEFT", runes[i - 1], "RIGHT", 1, 0)
			else
				rune:SetWidth(runes[1]:GetWidth())
				rune:SetPoint("TOP", runes[i - 1], "BOTTOM", 0, -1)
			end
		end

		tinsert(runes, rune)
	end

	if C["runes"].displayrpbar then
		local rpbarbg = CreateFrame("Frame", "dRunesRunicPower", dRunes)
		rpbarbg:SetPoint("TOPLEFT", dRunes, "BOTTOMLEFT", 0, -3)
		rpbarbg:SetPoint("TOPRIGHT", dRunes, "BOTTOMRIGHT", 0, -3)
		rpbarbg:SetHeight(C["runes"].rpbarthickness)
		rpbarbg:SetTemplate("Transparent")
		rpbarbg:CreateShadow("Default")

		local rpbar = CreateFrame("StatusBar", nil, rpbarbg)
		rpbar:SetStatusBarTexture(C["media"].normTex)
		rpbar:SetStatusBarColor(unpack(colors[5]))
		rpbar:SetMinMaxValues(0, 100)
		rpbar:SetPoint("TOPLEFT", rpbarbg, "TOPLEFT", 2, -2)
		rpbar:SetPoint("BOTTOMRIGHT", rpbarbg, "BOTTOMRIGHT", -2, 2)

		if C["runes"].displayrpbartext then
			local fontHeight = rpbar:GetHeight() - 4
			if fontHeight < 11 then
				fontHeight = 11
			end

			rpbar.text = rpbar:CreateFontString(nil, "ARTWORK")
			rpbar.text:SetFont(C["media"]["font"], fontHeight, "THINOUTLINE")
			rpbar.text:SetPoint("CENTER", 1, 0)
			rpbar.text:SetTextColor(unpack(colors[5]))
		end

		rpbar.TimeSinceLastUpdate = 0
		rpbar:SetScript("OnUpdate", function(self, elapsed)
			self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed 

			if self.TimeSinceLastUpdate > 0.07 then
				self:SetMinMaxValues(0, UnitPowerMax("player"))
				local power = UnitPower("player")
				self:SetValue(power)
				if self.text then
					self.text:SetText(power)
				end
				self.TimeSinceLastUpdate = 0
			end
		end)
	end

	local function UpdateRune(id, start, duration, finished)
		local rune = runes[id]

		rune:SetStatusBarColor(unpack(colors[GetRuneType(runemap[id])]))
		rune:SetMinMaxValues(0, duration)

		if finished then
			rune:SetValue(duration)
		else
			rune:SetValue(GetTime() - start)
		end
	end

	local OnUpdate = CreateFrame("Frame")
	OnUpdate.TimeSinceLastUpdate = 0
	local updateFunc = function(self, elapsed)
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed

		if self.TimeSinceLastUpdate > 0.07 then
			for i = 1, 6 do
				UpdateRune(i, GetRuneCooldown(runemap[i]))
			end
			self.TimeSinceLastUpdate = 0
		end
	end
	OnUpdate:SetScript("OnUpdate", updateFunc)

	dRunes:RegisterEvent("PLAYER_REGEN_DISABLED")
	dRunes:RegisterEvent("PLAYER_REGEN_ENABLED")
	dRunes:RegisterEvent("PLAYER_ENTERING_WORLD")
	dRunes:SetScript("OnEvent", function(self, event)
		if not C["runes"].hideooc then
			dRunes:UnregisterAllEvents()
		elseif event == "PLAYER_REGEN_DISABLED" then
			UIFrameFadeIn(self, (0.3 * (1 - self:GetAlpha())), self:GetAlpha(), 1)
			OnUpdate:SetScript("OnUpdate", updateFunc)
		elseif event == "PLAYER_REGEN_ENABLED" then
			UIFrameFadeOut(self, (0.3 * (0 + self:GetAlpha())), self:GetAlpha(), 0)
			OnUpdate:SetScript("OnUpdate", nil)
		elseif event == "PLAYER_ENTERING_WORLD" then
			RuneFrame:ClearAllPoints()
			if not InCombatLockdown() then
				dRunes:SetAlpha(0)
			end
		end
	end)

	RuneFrame:Hide()
	RuneFrame:SetScript("OnShow", function(self)
		self:Hide()
	end)

	--[[if C["runes"].soulreaper then
		local name, _, icon = GetSpellInfo(114866)

		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Size(50)
		frame:SetPoint("LEFT", _G["dRunes"], "RIGHT", 10, 0)
		frame:SetTemplate("Default")
		frame:SetAlpha(1)

		frame.icon = frame:CreateTexture(nil, "OVERLAY")
		frame.icon:SetTexture(icon)
		frame.icon:SetSize(frame:GetHeight() - 4, frame:GetHeight() - 4)
		frame.icon:SetPoint("CENTER")
		frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		function frame:FadeIn()
			UIFrameFadeIn(self, (0.3 * (1 - self:GetAlpha())), self:GetAlpha(), 1)
		end

		function frame:FadeOut()
			UIFrameFadeOut(self, (0.3 * (0 + self:GetAlpha())), self:GetAlpha(), 0)
		end

		local function OnEvent(self, event)
			local ahealth = math.floor(UnitHealth("target") / UnitHealthMax("target") * 100)
			isUsable = IsUsableSpell(name)

			if ahealth <= 35 then
				if isUsable then
					self:FadeOut()
				else
					self:FadeIn()
				end
			end
		end

		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
		frame:RegisterEvent("SPELL_UPDATE_USABLE")
		frame:SetScript("OnEvent", OnEvent)
	end]]--
end