local D, C, L, G = unpack(select(2, ...))

if D.myclass ~= "DEATHKNIGHT" then return end

dRunesSettings = {
	texture = C["media"].normTex,
	barLength = 40,
	barThickness = 14,
	rpBarThickness = 10,
	hideOOC = false,
	x = 0,
	y = 170,
	growthDirection = "VERTICAL", -- HORIZONTAL or VERTICAL

	displayRpBar = true, -- runic power bar below the runes
	displayRpBarText = true, -- runic power text on the runic power bar

	--runestrike = false, -- shows a rune strike icon whenever it's usable

	colors = {
		{ 0.69, 0.31, 0.31 }, -- blood
		{ 0.33, 0.59, 0.33 }, -- unholy
		{ 0.31, 0.45, 0.63 }, -- frost
		{ 0.84, 0.75, 0.65 }, -- death
		{ 0, 0.82, 1 }, -- runic power
	},
	
	--[[
		runemap instructions.
		This is the order you want your runes to be displayed in (down to bottom or left to right).
		1,2 = Blood
		3,4 = Unholy
		5,6 = Frost
		(Note: All numbers must be included or it will break)
	]]
	runemap = { 1, 2, 3, 4, 5, 6 },
}

local movable = false
local colors = dRunesSettings.colors
local runes = {}
local runemap = dRunesSettings.runemap

if C["duffed"].runes == true then
	local dRunesAnchorFrame = CreateFrame("Frame", "dRunesAnchorFrame", UIParent)
	dRunesAnchorFrame:Size(150, 15)
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
	if dRunesSettings.displayRpBar then
		dRunes:SetPoint("BOTTOM", dRunesAnchorFrame, "TOP", 0, 6 + (dRunesSettings.rpBarThickness or 10))
	else
		dRunes:SetPoint("BOTTOM", dRunesAnchorFrame, "TOP", 0, 3)
	end
	if dRunesSettings.growthDirection == "VERTICAL" then
		dRunes:SetSize(dRunesSettings.barThickness * 6 + 9, dRunesSettings.barLength)
	else
		dRunes:SetSize(dRunesSettings.barLength, dRunesSettings.barThickness * 6 + 9)
	end
	dRunes:SetTemplate("Transparent")
	dRunes:CreateShadow("Default")

	for i = 1, 6 do
		local rune = CreateFrame("StatusBar", "dRunesRune"..i, dRunes)
		rune:SetStatusBarTexture(dRunesSettings.texture)
		rune:SetStatusBarColor(unpack(colors[math.ceil(runemap[i] / 2) ]))
		rune:SetMinMaxValues(0, 10)

		if dRunesSettings.growthDirection == "VERTICAL" then
			rune:SetOrientation("VERTICAL")
			rune:SetWidth(dRunesSettings.barThickness)
		else
			rune:SetOrientation("HORIZONTAL")
			rune:SetHeight(dRunesSettings.barThickness)
		end

		if i == 1 then
			rune:SetPoint("TOPLEFT", dRunes, "TOPLEFT", 2, -2)
			if dRunesSettings.growthDirection == "VERTICAL" then
				rune:SetPoint("BOTTOMLEFT", dRunes, "BOTTOMLEFT", 2, 2)
			else
				rune:SetPoint("TOPRIGHT", dRunes, "TOPRIGHT", -2, -2)
			end
		else
			if dRunesSettings.growthDirection == "VERTICAL" then
				rune:SetHeight(runes[1]:GetHeight())
				rune:SetPoint("LEFT", runes[i - 1], "RIGHT", 1, 0)
			else
				rune:SetWidth(runes[1]:GetWidth())
				rune:SetPoint("TOP", runes[i - 1], "BOTTOM", 0, -1)
			end
		end

		tinsert(runes, rune)
	end

	if dRunesSettings.displayRpBar then
		local rpbarbg = CreateFrame("Frame", "dRunesRunicPower", dRunes)
		rpbarbg:SetPoint("TOPLEFT", dRunes, "BOTTOMLEFT", 0, -3)
		rpbarbg:SetPoint("TOPRIGHT", dRunes, "BOTTOMRIGHT", 0, -3)
		rpbarbg:SetHeight(dRunesSettings.rpBarThickness or 10)
		rpbarbg:SetTemplate("Transparent")
		rpbarbg:CreateShadow("Default")

		local rpbar = CreateFrame("StatusBar", nil, rpbarbg)
		rpbar:SetStatusBarTexture(dRunesSettings.texture)
		rpbar:SetStatusBarColor(unpack(colors[5]))
		rpbar:SetMinMaxValues(0, 100)
		rpbar:SetPoint("TOPLEFT", rpbarbg, "TOPLEFT", 2, -2)
		rpbar:SetPoint("BOTTOMRIGHT", rpbarbg, "BOTTOMRIGHT", -2, 2)

		if dRunesSettings.displayRpBarText then
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
		if not dRunesSettings.hideOOC then
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

	--[[local name, _, icon = GetSpellInfo(56815)

	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Size(50)
	frame:SetPoint("BOTTOM", _G["dRunes"], "TOP", 0, 10)
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
		isUsable = IsUsableSpell(name)

		if isUsable then
			self:FadeIn()
		else
			self:FadeOut()
		end
	end

	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
	frame:RegisterEvent("SPELL_UPDATE_USABLE")
	frame:SetScript("OnEvent", OnEvent)]]--
end