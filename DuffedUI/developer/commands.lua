-- enable lua error by command
function SlashCmdList.LUAERROR(msg, editbox)
	if (msg == 'on') then
		SetCVar("scriptErrors", 1)
		-- because sometime we need to /rl to show an error on login.
		ReloadUI()
	elseif (msg == 'off') then
		SetCVar("scriptErrors", 0)
	else
		print("/luaerror on - /luaerror off")
	end
end
SLASH_LUAERROR1 = '/luaerror'

local TestUI = function(msg)
	if not DuffedUI[2].unitframes.enable then return end
	if msg == "" then msg = "all" end
	
    if msg == "all" or msg == "arena" or msg == "a" then
		for i = 1, 3 do
			_G["DuffedUIArena"..i]:Show(); _G["DuffedUIArena"..i].Hide = function() end; _G["DuffedUIArena"..i].unit = "player"
			_G["DuffedUIArena"..i].Trinket.Icon:SetTexture("Interface\\Icons\\INV_Jewelry_Necklace_37")
		end
	end
	
    if msg == "all" or msg == "boss" or msg == "b" then
		for i = 1, 3 do
			_G["DuffedUIBoss"..i]:Show(); _G["DuffedUIBoss"..i].Hide = function() end; _G["DuffedUIBoss"..i].unit = "player"
		end
	end
	
	if msg == "all" or msg == "pet" or msg == "p" then
		DuffedUIPet:Show(); DuffedUIPet.Hide = function() end; DuffedUIPet.unit = "player"
	end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = "/testui"