local D, C, L, G = unpack(select(2, ...))

local cp = "|cff319f1b" -- +
local cm = "|cff9a1212" -- -
local function ShowOrHideBar(bar, button)
	local db = DuffedUIDataPerChar
	
	if bar:IsShown() then
		if bar == DuffedUIBar2 then
			if button == DuffedUIBar2Button then
				UnregisterStateDriver(bar, "visibility")
				bar:Hide()
				db.bar1 = true
			end
		end
		
		if bar == DuffedUIBar3 then
			if button == DuffedUIBar3Button then
				if db.rightbars == 1 then
					MultiBarRight:Show()
					db.rightbars = 2
					bar:SetWidth((D.buttonsize * 2) + (D.buttonspacing * 3))
				elseif db.rightbars == 2 then
					MultiBarRight:Hide()
					db.rightbars = 1
					bar:SetWidth((D.buttonsize * 1) + (D.buttonspacing * 2))
				end
			elseif button == DuffedUIBar3Button2 then
				db.rightbars = 0
				UnregisterStateDriver(bar, "visibility")
				bar:Hide()
			end
		end
	else
		if bar == DuffedUIBar2 then
			db.bar1 = false
			RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle] hide; show")
		end
		if bar == DuffedUIBar3 then
			if button == DuffedUIBar3Button then
				bar:SetWidth((D.buttonsize * 1) + (D.buttonspacing * 2))
				MultiBarRight:Hide()
				db.rightbars = 1
				RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle] hide; show")
			end
		end
	end
end

local function MoveButtonBar(button, bar)
	local db = DuffedUIDataPerChar
	
	if button == DuffedUIBar2Button then
		D.petBarPosition()
		D.cbPosition()
		if bar:IsShown() then
			button.text:SetText(cm.."-|r")
		else
			button.text:SetText(cp.."+|r")
		end
	end

	if button == DuffedUIBar3Button then
		if bar:IsShown() then
			if db.rightbars == 2 and button == DuffedUIBar3Button then
				button.text:SetText(cm..">|r")
				DuffedUIBar3Button2:Hide()
				button:Height(130)
				button:ClearAllPoints()
				button:Point("RIGHT", UIParent, "RIGHT", 1, -14)
				if C["actionbar"].petbarhorizontal ~= true then DuffedUIPetBar:Point("RIGHT", UIParent, "RIGHT", -23 -((D.buttonsize * 2) + (D.buttonspacing * 3)), -14) end
			elseif db.rightbars == 1 then
				DuffedUIBar3Button2:Show()
				button:Height(130/2)
				button:ClearAllPoints()
				button:Point("BOTTOMRIGHT", UIParent, "RIGHT", 1, -14)
				button.text:SetText(cp.."<|r")
				if C["actionbar"].petbarhorizontal ~= true then DuffedUIPetBar:Point("RIGHT", UIParent, "RIGHT", -23 -((D.buttonsize * 1) + (D.buttonspacing * 2)), -14) end
			end
		end
	elseif button == DuffedUIBar3Button2 then
		if db.rightbars == 0 then
			button:Hide()
			DuffedUIBar3Button:Height(130)
			DuffedUIBar3Button:ClearAllPoints()
			DuffedUIBar3Button:Point("RIGHT", UIParent, "RIGHT", 1, -14)
			if C["actionbar"].petbarhorizontal ~= true then DuffedUIPetBar:Point("RIGHT", UIParent, "RIGHT", -14, -14) end
		end
	end
end

local function UpdateBar(self, bar) -- guess what! :P
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	local button = self
	
	ShowOrHideBar(bar, button)
	MoveButtonBar(button, bar)
end

-- +/-
local DuffedUIBar2Button = CreateFrame("Button", "DuffedUIBar2Button", UIParent)
DuffedUIBar2Button:SetTemplate("Default")
DuffedUIBar2Button:CreateShadow("Default")
DuffedUIBar2Button:RegisterForClicks("AnyUp")
DuffedUIBar2Button.text = D.SetFontString(DuffedUIBar2Button, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
DuffedUIBar2Button:SetScript("OnClick", function(self, btn)
	if btn == "RightButton" then
		if DuffedUIInfoLeftBattleGround and UnitInBattleground("player") then
			ToggleFrame(DuffedUIInfoLeftBattleGround)
		end
	else
		UpdateBar(self, DuffedUIBar2)
	end
end)
if D.lowversion or C["actionbar"].layout ~= 1 then
	DuffedUIBar2Button:Size(DuffedUIInfoLeft:GetHeight())
	DuffedUIBar2Button:Point("LEFT", DuffedUIInfoLeft, "RIGHT", 2, 0)
else
	DuffedUIBar2Button:Point("TOPLEFT", DuffedUIInfoLeft, "TOPRIGHT", 2, 0)
	DuffedUIBar2Button:Point("BOTTOMRIGHT", DuffedUIInfoRight, "BOTTOMLEFT", -2, 0)
end
DuffedUIBar2Button.text:Point("CENTER", 2, -1)
if C["actionbar"].button2 == true then DuffedUIBar2Button:SetAlpha(0) else DuffedUIBar2Button:SetAlpha(1) end
DuffedUIBar2Button:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(C["media"].datatextcolor1)) end)
DuffedUIBar2Button:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C["media"].bordercolor)) end)
DuffedUIBar2Button.text:SetText(cm.."-|r")
DuffedUIBar2Button:SetParent(DuffedUIPetBattleHider)

-- >/< 1
local DuffedUIBar3Button = CreateFrame("Button", "DuffedUIBar3Button", UIParent)
DuffedUIBar3Button:Width(12)
DuffedUIBar3Button:Height(130)
DuffedUIBar3Button:Point("RIGHT", UIParent, "RIGHT", 1, -14)
DuffedUIBar3Button:SetTemplate("Default")
DuffedUIBar3Button:RegisterForClicks("AnyUp")
DuffedUIBar3Button:SetAlpha(0)
DuffedUIBar3Button:SetScript("OnClick", function(self) UpdateBar(self, DuffedUIBar3) end)
if C["actionbar"].rightbarsmouseover == true then
	DuffedUIBar3Button:SetScript("OnEnter", function(self) DuffedUIRightBarsMouseover(1) end)
	DuffedUIBar3Button:SetScript("OnLeave", function(self) DuffedUIRightBarsMouseover(0) end)
else
	DuffedUIBar3Button:SetScript("OnEnter", function(self) self:SetAlpha(1) DuffedUIBar3Button2:SetAlpha(1) end)
	DuffedUIBar3Button:SetScript("OnLeave", function(self) self:SetAlpha(0) DuffedUIBar3Button2:SetAlpha(0) end)
end
DuffedUIBar3Button.text = D.SetFontString(DuffedUIBar3Button, C["media"].font, 14)
DuffedUIBar3Button.text:Point("CENTER", 0, 0)
DuffedUIBar3Button.text:SetText(cm..">|r")

-- >/< 2
local DuffedUIBar3Button2 = CreateFrame("Button", "DuffedUIBar3Button2", UIParent)
DuffedUIBar3Button2:Width(DuffedUIBar3Button:GetWidth())
DuffedUIBar3Button2:Height((DuffedUIBar3Button:GetHeight()/2)+1)
DuffedUIBar3Button2:Point("TOP", DuffedUIBar3Button, "BOTTOM", 0, 1)
DuffedUIBar3Button2:SetTemplate("Default")
DuffedUIBar3Button2:RegisterForClicks("AnyUp")
DuffedUIBar3Button2:SetAlpha(0)
DuffedUIBar3Button2:Hide()
DuffedUIBar3Button2:SetScript("OnClick", function(self) UpdateBar(self, DuffedUIBar3) end)
if C["actionbar"].rightbarsmouseover == true then
	DuffedUIBar3Button2:SetScript("OnEnter", function(self) DuffedUIRightBarsMouseover(1) end)
	DuffedUIBar3Button2:SetScript("OnLeave", function(self) DuffedUIRightBarsMouseover(0) end)
else
	DuffedUIBar3Button2:SetScript("OnEnter", function(self) self:SetAlpha(1) DuffedUIBar3Button:SetAlpha(1) end)
	DuffedUIBar3Button2:SetScript("OnLeave", function(self) self:SetAlpha(0) DuffedUIBar3Button:SetAlpha(0) end)
end
DuffedUIBar3Button2.text = D.SetFontString(DuffedUIBar3Button2, C["media"].font, 14)
DuffedUIBar3Button2.text:Point("CENTER", 0, 0)
DuffedUIBar3Button2.text:SetText(cm..">|r")

-- exit vehicle button on left side of bottom action bar
local vehicleleft = CreateFrame("Button", "DuffedUIExitVehicleButtonLeft", UIParent, "SecureHandlerClickTemplate")
vehicleleft:SetAllPoints(DuffedUIInfoLeft)
vehicleleft:SetFrameStrata("LOW")
vehicleleft:SetFrameLevel(10)
vehicleleft:SetTemplate("Default")
vehicleleft:SetBackdropBorderColor(75/255,  175/255, 76/255)
vehicleleft:RegisterForClicks("AnyUp")
vehicleleft:SetScript("OnClick", function() VehicleExit() end)
vehicleleft:FontString("text", C["media"].font, 12)
vehicleleft.text:Point("CENTER", 0, 0)
vehicleleft.text:SetText("|cff4BAF4C"..string.upper(LEAVE_VEHICLE).."|r")
RegisterStateDriver(vehicleleft, "visibility", "[target=vehicle,exists] show;hide")
G.ActionBars.ExitVehicleLeft = vehicleleft

-- exit vehicle button on right side of bottom action bar
local vehicleright = CreateFrame("Button", "DuffedUIExitVehicleButtonRight", UIParent, "SecureHandlerClickTemplate")
vehicleright:SetAllPoints(DuffedUIInfoRight)
vehicleright:SetTemplate("Default")
vehicleright:SetFrameStrata("LOW")
vehicleright:SetFrameLevel(10)
vehicleright:SetBackdropBorderColor(75/255,  175/255, 76/255)
vehicleright:RegisterForClicks("AnyUp")
vehicleright:SetScript("OnClick", function() VehicleExit() end)
vehicleright:FontString("text", C["media"].font, 12)
vehicleright.text:Point("CENTER", 0, 0)
vehicleright.text:SetText("|cff4BAF4C"..string.upper(LEAVE_VEHICLE).."|r")
RegisterStateDriver(vehicleright, "visibility", "[target=vehicle,exists] show;hide")
G.ActionBars.ExitVehicleRight = vehicleright

local init = CreateFrame("Frame")
init:RegisterEvent("VARIABLES_LOADED")
init:SetScript("OnEvent", function(self, event)
	if not DuffedUIDataPerChar then DuffedUIDataPerChar = {} end
	local db = DuffedUIDataPerChar
	
	D.cbPosition()
	D.petBarPosition()

	-- Third Bar at the bottom
	if db.bar1 then
		UpdateBar(DuffedUIBar2Button, DuffedUIBar2)
	end

	-- Rightbars on startup
	if db.rightbars == nil then db.rightbars = 2 end
	if db.rightbars == 1 then
		MoveButtonBar(DuffedUIBar3Button, DuffedUIBar3)
		DuffedUIBar3:SetWidth((D.buttonsize * 1) + (D.buttonspacing * 2))
		if C["actionbar"].petbarhorizontal ~= true then DuffedUIPetBar:Point("RIGHT", UIParent, "RIGHT", -23 -((D.buttonsize * 1) + (D.buttonspacing * 2)), -14) end
	elseif db.rightbars == 0 then
		UnregisterStateDriver(DuffedUIBar3, "visibility")
		DuffedUIBar3Button.text:SetText(cp.."<|r")
		DuffedUIBar3:Hide()
		if C["actionbar"].petbarhorizontal ~= true then DuffedUIPetBar:Point("RIGHT", UIParent, "RIGHT", -14, -14) end
	elseif db.rightbars == 2 then
		if C["actionbar"].petbarhorizontal ~= true then DuffedUIPetBar:Point("RIGHT", UIParent, "RIGHT", -23 -((D.buttonsize * 2) + (D.buttonspacing * 3)), -14) end
	end
end)