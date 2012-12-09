local D, C, L, G = unpack(select(2, ...))

-- main frame
local DuffedUIMainFrame = CreateFrame("Frame", "DuffedUIMainFrame", UIParent)
DuffedUIMainFrame:SetSize(650, 350)
DuffedUIMainFrame:SetPoint("CENTER")
DuffedUIMainFrame:SetTemplate("Transparent")
DuffedUIMainFrame:CreateShadow("Default")
DuffedUIMainFrame:Hide()
DuffedUIMainFrame:SetFrameLevel(10)
DuffedUIMainFrame:SetFrameStrata("BACKGROUND")

local DuffedUIMainFrameIconTopLeft = CreateFrame("Frame", "DuffedTest", DuffedUIMainFrame)
DuffedUIMainFrameIconTopLeft:Size(44, 44)
DuffedUIMainFrameIconTopLeft:SetPoint("BOTTOMRIGHT", DuffedUIMainFrame, "TOPRIGHT", 0, 3)
DuffedUIMainFrameIconTopLeft:SetFrameStrata("HIGH")
DuffedUIMainFrameIconTopLeft:CreateShadow("Default")

DuffedUIMainFrameIconTopLeft.Background = DuffedUIMainFrameIconTopLeft:CreateTexture(nil, "ARTWORK")
DuffedUIMainFrameIconTopLeft.Background:Point("TOPLEFT", 2, -2)
DuffedUIMainFrameIconTopLeft.Background:Point("BOTTOMRIGHT", -2, 2)
DuffedUIMainFrameIconTopLeft.Background:SetTexture(C["media"].duffed)

local DuffedUIMainFrameIconTopRight = CreateFrame("Frame", "DuffedTest", DuffedUIMainFrame)
DuffedUIMainFrameIconTopRight:Size(44, 44)
DuffedUIMainFrameIconTopRight:SetPoint("BOTTOMLEFT", DuffedUIMainFrame, "TOPLEFT", 0, 3)
DuffedUIMainFrameIconTopRight:SetFrameStrata("HIGH")
DuffedUIMainFrameIconTopRight:CreateShadow("Default")

DuffedUIMainFrameIconTopRight.Background = DuffedUIMainFrameIconTopRight:CreateTexture(nil, "ARTWORK")
DuffedUIMainFrameIconTopRight.Background:Point("TOPLEFT", 2, -2)
DuffedUIMainFrameIconTopRight.Background:Point("BOTTOMRIGHT", -2, 2)
DuffedUIMainFrameIconTopRight.Background:SetTexture(C["media"].duffed)

local DuffedUIMainFrameTITLE = CreateFrame("Frame", "TukuiInstallTITLE", DuffedUIMainFrame)
DuffedUIMainFrameTITLE:Size(DuffedUIMainFrame:GetWidth() - 92, 30)
DuffedUIMainFrameTITLE:SetPoint("BOTTOM", DuffedUIMainFrame, "TOP", 0, 3)
DuffedUIMainFrameTITLE:SetTemplate("Transparent")
DuffedUIMainFrameTITLE:SetFrameStrata("HIGH")
DuffedUIMainFrameTITLE:CreateShadow("Default")

local DuffedUIMainFrameTITLEText = DuffedUIMainFrameTITLE:CreateFontString(nil, "OVERLAY")
DuffedUIMainFrameTITLEText:SetFont(C["media"].font, 16, "THINOUTLINE")
DuffedUIMainFrameTITLEText:SetPoint("CENTER", DuffedUIMainFrameTITLE, 0, 0)
DuffedUIMainFrameTITLEText:SetText(L.Duffed_HELP_HEADER.." "..GetAddOnMetadata("DuffedUI", "Version"))

-- main frame - navigation
local DuffedUIMainFrameNavigation = CreateFrame("Frame", "DuffedUIMainFrameNavigation", DuffedUIMainFrame)
DuffedUIMainFrameNavigation:SetSize(180, 342)
DuffedUIMainFrameNavigation:SetPoint("LEFT", 4, 0)
DuffedUIMainFrameNavigation:SetTemplate("Transparent")

-- main frame - CONTENT
local DuffedUIMainFrameContent = CreateFrame("Frame", "DuffedUIMainFrameContent", DuffedUIMainFrame)
DuffedUIMainFrameContent:SetSize(458, 342)
DuffedUIMainFrameContent:SetPoint("RIGHT", -4, 0)
DuffedUIMainFrameContent:SetTemplate("Transparent")

local DuffedUIMainFrameContentScrollFrame = CreateFrame("ScrollFrame", "DuffedUIMainFrameContentScrollFrame", DuffedUIMainFrameContent, "UIPanelScrollFrameTemplate")
DuffedUIMainFrameContentScrollFrame:SetPoint("TOPLEFT", DuffedUIMainFrameContent, "TOPLEFT", 10, -10)
DuffedUIMainFrameContentScrollFrame:SetPoint("BOTTOMRIGHT", DuffedUIMainFrameContent, "BOTTOMRIGHT", -30, 10)
DuffedUIMainFrameContentScrollFrameScrollBar:SkinScrollBar()

local DuffedUIMainFrameContentScrollFrameBackground = CreateFrame("Frame", "DuffedUIMainFrameContentScrollFrameBackground", DuffedUIMainFrameContentScrollFrame)
DuffedUIMainFrameContentScrollFrameBackground:SetPoint("TOPLEFT")
DuffedUIMainFrameContentScrollFrameBackground:SetWidth(DuffedUIMainFrameContentScrollFrame:GetWidth())
DuffedUIMainFrameContentScrollFrameBackground:SetHeight(DuffedUIMainFrameContentScrollFrame:GetHeight())
DuffedUIMainFrameContentScrollFrame:SetScrollChild(DuffedUIMainFrameContentScrollFrameBackground)
	
local DuffedUIMainFrameContentTitle = DuffedUIMainFrameContentScrollFrameBackground:CreateFontString(nil, "OVERLAY")
DuffedUIMainFrameContentTitle:SetFont(C["media"].font, 14, "THINOUTLINE")
DuffedUIMainFrameContentTitle:SetPoint("TOP", DuffedUIMainFrameContentScrollFrameBackground, "TOP", 0, -10)

local DuffedUIMainFrameContentText1 = DuffedUIMainFrameContentScrollFrameBackground:CreateFontString(nil, "OVERLAY")
DuffedUIMainFrameContentText1:SetJustifyH("LEFT")
DuffedUIMainFrameContentText1:SetFont(C["media"].font, 11)
DuffedUIMainFrameContentText1:SetWidth(DuffedUIMainFrameContentScrollFrameBackground:GetWidth() - 20)
DuffedUIMainFrameContentText1:SetPoint("TOPLEFT", DuffedUIMainFrameContentScrollFrameBackground, "TOPLEFT", 20, -45)

local DuffedUIMainFrameContentText2 = DuffedUIMainFrameContentScrollFrameBackground:CreateFontString(nil, "OVERLAY")
DuffedUIMainFrameContentText2:SetJustifyH("LEFT")
DuffedUIMainFrameContentText2:SetFont(C["media"].font, 11)
DuffedUIMainFrameContentText2:SetWidth(DuffedUIMainFrameContentScrollFrameBackground:GetWidth() - 30)
DuffedUIMainFrameContentText2:SetPoint("TOPLEFT", DuffedUIMainFrameContentText1, "BOTTOMLEFT", 0, -20)

local DuffedUIMainFrameContentText3 = DuffedUIMainFrameContentScrollFrameBackground:CreateFontString(nil, "OVERLAY")
DuffedUIMainFrameContentText3:SetJustifyH("LEFT")
DuffedUIMainFrameContentText3:SetFont(C["media"].font, 11)
DuffedUIMainFrameContentText3:SetWidth(DuffedUIMainFrameContentScrollFrameBackground:GetWidth() - 30)
DuffedUIMainFrameContentText3:SetPoint("TOPLEFT", DuffedUIMainFrameContentText2, "BOTTOMLEFT", 0, -20)

local DuffedUIMainFrameContentText4 = DuffedUIMainFrameContentScrollFrameBackground:CreateFontString(nil, "OVERLAY")
DuffedUIMainFrameContentText4:SetJustifyH("LEFT")
DuffedUIMainFrameContentText4:SetFont(C["media"].font, 11)
DuffedUIMainFrameContentText4:SetWidth(DuffedUIMainFrameContentScrollFrameBackground:GetWidth() - 30)
DuffedUIMainFrameContentText4:SetPoint("TOPLEFT", DuffedUIMainFrameContentText3, "BOTTOMLEFT", 0, -20)

-- main frame - navigation - BUTTONs
local DuffedUIMainFrameNavigationButtonAttributes = {
	[1] = {"/dhelp 1"},
	[2] = {"/dhelp 2"},
	[3] = {"/dhelp 3"},
	[4] = {"/dhelp 4"},
	[5] = {"/dhelp 5"},
	[6] = {"/dhelp 6"},
	[7] = {"/dhelp 7"},
	[8] = {"/dhelp 8"},
	[9] = {"/dhelp 9"},
}

local DuffedUIMainFrameNavigationButtonTexts = {
	[1] = {D.panelcolor..L.Duffed_HELP_BUTTON1},
	[2] = {D.panelcolor..L.Duffed_HELP_BUTTON2},
	[3] = {D.panelcolor..L.Duffed_HELP_BUTTON3},
	[4] = {D.panelcolor..L.Duffed_HELP_BUTTON4},
	[5] = {D.panelcolor..L.Duffed_HELP_BUTTON5},
	[6] = {D.panelcolor..L.Duffed_HELP_BUTTON6},
	[7] = {D.panelcolor..L.Duffed_HELP_BUTTON7},
	[8] = {D.panelcolor..L.Duffed_HELP_BUTTON8},
	[9] = {D.panelcolor..L.Duffed_HELP_BUTTON9},
}

local DuffedUIMainFrameNavigationButton = CreateFrame("Button", "DuffedUIMainFrameNavigationButton", DuffedUIMainFrameNavigation)
for i = 1, 9 do
	DuffedUIMainFrameNavigationButton[i] = CreateFrame("Button", "DuffedUIMainFrameNavigationButton"..i, DuffedUIMainFrameNavigation, "SecureActionButtonTemplate")
	DuffedUIMainFrameNavigationButton[i]:Size(DuffedUIMainFrameNavigation:GetWidth() - 8, 24)
	DuffedUIMainFrameNavigationButton[i]:SetPoint("TOP", DuffedUIMainFrameNavigation, "TOP", 0, -4)
	DuffedUIMainFrameNavigationButton[i]:SetTemplate("Default")
	DuffedUIMainFrameNavigationButton[i].Text = D.SetFontString(DuffedUIMainFrameNavigationButton[i], C["media"].font, 11, "THINOUTLINE")
	DuffedUIMainFrameNavigationButton[i]:SetFrameLevel(DuffedUIMainFrameNavigation:GetFrameLevel() + 1)
	DuffedUIMainFrameNavigationButton[i].Text:Point("CENTER", DuffedUIMainFrameNavigationButton[i], "CENTER", 0, 1)
	DuffedUIMainFrameNavigationButton[i].Text:SetText(unpack(DuffedUIMainFrameNavigationButtonTexts[i]))

	if i == 1 then
		DuffedUIMainFrameNavigationButton[i]:Point("TOP", DuffedUIMainFrameNavigation, "TOP", 0, -5)
	else
		DuffedUIMainFrameNavigationButton[i]:Point("TOP", DuffedUIMainFrameNavigationButton[i - 1], "BOTTOM", 0, -3)
	end
	DuffedUIMainFrameNavigationButton[i]:SetAttribute("type", "macro")
	DuffedUIMainFrameNavigationButton[i]:SetAttribute("macrotext", unpack(DuffedUIMainFrameNavigationButtonAttributes[i]))
	DuffedUIMainFrameNavigationButton[i]:CreateOverlay(DuffedUIMainFrameNavigationButton[i])
	DuffedUIMainFrameNavigationButton[i]:HookScript("OnEnter", D.SetModifiedBackdrop)
	DuffedUIMainFrameNavigationButton[i]:HookScript("OnLeave", D.SetOriginalBackdrop)
end

---------------------------------------------------------------------------------------------
-- functions
---------------------------------------------------------------------------------------------
local dhelpcontentclose = CreateFrame("BUTTON", "DuffedUIMainFrameContentCloseBUTTON", DuffedUIMainFrameContentScrollFrameBackground, "UIPanelCloseButton")
dhelpcontentclose:SetPoint("TOPRIGHT", DuffedUIMainFrameContentScrollFrameBackground, "TOPRIGHT")
dhelpcontentclose:SkinCloseButton()
dhelpcontentclose:SetScript("OnClick", function()
	DuffedUIMainFrame:Hide()
end)

local dhelpcontent = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT0_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT0_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT0_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT0_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT0_LINE4)
end

local dhelp9content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT9_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT9_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT9_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT9_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT9_LINE4)
end

local dhelp8content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT8_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT8_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT8_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT8_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT8_LINE4)
end

local dhelp7content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT7_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT7_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT7_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT7_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT7_LINE4)
end

local dhelp6content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT6_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT6_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT6_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT6_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT6_LINE4)
end

local dhelp5content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT5_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT5_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT5_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT5_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT5_LINE4)
end

local dhelp4content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT4_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT4_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT4_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT4_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT4_LINE4)
end

local dhelp3content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT3_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT3_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT3_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT3_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT3_LINE4)
end

local dhelp2content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT2_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT2_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT2_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT2_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT2_LINE4)
end

local dhelp1content = function()
	DuffedUIMainFrameContentTitle:SetText(L.Duffed_HELP_CONTENT1_TITLE)
	DuffedUIMainFrameContentText1:SetText(L.Duffed_HELP_CONTENT1_LINE1)
	DuffedUIMainFrameContentText2:SetText(L.Duffed_HELP_CONTENT1_LINE2)
	DuffedUIMainFrameContentText3:SetText(L.Duffed_HELP_CONTENT1_LINE3)
	DuffedUIMainFrameContentText4:SetText(L.Duffed_HELP_CONTENT1_LINE4)
end

-- slash command
local dhelp = DuffedUIHelp or function() end
DuffedUIHelp = function(msg)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end

	if msg == "1" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp1content()
	elseif msg == "2" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp2content()
	elseif msg == "3" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp3content()
	elseif msg == "4" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp4content()
	elseif msg == "5" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp5content()
	elseif msg == "6" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp6content()
	elseif msg == "7" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp7content()
	elseif msg == "8" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp8content()
	elseif msg == "9" then
		if not DuffedUIMainFrame:IsVisible() then return end
		dhelp9content()
	else
		if DuffedUIMainFrame:IsVisible() then
			DuffedUIMainFrame:Hide()
		else
			DuffedUIMainFrame:Show()
			dhelpcontent()
		end
	end
end

SlashCmdList.DuffedUIHelp = DuffedUIHelp
SLASH_DuffedUIHelp1 = "/dhelp"