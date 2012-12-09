local D, C, L, G = unpack(select(2, ...))

if C["misc"].loc ~= false then return end

f=CreateFrame("Frame")
f:RegisterEvent("LOSS_OF_CONTROL_ADDED")
f:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
f:SetScript("OnEvent",function()
	for b in pairs(ActionBarActionEventsFrame.frames) do
		b.cooldown:SetLossOfControlCooldown(0,0)
	end
end)