local D, C, L, G = unpack(select(2, ...))

if not C["actionbar"].enable == true then
	DuffedUIPetBar:Hide()
	return
end

---------------------------------------------------------------------------
-- Manage all others stuff for actionbars
---------------------------------------------------------------------------

D.CreatePopup["DUFFEDUI_FIX_AB"] = {
	question = L.popup_fix_ab,
	answer1 = ACCEPT,
	answer2 = CANCEL,
	function1 = ReloadUI,
}

local DuffedUIOnLogon = CreateFrame("Frame")
DuffedUIOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
DuffedUIOnLogon:SetScript("OnEvent", function(self, event)	
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	-- look if our 4 bars are enabled because some people disable them with others UI 
	-- even if DuffedUI have been already installed and they don't know how to restore them.
	local installed = DuffedUIDataPerChar.install
	if installed then
		local b1, b2, b3, b4 = GetActionBarToggles()
		if (not b1 or not b2 or not b3 or not b4) then
			SetActionBarToggles(1, 1, 1, 1)
			D.ShowPopup("DUFFEDUI_FIX_AB")
		end
	end
	
	for i = 1, 12 do
		local button = _G[format("ActionButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarRightButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("MultiBarBottomRightButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarLeftButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarBottomLeftButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
	end
end)
G.ActionBars.EnterWorld = DuffedUIOnLogon