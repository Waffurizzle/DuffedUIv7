local D, C, L, G = unpack(select(2, ...)) 
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Setup Stance Bar
---------------------------------------------------------------------------

-- create the shapeshift bar if we enabled it
local bar = CreateFrame("Frame", "DuffedUIStance", UIParent, "SecureHandlerStateTemplate")
bar:SetPoint("TOPLEFT", 4, -46)
bar:SetWidth((D.petbuttonsize * 5) + (D.petbuttonsize * 4))
bar:SetHeight(10)
bar:SetFrameStrata("MEDIUM")
bar:SetMovable(true)
bar:SetClampedToScreen(true)
G.ActionBars.Stance = bar

-- shapeshift command to move totem or shapeshift in-game
local ssmover = CreateFrame("Frame", "DuffedUIStanceHolder", UIParent)
ssmover:SetAllPoints(DuffedUIStance)
ssmover:SetTemplate("Default")
ssmover:SetFrameStrata("HIGH")
ssmover:SetBackdropBorderColor(1,0,0)
ssmover:SetAlpha(0)
ssmover.text = D.SetFontString(ssmover, C["media"].uffont, 12)
ssmover.text:SetPoint("CENTER")
ssmover.text:SetText(L.move_shapeshift)
G.ActionBars.Stance.Holder = ssmover
tinsert(D.AllowFrameMoving, DuffedUIStance)

-- hide it if not needed and stop executing code
if C["actionbar"].hideshapeshift then DuffedUIStance:Hide() return end

local States = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
	["WARLOCK"] = "show,",
	["MONK"] = "show,",
}

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		StanceBarFrame.ignoreFramePositionManager = true
		StanceBarFrame:StripTextures()
		StanceBarFrame:SetParent(bar)
		StanceBarFrame:ClearAllPoints()
		StanceBarFrame:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", -11, 4)
		StanceBarFrame:EnableMouse(false)
		
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["StanceButton"..i]
			button:SetFrameStrata("LOW")
			if i ~= 1 then
				button:ClearAllPoints()				
				local previous = _G["StanceButton"..i-1]
				if C["actionbar"].verticalshapeshift then
					button:Point("TOP", previous, "BOTTOM", 0, -D.buttonspacing)
				else
					button:Point("LEFT", previous, "RIGHT", D.buttonspacing, 0)
				end
			end
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
			
			G.ActionBars.Stance["Button"..i] = button
		end
		RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle] hide; show")
	elseif event == "UPDATE_SHAPESHIFT_FORMS" then
		-- Update Stance Bar Button Visibility
		-- I seriously don't know if it's the best way to do it on spec changes or when we learn a new stance.
		if InCombatLockdown() then return end -- > just to be safe ;p
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["StanceButton"..i]
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
		end
		if C["actionbar"].verticalshapeshift then
			ShapeShiftBorder:Size(((StanceButton1:GetWidth() + D.buttonspacing)) + D.buttonspacing, StanceButton1:GetHeight() * GetNumShapeshiftForms()+ (GetNumShapeshiftForms() + 1) * D.buttonspacing)
		else
			ShapeShiftBorder:Size(((StanceButton1:GetWidth() + D.buttonspacing) * GetNumShapeshiftForms()) + D.buttonspacing, StanceButton1:GetHeight() + 2 * D.buttonspacing)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		D.ShiftBarUpdate(self)
		D.StyleShift(self)
		if C["actionbar"].verticalshapeshift then
			ShapeShiftBorder:Size(((StanceButton1:GetWidth() + D.buttonspacing)) + D.buttonspacing, StanceButton1:GetHeight() * GetNumShapeshiftForms() + (GetNumShapeshiftForms() + 1) * D.buttonspacing)
		else
			ShapeShiftBorder:Size(((StanceButton1:GetWidth() + D.buttonspacing) * GetNumShapeshiftForms()) + D.buttonspacing, StanceButton1:GetHeight()+ 2 * D.buttonspacing)
		end
		
		-- Mouseover
		if C["actionbar"].shapeshiftmouseover == true then
			local function mouseover(alpha)
				for i = 1, NUM_STANCE_SLOTS do
					local sb = _G["StanceButton"..i]
					sb:SetAlpha(alpha)
				end
			end
			
			for i = 1, NUM_STANCE_SLOTS do		
				_G["StanceButton"..i]:SetAlpha(0)
				_G["StanceButton"..i]:HookScript("OnEnter", function(self) mouseover(1) end)
				_G["StanceButton"..i]:HookScript("OnLeave", function(self) mouseover(0) end)
			end
			ShapeShiftBorder:EnableMouse(true)
			ShapeShiftBorder:HookScript("OnEnter", function(self) mouseover(1) end)
			ShapeShiftBorder:HookScript("OnLeave", function(self) mouseover(0) end)
		end
	else
		D.ShiftBarUpdate(self)
	end
end)

-- border
local ssborder = CreateFrame("Frame", "ShapeShiftBorder", StanceButton1)
if C["actionbar"].shapeshiftborder ~= true then
	ssborder:SetAlpha(0)
else
	ssborder:SetTemplate("Transparent")
	ssborder:CreateShadow("Default")
end
ssborder:SetFrameLevel(1)
ssborder:SetFrameStrata("BACKGROUND")
if C["actionbar"].verticalshapeshift then
	ssborder:Point("TOP", 0, D.buttonspacing)
else
	ssborder:Point("LEFT", -D.buttonspacing, 0)
end
RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")