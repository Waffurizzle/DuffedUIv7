local D, C, L, G = unpack(select(2, ...))
if C["misc"].exp_rep ~= true then return end

local font = C["media"].font
local font_s = C["datatext"].fontsize
local font_st = "THINOUTLINE"

----------------
-- Experience --
----------------
if D.level ~= MAX_PLAYER_LEVEL then
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
	DuffedUIExperience:RegisterEvent("PLAYER_ENTERING_WORLD")
	DuffedUIExperience:RegisterEvent("PLAYER_XP_UPDATE")
	DuffedUIExperience:RegisterEvent("PLAYER_LEVEL_UP")
	DuffedUIExperience:RegisterEvent("UPDATE_EXHAUSTION")
	DuffedUIExperience:SetScript("OnEvent", Experience)
	DuffedUIExperience:SetScript("OnEnter", OnEnter)
else
	local eText  = DuffedUIExperience:CreateFontString("DuffedUIExperienceText", "LOW")	
	eText:SetFont(font, font_s, font_st)
	eText:SetPoint("CENTER", DuffedUIExperience, 0, 0)
	eText:SetText(L.unitframes_ouf_threattext2)
end

----------------
-- Reputation --
----------------
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
DuffedUIReputation:RegisterEvent("PLAYER_ENTERING_WORLD")
DuffedUIReputation:RegisterEvent("UPDATE_FACTION")
DuffedUIReputation:SetScript("OnEvent", Reputation)
DuffedUIReputation:SetScript("OnEnter", OnEnter)
DuffedUIReputation:SetScript("OnMouseDown", function() ToggleCharacter("ReputationFrame") end)