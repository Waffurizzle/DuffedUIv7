local D, C, L, G = unpack(select(2, ...))

if not C["unitframes"].sComboenable or not C["unitframes"].enable then return end

local Options = {
	comboWidth = D.Scale(40),
	comboHeight = D.Scale(11),
	spacing = D.Scale(3), 
	colors = {
		[1] = {0.60, 0, 0, 1},
		[2] = {0.60, 0.30, 0, 1},
		[3] = {0.60, 0.60, 0, 1},
		[4] = {0.30, 0.60, 0, 1},
		[5] = {0, 0.60, 0, 1},
	},
}

local sAnchor = CreateFrame("Frame", "sCombosAnchor", UIParent)
sAnchor:Size(((Options.comboWidth + Options.spacing) * 5) - Options.spacing, 12)
sAnchor:SetPoint("CENTER", UIParent, "CENTER", 0, -185)
sAnchor:SetBackdropColor(0, 0, 0)
sAnchor:SetBackdropBorderColor(1, 0, 0)
sAnchor:SetTemplate("Default")
sAnchor:CreateShadow("Default")
sAnchor:SetMovable(true)
sAnchor:SetUserPlaced(true)
sAnchor:SetClampedToScreen(true)
sAnchor.text = sAnchor:CreateFontString(nil, "OVERLAY")
sAnchor.text:SetFont(C["media"].font, 12)
sAnchor.text:SetPoint("CENTER")
sAnchor.text:SetText("Move CP-Bar")
sAnchor:Hide()
tinsert(D.AllowFrameMoving, sCombosAnchor)

local sCombo = CreateFrame("Frame", "sCombo", UIParent)
for i = 1, 5 do
	sCombo[i] = CreateFrame("Frame", "sCombo"..i, UIParent)
	sCombo[i]:Size(Options.comboWidth, Options.comboHeight)
	sCombo[i]:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	sCombo[i].text = sCombo[i]:CreateFontString(nil, "OVERLAY")
	sCombo[i].text:SetFont(C["media"].font, 12)
	sCombo[i].text:SetPoint("CENTER")
	sCombo[i].text:SetText(i)
		
	if i == 1 then
		sCombo[i]:Point("TOPLEFT", sAnchor, "BOTTOMLEFT", 0, -3)
	else
		sCombo[i]:Point("LEFT", sCombo[i-1], "RIGHT", Options.spacing, 0)
	end
	
	sCombo[i]:SetTemplate("Default")
	sCombo[i]:CreateShadow("Default")
	sCombo[i]:CreateBackdrop()
	sCombo[i]:SetBackdropBorderColor(unpack(Options.colors[i]))
	sCombo[i]:RegisterEvent("PLAYER_ENTERING_WORLD")
	sCombo[i]:RegisterEvent("UNIT_COMBO_POINTS")
	sCombo[i]:RegisterEvent("PLAYER_TARGET_CHANGED")
	sCombo[i]:SetScript("OnEvent", function(self, event)
	local points, pt = 0, GetComboPoints("player", "target")
		if pt == points then
			sCombo[i]:Hide()
		elseif pt > points then
			for i = points + 1, pt do
				sCombo[i]:Show()
			end
		else
			for i = pt + 1, points do
				sCombo[i]:Hide()
			end
		end
		points = pt	
	end)
end

-- energy bar
if not C["unitframes"].sComboenergybar or not C["unitframes"].enable or not (D.myclass == "ROGUE" or D.myclass == "DRUID") then return end
local sPowerBG = CreateFrame("Frame", "sPowerBG", DuffedUITarget)
sPowerBG:Size((Options.comboWidth * 5) + (Options.spacing * 5) - Options.spacing, Options.comboHeight)
sPowerBG:SetPoint("TOPLEFT", sAnchor, "BOTTOMLEFT", 0, -(Options.comboHeight + 6))
sPowerBG:SetTemplate("Transparent")
sPowerBG:CreateShadow("Default")
local sPowerStatus = CreateFrame("StatusBar", "sPowerStatus", DuffedUITarget)
sPowerStatus:SetStatusBarTexture(C["media"].normTex)
sPowerStatus:SetFrameLevel(6)
sPowerStatus:Point("TOPLEFT", sPowerBG, "TOPLEFT", 2, -2)
sPowerStatus:Point("BOTTOMRIGHT", sPowerBG, "BOTTOMRIGHT", -2, 2)
sPowerStatus.t = sPowerStatus:CreateFontString(nil, "OVERLAY")
sPowerStatus.t:SetPoint("CENTER")
sPowerStatus.t:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
sPowerStatus.t:SetShadowOffset(0.5, -0.5)
sPowerStatus.t:SetShadowColor(0,0,0)
local color = RAID_CLASS_COLORS[D.myclass]
sPowerStatus:SetStatusBarColor(color.r, color.g, color.b)
local t = 0
sPowerStatus:SetScript("OnUpdate", function(self, elapsed)
    t = t + elapsed;
    if (t > 0.07) then
        sPowerStatus:SetMinMaxValues(0, UnitPowerMax("player"))
        local power = UnitPower("player")
        sPowerStatus:SetValue(power)
		sPowerStatus.t:SetText(power)
    end
end)
sPowerBG:RegisterEvent("PLAYER_ENTERING_WORLD")
sPowerBG:RegisterEvent("UNIT_DISPLAYPOWER")
sPowerBG:RegisterEvent("PLAYER_REGEN_ENABLED")
sPowerBG:RegisterEvent("PLAYER_REGEN_DISABLED")
sPowerBG:SetScript("OnEvent", function(self, event)
local p, _ = UnitPowerType("player")
    if p == SPELL_POWER_ENERGY then
        sPowerBG:Show()
        sPowerStatus:Show()
    else
        sPowerBG:Hide()
        sPowerStatus:Hide()
    end
end)