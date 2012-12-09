local D, C, L, G = unpack(select(2, ...))

if C["misc"].chatalert ~= true then return end

local DuffedChatAlert = CreateFrame("Frame")
DuffedChatAlert:RegisterEvent("CHAT_MSG_GUILD")
DuffedChatAlert:RegisterEvent("CHAT_MSG_RAID")
DuffedChatAlert:RegisterEvent("CHAT_MSG_RAID_LEADER")

DuffedChatAlert:SetScript("OnEvent", function(event, msg, sender)
	sender = strlower(sender)
	v = UnitName("player")

	if strfind(sender, strlower(v)) then
		PlaySoundFile("Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactColossalWaterA.wav", "MASTER")
		return
	end
end)