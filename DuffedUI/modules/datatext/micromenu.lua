local D, C, L, G = unpack(select(2, ...)) 
-----------------------------------------
-- DuffedUI Micro Menu
--
-- By: Rian Quinn
-- Date: 12-17-2010
--
-- Notes: This datatext is designed to
--        show the same micromenu that
--        is shown when you use the
--        middle mouse key on the mini
--        map.
-----------------------------------------

if C["datatext"].micromenu and C["datatext"].micromenu > 0 then
	local Stat = CreateFrame("Frame", "DuffedUIStatMicroMenu")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat.Option = C["datatext"].micromenu
	Stat.Color1 = D.RGBToHex(unpack(C["media"].datatextcolor1))
	Stat.Color2 = D.RGBToHex(unpack(C["media"].datatextcolor2))
	G.DataText.MicroMenu = Stat

	local Text  = Stat:CreateFontString("DuffedUIStatMicroMenuText", "OVERLAY")
	Text:SetFont(C["media"].font, C["datatext"].fontsize)
	D.DataTextPosition(C["datatext"].micromenu, Text)
	G.DataText.MicroMenu.Text = Text

	local function OnEvent(self, event, ...)
		Text:SetText(Stat.Color2..MAINMENU_BUTTON.."|r")
		self:SetAllPoints(Text)
	end

	local function OpenMenu()
		if not DuffedUIMicroButtonsDropDown then return end
		EasyMenu(D.MicroMenu, DuffedUIMicroButtonsDropDown, "cursor", 0, 0, "MENU", 2)
	end

	Stat:RegisterEvent("PLAYER_LOGIN")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnMouseDown", function() OpenMenu() end)
end