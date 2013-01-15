--[[local D, C, L, G = unpack(select(2, ...))

local Version = tonumber(GetAddOnMetadata("DuffedUI", "Version"))
local SendAddonMessage = SendAddonMessage
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local tonumber = tonumber

local CheckCurrentDuffedUIVersion = function(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if (prefix ~= "DuffedUI") or (sender == D.myname) then
			return
		end

		if tonumber(message) > Version then
			print("|cffffff00" .. L.UI_Outdated .. "|r")
			self:UnregisterEvent("CHAT_MSG_ADDON")
		end
	else
		if (not IsInGroup(LE_PARTY_CATEGORY_HOME)) or (not IsInRaid(LE_PARTY_CATEGORY_HOME)) then
			SendAddonMessage("DuffedUI", Version, "INSTANCE_CHAT")
		elseif LE_PARTY_CATEGORY_HOME then
			SendAddonMessage("DuffedUI", Version, "RAID")
		elseif LE_PARTY_CATEGORY_HOME then
			SendAddonMessage("DuffedUI", Version, "PARTY")
		elseif IsInGuild() then
			SendAddonMessage("DuffedUI", Version, "GUILD")
		end
	end
end

local DuffedUIVersionOnLogon = CreateFrame("Frame")
DuffedUIVersionOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
DuffedUIVersionOnLogon:RegisterEvent("GROUP_ROSTER_UPDATE")
DuffedUIVersionOnLogon:RegisterEvent("CHAT_MSG_ADDON")
DuffedUIVersionOnLogon:SetScript("OnEvent", CheckCurrentDuffedUIVersion)

RegisterAddonMessagePrefix("DuffedUI")]]--