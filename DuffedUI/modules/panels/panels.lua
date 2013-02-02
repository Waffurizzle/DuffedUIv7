local D, C, L, G = unpack(select(2, ...)) 

local DuffedUIBar1 = CreateFrame("Frame", "DuffedUIBar1", UIParent, "SecureHandlerStateTemplate")
DuffedUIBar1:SetTemplate("Transparent")
if C["actionbar"].layout ~= 1 then
	DuffedUIBar1:SetSize((D.buttonsize * 12) + (D.buttonspacing * 13), (D.buttonsize * 2) + (D.buttonspacing * 3))
	DuffedUIBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 70)
else
	if D.lowversion then
		DuffedUIBar1:SetSize((D.buttonsize * 12) + (D.buttonspacing * 13), (D.buttonsize * 2) + (D.buttonspacing * 3))
		DuffedUIBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 3)
	else
		DuffedUIBar1:SetSize((D.buttonsize * 24) + (D.buttonspacing * 25), (D.buttonsize * 1) + (D.buttonspacing * 2))
		DuffedUIBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 26)
	end
end
DuffedUIBar1:SetFrameStrata("BACKGROUND")
DuffedUIBar1:SetFrameLevel(1)
DuffedUIBar1:CreateShadow("Default")
G.ActionBars.Bar1 = DuffedUIBar1

local DuffedUIBar2 = CreateFrame("Frame", "DuffedUIBar2", UIParent, "SecureHandlerStateTemplate")
DuffedUIBar2:SetTemplate("Transparent")
if C["actionbar"].layout ~= 1 then
	DuffedUIBar2:Point("BOTTOMRIGHT", DuffedUIBar1, "BOTTOMLEFT", -3, 0)
	DuffedUIBar2:SetSize((D.buttonsize * 3) + (D.buttonspacing * 4), (D.buttonsize * 2) + (D.buttonspacing * 3))
else
	if C["misc"].exp_rep == true and D.lowversion then
		DuffedUIBar2:Point("BOTTOM", DuffedUIBar1, "TOP", 0, 27)
	else
		DuffedUIBar2:Point("BOTTOM", DuffedUIBar1, "TOP", 0, 3)
	end
	DuffedUIBar2:SetSize((D.buttonsize * 12) + (D.buttonspacing * 13), (D.buttonsize * 1) + (D.buttonspacing * 2))
end
DuffedUIBar2:SetFrameStrata("BACKGROUND")
DuffedUIBar2:SetFrameLevel(3)
DuffedUIBar2:CreateShadow("Default")
G.ActionBars.Bar2 = DuffedUIBar2

local DuffedUIBar3 = CreateFrame("Frame", "DuffedUIBar3", UIParent, "SecureHandlerStateTemplate")
DuffedUIBar3:SetTemplate("Transparent")
DuffedUIBar3:Point("RIGHT", UIParent, "RIGHT", -13, -14)
DuffedUIBar3:SetSize((D.buttonsize * 2) + (D.buttonspacing * 3), (D.buttonsize * 12) + (D.buttonspacing * 13))
DuffedUIBar3:SetFrameStrata("BACKGROUND")
DuffedUIBar3:SetFrameLevel(3)
DuffedUIBar3:CreateShadow("Default")
G.ActionBars.Bar3 = DuffedUIBar3

if C["actionbar"].layout == 2 then
	local DuffedUIBar4 = CreateFrame("Frame", "DuffedUIBar4", UIParent, "SecureHandlerStateTemplate")
	DuffedUIBar4:Point("BOTTOMLEFT", DuffedUIBar1, "BOTTOMRIGHT", 3, 0)
	DuffedUIBar4:SetSize((D.buttonsize * 3) + (D.buttonspacing * 4), (D.buttonsize * 2) + (D.buttonspacing * 3))
	DuffedUIBar4:SetTemplate("Transparent")
	DuffedUIBar4:SetFrameStrata("BACKGROUND")
	DuffedUIBar4:SetFrameLevel(2)
	DuffedUIBar4:CreateShadow("Default")
end

local petbg = CreateFrame("Frame", "DuffedUIPetBar", UIParent, "SecureHandlerStateTemplate")
petbg:SetTemplate("Transparent")
if C["actionbar"].petbarhorizontal ~= true then
	petbg:SetSize(D.petbuttonsize + (D.petbuttonspacing * 2), (D.petbuttonsize * 10) + (D.petbuttonspacing * 11))
	petbg:SetPoint("RIGHT", DuffedUIBar3, "LEFT", -6, 0)
else
	petbg:SetSize((D.petbuttonsize * 10) + (D.petbuttonspacing * 11), D.petbuttonsize + (D.petbuttonspacing * 2))
	petbg:SetPoint("BOTTOM", DuffedUIBar1, "TOP", 0, 3)
end
G.ActionBars.Pet = petbg

local ltpetbg1 = CreateFrame("Frame", "DuffedUILineToPetActionBarBackground", petbg)
ltpetbg1:SetTemplate("Transparent")
ltpetbg1:Size(10, 265)
ltpetbg1:Point("LEFT", petbg, "RIGHT", 0, 0)
ltpetbg1:SetParent(petbg)
ltpetbg1:SetFrameStrata("BACKGROUND")
ltpetbg1:SetFrameLevel(0)
if C["actionbar"].petbarhorizontal or C["actionbar"].petbaralwaysvisible then ltpetbg1:Hide() end
G.ActionBars.Pet.BackgroundLink = ltpetbg1

-- INFO LEFT (FOR STATS)
local ileft = CreateFrame("Frame", "DuffedUIInfoLeft", UIParent)
ileft:SetTemplate("Default")
if C["actionbar"].layout ~= 1 or D.lowversion then
	ileft:Size(D.Scale(D.InfoLeftRightWidth - 9), 19)
	ileft:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5, 3)
else
	ileft:Size(D.Scale(D.InfoLeftRightWidth - 25), 19)
	ileft:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", -12, 3)
end
ileft:SetFrameLevel(2)
ileft:SetFrameStrata("BACKGROUND")
ileft:CreateShadow("Default")
--ileft:SetParent(DuffedUIPetBattleHider)
G.Panels.DataTextLeft = ileft

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "DuffedUIInfoRight", UIParent)
iright:SetTemplate("Default")
if C["actionbar"].layout ~= 1 or D.lowversion then
	iright:Size(D.Scale(D.InfoLeftRightWidth + 12), 19)
	iright:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 3)
else
	iright:Size(D.Scale(D.InfoLeftRightWidth - 25), 19)
	iright:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 12, 3)
end
iright:SetFrameLevel(2)
iright:SetFrameStrata("BACKGROUND")
iright:CreateShadow("Default")
--iright:SetParent(DuffedUIPetBattleHider)
G.Panels.DataTextRight = iright

if C["actionbar"].buttonsize > 26 and C["actionbar"].layout == 1 and not D.lowversion then
	-- HORIZONTAL LINE LEFT
	local ltoabl = CreateFrame("Frame", "DuffedUILineToABLeft", DuffedUIBar1)
	ltoabl:SetTemplate("Default")
	ltoabl:Size(10, 2)
	ltoabl:SetPoint("RIGHT", ileft, "LEFT", 0, 0)

	-- HORIZONTAL LINE RIGHT
	local ltoabr = CreateFrame("Frame", "DuffedUILineToABRight", DuffedUIBar1)
	ltoabr:SetTemplate("Default")
	ltoabr:Size(10, 2)
	ltoabr:SetPoint("LEFT", iright, "RIGHT", 0, 0)

	-- LEFT VERTICAL LINE
	local ileftlv = CreateFrame("Frame", "DuffedUIInfoLeftLineVertical", DuffedUIBar1)
	ileftlv:SetTemplate("Default")
	ileftlv:Size(2, 13)
	ileftlv:SetPoint("BOTTOM", ltoabl, "LEFT", 0, -1)

	-- RIGHT VERTICAL LINE
	local irightlv = CreateFrame("Frame", "DuffedUIInfoRightLineVertical", DuffedUIBar1)
	irightlv:SetTemplate("Default")
	irightlv:Size(2, 13)
	irightlv:SetPoint("BOTTOM", ltoabr, "RIGHT", 0, -1)
end

if C["chat"].background then
	-- CHAT BG LEFT
	local chatleftbg = CreateFrame("Frame", "DuffedUIChatBackgroundLeft", UIParent)
	chatleftbg:SetTemplate("Transparent")
	chatleftbg:Size(D.InfoLeftRightWidth + 12, 149)
	if C["actionbar"].layout ~= 1 or D.lowversion then chatleftbg:Point("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5, 24) else chatleftbg:Point("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5, 5) end
	chatleftbg:SetFrameLevel(1)
	chatleftbg:CreateShadow("Default")
	G.Panels.LeftChatBackground = chatleftbg

	-- CHAT BG RIGHT
	local chatrightbg = CreateFrame("Frame", "DuffedUIChatBackgroundRight", UIParent)
	chatrightbg:SetTemplate("Transparent")
	chatrightbg:Size(D.InfoLeftRightWidth + 12, 149)
	if C["actionbar"].layout ~= 1 or D.lowversion then chatrightbg:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 24) else chatrightbg:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 5) end
	chatrightbg:SetFrameLevel(1)
	chatrightbg:CreateShadow("Default")
	G.Panels.RightChatBackground = chatrightbg
	
	-- LEFT TAB PANEL
	local tabsbgleft = CreateFrame("Frame", "DuffedUITabsLeftBackground", UIParent)
	tabsbgleft:SetTemplate()
	tabsbgleft:Size((D.InfoLeftRightWidth - 40), 20)
	tabsbgleft:Point("TOPLEFT", chatleftbg, "TOPLEFT", 4, -4)
	tabsbgleft:SetFrameLevel(2)
	tabsbgleft:SetFrameStrata("BACKGROUND")
	G.Panels.LeftChatTabsBackground = tabsbgleft
		
	-- RIGHT TAB PANEL
	local tabsbgright = CreateFrame("Frame", "DuffedUITabsRightBackground", UIParent)
	tabsbgright:SetTemplate()
	tabsbgright:Size((D.InfoLeftRightWidth - 20), 20)
	tabsbgright:Point("TOPLEFT", chatrightbg, "TOPLEFT", 4, -4)
	tabsbgright:SetFrameLevel(2)
	tabsbgright:SetFrameStrata("BACKGROUND")
	G.Panels.RightChatTabsBackground = tabsbgright
end

local chatmenu = CreateFrame("Frame", "DuffedUIChatMenu", UIParent)
chatmenu:SetTemplate("Default")
chatmenu:Size(20)
if C["chat"].background then chatmenu:Point("LEFT", DuffedUITabsLeftBackground, "RIGHT", 2, 0) else chatmenu:Point("TOPLEFT", ChatFrame1, "TOPLEFT", 2, 0) end
chatmenu:SetFrameLevel(3)
chatmenu.text = D.SetFontString(chatmenu, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
chatmenu.text:SetPoint("CENTER", 1, -1)
chatmenu.text:SetText(D.panelcolor .. "E")
chatmenu:SetScript("OnMouseDown", function(self, btn)
	if btn == "LeftButton" then	
		ToggleFrame(ChatMenu)
	end
end)

if DuffedUIMinimap then
	local minimapstatsleft = CreateFrame("Frame", "DuffedUIMinimapStatsLeft", DuffedUIMinimap)
	minimapstatsleft:SetTemplate()
	minimapstatsleft:Size(((DuffedUIMinimap:GetWidth() + 4) / 2) -3, 19)
	minimapstatsleft:Point("TOPLEFT", DuffedUIMinimap, "BOTTOMLEFT", 0, -2)
	minimapstatsleft:CreateShadow()
	G.Panels.DataTextMinimapLeft = minimapstatsleft

	local minimapstatsright = CreateFrame("Frame", "DuffedUIMinimapStatsRight", DuffedUIMinimap)
	minimapstatsright:SetTemplate()
	minimapstatsright:Size(((DuffedUIMinimap:GetWidth() + 4) / 2) -3, 19)
	minimapstatsright:Point("TOPRIGHT", DuffedUIMinimap, "BOTTOMRIGHT", 0, -2)
	minimapstatsright:CreateShadow()
	G.Panels.DataTextMinimapRight = minimapstatsright
end

--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "DuffedUIInfoLeftBattleGround", UIParent)
	bgframe:SetTemplate()
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("LOW")
	bgframe:SetFrameLevel(0)
	bgframe:EnableMouse(true)
	G.Panels.BattlegroundDataText = bgframe
end

local bnet = CreateFrame("Frame", "DuffedUIBnetHolder", UIParent)
bnet:SetTemplate("Default")
bnet:Size(BNToastFrame:GetWidth(), BNToastFrame:GetHeight())
bnet:Point("TOPLEFT", UIParent, "TOPLEFT", 3, -3)
bnet:SetClampedToScreen(true)
bnet:SetMovable(true)
bnet:SetBackdropBorderColor(1, 0, 0)
bnet.text = D.SetFontString(bnet, C["media"].font, 12)
bnet.text:SetPoint("CENTER")
bnet.text:SetText("Move BnetFrame")
bnet:Hide()
tinsert(D.AllowFrameMoving, bnet)