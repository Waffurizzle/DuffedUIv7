local D, C, L, G = unpack(select(2, ...)) 

-- enable or disable an addon via command
SlashCmdList.DISABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then DisableAddOn(addon) ReloadUI() else print("|cffff0000Error, Addon not found.|r") end end
SLASH_DISABLE_ADDON1 = "/disable"
SlashCmdList.ENABLE_ADDON = function(addon) local _, _, _, _, _, reason, _ = GetAddOnInfo(addon) if reason ~= "MISSING" then EnableAddOn(addon) LoadAddOn(addon) ReloadUI() else print("|cffff0000Error, Addon not found.|r") end end
SLASH_ENABLE_ADDON1 = "/enable"

-- ready check shortcut
SlashCmdList.RCSLASH = DoReadyCheck
SLASH_RCSLASH1 = "/rc"

-- switch to heal layout via a command
SLASH_DUFFEDUIHEAL1 = "/heal"
SlashCmdList.DUFFEDUIHEAL = function()
	DisableAddOn("DuffedUI_Raid")
	EnableAddOn("DuffedUI_Raid_Healing")
	ReloadUI()
end

-- switch to dps layout via a command
SLASH_DUFFEDUIDPS1 = "/dps"
SlashCmdList.DUFFEDUIDPS = function()
	DisableAddOn("DuffedUI_Raid_Healing")
	EnableAddOn("DuffedUI_Raid")
	ReloadUI()
end

-- disband party/raid
local function DisbandRaidGroup()
	if InCombatLockdown() then return end
	
	if UnitInRaid("player") then
		SendChatMessage(ERR_GROUP_DISBANDED, "RAID")
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= D.myname then
				UninviteUnit(name)
			end
		end
	else
		SendChatMessage(ERR_GROUP_DISBANDED, "PARTY")
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if GetNumGroupMembers(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end

D.CreatePopup["DUFFEDUIDISBAND_RAID"] = {
	question = L.disband,
	answer1 = ACCEPT,
	answer2 = CANCEL,
	function1 = DisbandRaidGroup,
}

SlashCmdList["GROUPDISBAND"] = function()
	local instanceType = select(2, IsInInstance())

	-- don't allow disband in bg's, arena, tol barad, etc
	if instanceType == "pvp" or instanceType == "arena" then
		return
	end
	
	-- only allow disband group if leader or assistant
	if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
		D.ShowPopup("DUFFEDUIDISBAND_RAID")
	end
end
SLASH_GROUPDISBAND1 = '/gd'
SLASH_GROUPDISBAND2 = '/rd'

-- Leave party chat command
SlashCmdList["LEAVEPARTY"] = function()
	LeaveParty()
end
SLASH_LEAVEPARTY1 = '/leaveparty'