local D, C, L, G = unpack(select(2, ...))
if C["misc"].exp_rep ~= true then return end

local font = C["media"].font
local font_s = C["datatext"].fontsize
local font_st = "THINOUTLINE"
local backdrop = C["media"].backdropcolor

----------------
-- Experience --
----------------
local exp = CreateFrame("StatusBar", "DuffedUIExperience", DuffedUIBar1)
exp:SetStatusBarTexture(normTex)
exp:SetStatusBarColor(0, 0.4, 1, .8)
exp:SetBackdrop(backdrop)
exp:SetBackdropColor(unpack(backdrop))
exp:Size(D.Scale(155), D.Scale(15))
if C["actionbar"].layout == 1 then
	exp:Point("TOPRIGHT", DuffedUIBar1, "TOPRIGHT", -18, 21)
else
	exp:Point("BOTTOMRIGHT", DuffedUIBar1, "BOTTOMRIGHT", -18, -21)
end

local eText  = DuffedUIExperience:CreateFontString("DuffedUIExperienceText", "LOW")	
eText:SetFont(font, font_s, font_st)
eText:SetPoint("CENTER", DuffedUIExperience, 0, 0)

local function GetPlayerXP()
	return UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
end

local function Experience(self, event)
	local min, max, rested = GetPlayerXP()
	local percentage = min / max * 100
	local bars = min / max * 20

	eText:SetText(format("XP: "..D.panelcolor.."%.2f%%", percentage))
	
	-- Setup Experience  tooltip
	self:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = D.DataTextTooltipAnchor(eText)
			GameTooltip:SetOwner(self, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(format("Experience")) 
			GameTooltip:AddDoubleLine("Earned:", format(D.panelcolor.."%.f", min), 1, 1, 1, .65, .65, .65)
			GameTooltip:AddDoubleLine("Total:", format(D.panelcolor.."%.f", max), 1, 1, 1, .65, .65, .65)
			if rested ~= nil and rested > 0 then
				GameTooltip:AddDoubleLine("Rested:", format("|cff0090ff%.f", rested), 1, 1, 1, .65, .65, .65)
			end
			GameTooltip:AddDoubleLine("Bars:", format(D.panelcolor.."%d / 20", bars), 1, 1, 1, .65, .65, .65)
			GameTooltip:Show()
		end
	end)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
end
exp:RegisterEvent("PLAYER_ENTERING_WORLD")
exp:RegisterEvent("PLAYER_XP_UPDATE")
exp:RegisterEvent("PLAYER_LEVEL_UP")
exp:RegisterEvent("UPDATE_EXHAUSTION")
exp:SetScript("OnEvent", Experience)
exp:SetScript("OnEnter", OnEnter)

-- explines
local expr = CreateFrame("Frame", "ExpLineRight", DuffedUIExperience)
expr:SetTemplate("Default")
expr:Size(7, 2)
expr:SetPoint("LEFT", DuffedUIExperience, "RIGHT", 3, 0)

local expd = CreateFrame("Frame", "ExpLineDown", DuffedUIExperience)
expd:SetTemplate("Default")
if C["actionbar"].layout == 1 then
	expd:Size(2, 14)
	expd:SetPoint("TOP", expr, "RIGHT", 0, 1)
else
	expd:Size(2, 13)
	expd:SetPoint("BOTTOM", expr, "RIGHT", 0, -1)
end

-- border and shadows
exp:CreateBackdrop()
exp.backdrop:CreateShadow()

----------------
-- Reputation --
----------------
local rep = CreateFrame("StatusBar", "DuffedUIReputation", DuffedUIBar1)
rep:SetStatusBarTexture(normTex)
rep:SetStatusBarColor(0, 0.4, 1, .8)
rep:SetBackdrop(backdrop)
rep:SetBackdropColor(unpack(backdrop))
rep:Size(D.Scale(155), D.Scale(15))
if C["actionbar"].layout == 1 then
	rep:Point("TOPLEFT", DuffedUIBar1, "TOPLEFT", 18, 21)
else
	rep:Point("BOTTOMLEFT", DuffedUIBar1, "BOTTOMLEFT", 18, -21)
end

local rText  = DuffedUIReputation:CreateFontString("DuffedUIReputationText", "LOW")	
rText:SetFont(font, font_s, font_st)
rText:SetPoint("CENTER", DuffedUIReputation, 0, 0)

local function Reputation(self, event)
	local name, standing, max, min, value = GetWatchedFactionInfo()
	local percentage 
	if value > 0 then
		percentage = (max - value) / (max - min) * 100
	else
		percentage = 0
	end

	if GetWatchedFactionInfo() ~= nil then
		rText:SetText(format(name..": %s%d%%", D.panelcolor, percentage))
	else
		rText:SetFormattedText(D.panelcolor.."No Faction")
	end

	-- Setup Reputation tooltip
	self:SetScript("OnEnter", function()
		if not InCombatLockdown() then
			local anchor, panel, xoff, yoff = D.DataTextTooltipAnchor(rText)
			GameTooltip:SetOwner(self, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			if GetWatchedFactionInfo() ~= nil then
				GameTooltip:AddLine("Reputation")
				GameTooltip:AddDoubleLine("Faction:", format("|cffffffff"..name), 1, 1, 1, .65, .65, .65)
				GameTooltip:AddDoubleLine("Standing:", _G['FACTION_STANDING_LABEL'..standing], 1, 1, 1, FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
				GameTooltip:AddDoubleLine("Rep earned:", format("|cffffffff%.f", value - max), 1, 1, 1, .65, .65, .65)
				GameTooltip:AddDoubleLine("Rep total:", format("|cffffd200%.f", min - max), 1, 1, 1, .65, .65, .65)
			else
				GameTooltip:AddDoubleLine("|cffffffffFaction:|r")
				GameTooltip:AddLine("No Faction Tracked")
			end
			GameTooltip:Show()
		end
	end)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
end
rep:RegisterEvent("PLAYER_ENTERING_WORLD")
rep:RegisterEvent("UPDATE_FACTION")
rep:SetScript("OnEvent", Reputation)
rep:SetScript("OnEnter", OnEnter)
rep:SetScript("OnMouseDown", function() ToggleCharacter("ReputationFrame") end)

-- replines
local repl = CreateFrame("Frame", "RepLineLeft", DuffedUIReputation)
repl:SetTemplate("Default")
repl:Size(7, 2)
repl:SetPoint("RIGHT", DuffedUIReputation, "LEFT", -3, 0)

local repd = CreateFrame("Frame", "RepLineDown", DuffedUIReputation)
repd:SetTemplate("Default")
if C["actionbar"].layout == 1 then
	repd:Size(2, 14)
	repd:SetPoint("TOP", repl, "LEFT", 0, 1)
else
	repd:Size(2, 13)
	repd:SetPoint("BOTTOM", repl, "LEFT", 0, -1)
end

-- border and shadows
rep:CreateBackdrop()
rep.backdrop:CreateShadow()