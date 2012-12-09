local D, C, L, G = unpack(select(2, ...))
if C["duffed"].dispelannouncement ~= true then return end

local textcolor = "|cff00ff00"

-- Create movable frame for dispel announcements
local f = CreateFrame("MessageFrame", "dDispelFrame", UIParent)
f:SetPoint("TOP", 0, -220)
f:SetSize(200, 100)
f:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
f:SetShadowOffset(1, -1)
f:SetShadowColor(0,0,0)
f:SetTimeVisible(2)
f:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground"})
f:SetBackdropColor(0,0,0,0)
f:SetMovable(true)
f:SetFrameStrata("HIGH")
f:SetInsertMode("TOP")
f:SetJustifyH("CENTER")
f:SetClampedToScreen(true)
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

f:SetScript("OnEvent", function(self, event, ...)
	local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	if (eventType == "SPELL_DISPEL" or eventType == "SPELL_STOLEN") and sourceName == UnitName("player") then
		f:AddMessage("- "..textcolor..select(14, ...), 1, 1, 1)
	end
end)

DuffedC = {
	["dispel"] = true,
}
local dc = DuffedC
SLASH_DUFFED1 = "/duffed"
SlashCmdList["DUFFED"] = function(msg)
	if (msg == "dispel") and C["duffed"].dispelannouncement then
		if dc.dispel then
			dc.dispel = false
			dDispelFrame:AddMessage("- "..textcolor.."around!", 1, 1, 1)
			dDispelFrame:AddMessage("- "..textcolor.."Dispelframe", 1, 1, 1)
			dDispelFrame:AddMessage("- "..textcolor.."Move", 1, 1, 1)
			dDispelFrame:SetTimeVisible(999)
			dDispelFrame:EnableMouse(true)
			dDispelFrame:SetScript("OnMouseDown", function() f:StartMoving() end)
			dDispelFrame:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)
			dDispelFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.6)
			print("Frame |cffff0000unlocked.")
		else
			dc.dispel = true
			dDispelFrame:SetTimeVisible(2)
			dDispelFrame:EnableMouse(false)
			dDispelFrame:SetBackdropColor(0,0,0,0)
			print("Frame |cff00ff00locked.")
		end
	else
		print(" ")
		print("Duffed Slash commands:")
		if C["duffed"].dispelannouncement then print("   |cffce3a19/duffed dispel|r - unlock/lock Dispel Frame.") end
	end
end