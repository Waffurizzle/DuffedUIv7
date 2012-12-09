local D, C, L, G = unpack(select(2, ...))

--------------------------------------------------------------------
-- Experience
--------------------------------------------------------------------
if C["datatext"].experience and C["datatext"].experience > 0 then
	local Stat = CreateFrame("Frame", "DuffedUIStatExperience")
	Stat:EnableMouse(true)

	local Text = Stat:CreateFontString("DuffedUIStatExperienceText", "LOW")		
	Text:SetFont(C["media"].font, C["datatext"].fontsize)
	D.DataTextPosition(C["datatext"].experience, Text)
	
	local function GetPlayerXP()
		return UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
	end
		
	local function OnEvent(self, event)
		local min, max, rested = GetPlayerXP()
		local percentage = min / max * 100
		local bars = min / max * 20
		
		Text:SetText(format("XP: "..D.panelcolor.."%.2f%%", percentage))
			
		-- Setup Experience  tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			if not InCombatLockdown() then
				local anchor, panel, xoff, yoff = D.DataTextTooltipAnchor(Text)
				if panel == DuffedUIMinimapStatsLeft or panel == DuffedUIMinimapStatsRight then
					GameTooltip:SetOwner(panel, anchor, xoff, yoff)
				else
					GameTooltip:SetOwner(self, anchor, xoff, yoff)
				end
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
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("PLAYER_XP_UPDATE")
	Stat:RegisterEvent("PLAYER_LEVEL_UP")
	Stat:RegisterEvent("UPDATE_EXHAUSTION")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", OnEnter)	
end

--------------------------------------------------------------------
-- Reputation
--------------------------------------------------------------------
if C["datatext"].reputation and C["datatext"].reputation > 0 then
	local Stat = CreateFrame("Frame", "DuffedUIStatReputation")
	Stat:EnableMouse(true)

	local Text  = Stat:CreateFontString("DuffedUIStatReputationText", "LOW")	
	Text:SetFont(C["media"].font, C["datatext"].fontsize)
	D.DataTextPosition(C["datatext"].reputation, Text)

	local function OnEvent(self, event)
		local name, standing, max, min, value = GetWatchedFactionInfo()
		local percentage 
		if value > 0 then
			percentage = (max - value) / (max - min) * 100
		else
			percentage = 0
		end
		
		if GetWatchedFactionInfo() ~= nil then
			Text:SetText(format(name..": %s%d%%", D.panelcolor, percentage))
		else
			Text:SetFormattedText(D.panelcolor.."No Faction")
		end
	
		-- Setup Reputation tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()
			if not InCombatLockdown() then
				local anchor, panel, xoff, yoff = D.DataTextTooltipAnchor(Text)
				if panel == DuffedUIMinimapStatsLeft or panel == DuffedUIMinimapStatsRight then
					GameTooltip:SetOwner(panel, anchor, xoff, yoff)
				else
					GameTooltip:SetOwner(self, anchor, xoff, yoff)
				end
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
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("UPDATE_FACTION")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", OnEnter)
	Stat:SetScript("OnMouseDown", function() ToggleCharacter("ReputationFrame") end)
end

--------------------------------------------------------------------
-- Honor
--------------------------------------------------------------------
if C["datatext"].honor and C["datatext"].honor > 0 then
	local Stat = CreateFrame("Frame", "DuffedUIStatHonor")
	
	local Text  = Stat:CreateFontString("DuffedUIStatHonorText", "LOW")		
	Text:SetFont(C["media"].font, C["datatext"].fontsize)
	D.DataTextPosition(C["datatext"].honor, Text)
	
	local function OnEvent(self, event)
		local _, amount, _ = GetCurrencyInfo(392)
		Text:SetText("Honor: "..D.panelcolor..amount)
	end

	-- Make sure the panel gets displayed when the player logs in
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Make sure the panel updates when your amount of honor changes
	Stat:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

	Stat:SetScript("OnEvent", OnEvent)
end

--------------------------------------------------------------------
-- Honorable Kills
--------------------------------------------------------------------
if C["datatext"].honorablekills and C["datatext"].honorablekills > 0 then
	local Stat = CreateFrame("Frame", "DuffedUIStatHK")
	
	local Text  = Stat:CreateFontString("DuffedUIStatHKText", "LOW")		
	Text:SetFont(C["media"].font, C["datatext"].fontsize)
	D.DataTextPosition(C["datatext"].honorablekills, Text)
	
	local function OnEvent(self, event)
		Text:SetText("Kills: "..D.panelcolor..GetPVPLifetimeStats())
	end

	-- Make sure the panel gets displayed when the player logs in
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Make sure the panel updates when your amount of honorable kills changes
	Stat:RegisterEvent("PLAYER_PVP_KILLS_CHANGED")

	Stat:SetScript("OnEvent", OnEvent)
end