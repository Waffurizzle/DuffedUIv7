﻿------------------------------------------------------------------------
-- Install Script
------------------------------------------------------------------------

local D, C, L, G = unpack(select(2, ...))

D.ChatSetup = function()
	-- setting chat frames if using DuffedUI chats.					
	FCF_ResetChatWindows()
	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)
	FCF_OpenNewWindow(L.chat_general)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_DockFrame(ChatFrame3)

	FCF_OpenNewWindow(LOOT)
	FCF_UnDockFrame(ChatFrame4)
	FCF_SetLocked(ChatFrame4, 1)
	ChatFrame4:Show()

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		local id = frame:GetID()

		-- set default tukui font size
		FCF_SetChatWindowFontSize(nil, frame, 12)
		
		-- set the size of chat frames
		frame:Size(D.InfoLeftRightWidth + 1, 114)
		
		-- tell wow that we are using new size
		SetChatWindowSavedDimensions(id, D.Scale(D.InfoLeftRightWidth + 1), D.Scale(114))
		
		-- save new default position and dimension
		FCF_SavePositionAndDimensions(frame)
		
		-- rename windows general and combat log
		if i == 1 then FCF_SetWindowName(frame, "G, S & W") end
		if i == 2 then FCF_SetWindowName(frame, "Log") end
		
		D.SetDefaultChatPosition(frame)
	end
	
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_RemoveChannel(ChatFrame1, L.chat_trade) -- erf, it seem we need to localize this now
	ChatFrame_RemoveChannel(ChatFrame1, L.chat_general) -- erf, it seem we need to localize this now
	ChatFrame_RemoveChannel(ChatFrame1, L.chat_defense) -- erf, it seem we need to localize this now
	ChatFrame_RemoveChannel(ChatFrame1, L.chat_recrutment) -- erf, it seem we need to localize this now
	ChatFrame_RemoveChannel(ChatFrame1, L.chat_lfg) -- erf, it seem we need to localize this now
	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
	ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
				
	-- Setup the spam chat frame
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddChannel(ChatFrame3, L.chat_trade) -- erf, it seem we need to localize this now
	ChatFrame_AddChannel(ChatFrame3, L.chat_general) -- erf, it seem we need to localize this now
	ChatFrame_AddChannel(ChatFrame3, L.chat_defense) -- erf, it seem we need to localize this now
	ChatFrame_AddChannel(ChatFrame3, L.chat_recrutment) -- erf, it seem we need to localize this now
	ChatFrame_AddChannel(ChatFrame3, L.chat_lfg) -- erf, it seem we need to localize this now
			
	-- Setup the right chat
	ChatFrame_RemoveAllMessageGroups(ChatFrame4)
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")
			
	-- enable classcolor automatically on login and on each character without doing /configure each time.
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
end

local function cvarsetup()
	SetCVar("buffDurations", 1)
	SetCVar("consolidateBuffs", 0)
	SetCVar("mapQuestDifficulty", 1)
	SetCVar("scriptErrors", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 8)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "im")
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("WhisperMode", "inline")
	SetCVar("BnWhisperMode", "inline")
	SetCVar("showTutorials", 0)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoQuestProgress", 1)
	SetCVar("UberTooltips", 1)
	SetCVar("removeChatDelay", 1)
	SetCVar("showVKeyCastbar", 1)
	SetCVar("bloatthreat", 0)
	SetCVar("bloattest", 0)
	SetCVar("showArenaEnemyFrames", 0)
	SetCVar("alwaysShowActionBars", 1)
	SetCVar("autoOpenLootHistory", 0)
	SetCVar("spamFilter", 0)
	SetCVar("violenceLevel", 5)
	SetCVar("gxApi", 1)
end

local OnLogon = CreateFrame("Frame")
OnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
OnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	print(L.welcome_1)
	print(L.welcome_2)
end)

local function positionsetup()
	-- reset saved variables on char
	DuffedUIDataPerChar = {}
	
	-- reset movable stuff into original position
	for i = 1, getn(D.AllowFrameMoving) do
		if D.AllowFrameMoving[i] then D.AllowFrameMoving[i]:SetUserPlaced(false) end
	end
end

local v = CreateFrame("Button", "DuffedUIVersionFrame", UIParent)
v:SetSize(300, 66)
v:SetPoint("CENTER")
v:SetTemplate("Transparent")
v:CreateShadow("Default")
v:FontString("text", C["media"].font, 20)
v:FontString("text2", C["media"].font, 12)
v.text:SetPoint("CENTER")
v.text:SetText("|cffC41F3BDuffedUI|r ".. D.version)
v.text2:SetPoint("BOTTOM", 0, 2)
v.text2:SetText("by |cffC41F3BMerith - liquidbase|r, website at |cffC41F3Bwww.tukui.org|r")
v:SetScript("OnClick", function()
	v:Hide()
end)
v:Hide()
G.Install.Version = v

local vicon = CreateFrame("Frame", "DuffedVersion", v)
vicon:Size(66, 66)
vicon:SetTemplate()
vicon:SetPoint("RIGHT", v, "LEFT", -2, 0)
vicon:SetFrameStrata("HIGH")
vicon:CreateShadow("Default")

vicon.bg = vicon:CreateTexture(nil, "ARTWORK")
vicon.bg:Point("TOPLEFT", 2, -2)
vicon.bg:Point("BOTTOMRIGHT", -2, 2)
vicon.bg:SetTexture(C["media"].duffed)

local f = CreateFrame("Frame", "DuffedUIInstallFrame", UIParent)
f:SetSize(400, 400)
f:SetPoint("CENTER")
f:SetTemplate("Transparent")
f:CreateShadow("Default")
f:Hide()
G.Install.Frame = f

local viconl = CreateFrame("Frame", "DuffedVersion", f)
viconl:SetTemplate()
viconl:Size(64, 64)
viconl:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", 0, 2)
viconl:SetFrameStrata("HIGH")
viconl:CreateShadow("Default")

viconl.bg = viconl:CreateTexture(nil, "ARTWORK")
viconl.bg:Point("TOPLEFT", 2, -2)
viconl.bg:Point("BOTTOMRIGHT", -2, 2)
viconl.bg:SetTexture(C["media"].duffed)

local viconr = CreateFrame("Frame", "DuffedVersion", f)
viconr:SetTemplate()
viconr:Size(64, 64)
viconr:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 2)
viconr:SetFrameStrata("HIGH")
viconr:CreateShadow("Default")

viconr.bg = viconr:CreateTexture(nil, "ARTWORK")
viconr.bg:Point("TOPLEFT", 2, -2)
viconr.bg:Point("BOTTOMRIGHT", -2, 2)
viconr.bg:SetTexture(C["media"].duffed)

local title = CreateFrame("Frame", "DuffedUIInstallTitle", f)
title:SetTemplate("Transparent")
title:Size(f:GetWidth() - 130, 30)
title:SetPoint("BOTTOM", f, "TOP", 0, 2)
title:SetFrameStrata("HIGH")
title:CreateShadow("Default")

local name = title:CreateFontString(nil, "OVERLAY")
name:SetFont( C["media"].font, 16)
name:SetPoint("CENTER", title, 0, 0)
name:SetText("|cffc41f3bDuffedUI|r " .. D.version)

local sb = CreateFrame("StatusBar", nil, f)
sb:SetStatusBarTexture(C["media"].normTex)
sb:SetPoint("BOTTOM", f, "BOTTOM", 0, 60)
sb:SetHeight(20)
sb:SetWidth(f:GetWidth() - 44)
sb:SetFrameStrata("HIGH")
sb:SetFrameLevel(6)
sb:Hide()
G.Install.StatusBar = sb

local sbd = CreateFrame("Frame", nil, sb)
sbd:SetTemplate("Default")
sbd:SetPoint("TOPLEFT", sb, -2, 2)
sbd:SetPoint("BOTTOMRIGHT", sb, 2, -2)
sbd:SetFrameStrata("HIGH")
sbd:SetFrameLevel(5)
G.Install.StatusBar.Backdrop = sdb

local header = f:CreateFontString(nil, "OVERLAY")
header:SetFont(C["media"].font, 16, "THINOUTLINE")
header:SetPoint("TOP", f, "TOP", 0, -20)
G.Install.Frame.Header = header

local text1 = f:CreateFontString(nil, "OVERLAY")
text1:SetJustifyH("LEFT")
text1:SetFont(C["media"].font, 12)
text1:SetWidth(f:GetWidth()-40)
text1:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -60)
G.Install.Frame.Text1 = G.Install.Frame

local text2 = f:CreateFontString(nil, "OVERLAY")
text2:SetJustifyH("LEFT")
text2:SetFont(C["media"].font, 12)
text2:SetWidth(f:GetWidth()-40)
text2:SetPoint("TOPLEFT", text1, "BOTTOMLEFT", 0, -20)
G.Install.Frame.Text2 = text2

local text3 = f:CreateFontString(nil, "OVERLAY")
text3:SetJustifyH("LEFT")
text3:SetFont(C["media"].font, 12)
text3:SetWidth(f:GetWidth()-40)
text3:SetPoint("TOPLEFT", text2, "BOTTOMLEFT", 0, -20)
G.Install.Frame.Text3 = text3

local text4 = f:CreateFontString(nil, "OVERLAY")
text4:SetJustifyH("LEFT")
text4:SetFont(C["media"].font, 12)
text4:SetWidth(f:GetWidth()-40)
text4:SetPoint("TOPLEFT", text3, "BOTTOMLEFT", 0, -20)
G.Install.Frame.Text4 = text4

local credits = f:CreateFontString(nil, "OVERLAY")
credits:SetFont(C["media"].font, 12, "THINOUTLINE")
credits:SetText("")
credits:SetPoint("BOTTOM", f, "BOTTOM", 0, 4)
G.Install.Frame.Credits = credits

local sbt = sb:CreateFontString(nil, "OVERLAY")
sbt:SetFont(C["media"].font, 13, "THINOUTLINE")
sbt:SetPoint("CENTER", sb)
G.Install.StatusBar.Text = sbt

local option1 = CreateFrame("Button", "DuffedUIInstallOption1", f)
option1:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 20, 20)
option1:SetSize(128, 25)
option1:SetTemplate("Default")
option1:FontString("Text", C["media"].font, 12)
option1.Text:SetPoint("CENTER")
G.Install.Option1 = option1

local option2 = CreateFrame("Button", "DuffedUIInstallOption2", f)
option2:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -20, 20)
option2:SetSize(128, 25)
option2:SetTemplate("Default")
option2:FontString("Text", C["media"].font, 12)
option2.Text:SetPoint("CENTER")
G.Install.Option2 = option2

local close = CreateFrame("Button", "DuffedUIInstallCloseButton", f, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", f, "TOPRIGHT")
close:SkinCloseButton()
close:SetScript("OnClick", function()
	f:Hide()
end)
G.Install.Close = close

local step4 = function()
	DuffedUIDataPerChar.install = true
	sb:SetValue(4)
	PlaySoundFile("Sound\\interface\\LevelUp.wav")
	header:SetText(L.install_header_11)
	text1:SetText(L.install_step_4_line_1)
	text2:SetText(L.install_step_4_line_2)
	text3:SetText(L.install_step_4_line_3)
	text4:SetText(L.install_step_4_line_4)
	sbt:SetText("4/4")
	option1:Hide()
	option2.Text:SetText(L.install_button_finish)
	option2:SetScript("OnClick", function()
		ReloadUI()
	end)
end

local step3 = function()
	if not option2:IsShown() then option2:Show() end	
	sb:SetValue(3)
	header:SetText(L.install_header_10)
	text1:SetText(L.install_step_3_line_1)
	text2:SetText(L.install_step_3_line_2)
	text3:SetText(L.install_step_3_line_3)
	text4:SetText(L.install_step_3_line_4)
	sbt:SetText("3/4")
	option1:SetScript("OnClick", step4)
	option2:SetScript("OnClick", function()
		positionsetup()
		step4()
	end)
end

local step2 = function()
	sb:SetValue(2)
	header:SetText(L.install_header_9)
	sbt:SetText("2/4")
	if IsAddOnLoaded("Prat") or IsAddOnLoaded("Chatter") then 
		text1:SetText(L.install_step_2_line_0)
		text2:SetText("")
		text3:SetText("")
		text4:SetText("")
		option2:Hide()
	else
		text1:SetText(L.install_step_2_line_1)
		text2:SetText(L.install_step_2_line_2)
		text3:SetText(L.install_step_2_line_3)
		text4:SetText(L.install_step_2_line_4)
		option2:SetScript("OnClick", function()
			D.ChatSetup()
			step3()
		end)
	end	
	option1:SetScript("OnClick", step3)
end

local step1 = function()
	close:Hide()
	sb:SetMinMaxValues(0, 4)
	sb:Show()
	sb:SetValue(1)
	sb:SetStatusBarColor(.26, 1, .22)
	header:SetText(L.install_header_8)
	text1:SetText(L.install_step_1_line_1)
	text2:SetText(L.install_step_1_line_2)
	text3:SetText(L.install_step_1_line_3)
	text4:SetText(L.install_step_1_line_4)
	sbt:SetText("1/4")

	option1:Show()

	option1.Text:SetText(L.install_button_skip)
	option2.Text:SetText(L.install_button_continue)

	option1:SetScript("OnClick", step2)
	option2:SetScript("OnClick", function()
		cvarsetup()
		local ms = GetCVar("gxMultisample")
		if ms ~= "1" then
			SetCVar("gxMultisample", 1)
			RestartGx()
		end
		step2()
	end)
	
	-- this is really essential, whatever if skipped or not
	SetActionBarToggles(1, 1, 1, 1, 0)
	SetCVar("alwaysShowActionBars", 0)
end

local tut6 = function()
	sb:SetValue(6)
	header:SetText(L.install_header_7)
	text1:SetText(L.tutorial_step_6_line_1)
	text2:SetText(L.tutorial_step_6_line_2)
	text3:SetText(L.tutorial_step_6_line_3)
	text4:SetText(L.tutorial_step_6_line_4)

	sbt:SetText("6/6")

	option1:Show()

	option1.Text:SetText(L.install_button_close)
	option2.Text:SetText(L.install_button_install)

	option1:SetScript("OnClick", function()
		f:Hide()
	end)
	option2:SetScript("OnClick", step1)
end

local tut5 = function()
	sb:SetValue(5)
	header:SetText(L.install_header_6)
	text1:SetText(L.tutorial_step_5_line_1)
	text2:SetText(L.tutorial_step_5_line_2)
	text3:SetText(L.tutorial_step_5_line_3)
	text4:SetText(L.tutorial_step_5_line_4)

	sbt:SetText("5/6")

	option2:SetScript("OnClick", tut6)
end

local tut4 = function()
	sb:SetValue(4)
	header:SetText(L.install_header_5)
	text1:SetText(L.tutorial_step_4_line_1)
	text2:SetText(L.tutorial_step_4_line_2)
	text3:SetText(L.tutorial_step_4_line_3)
	text4:SetText(L.tutorial_step_4_line_4)

	sbt:SetText("4/6")

	option2:SetScript("OnClick", tut5)
end

local tut3 = function()
	sb:SetValue(3)
	header:SetText(L.install_header_4)
	text1:SetText(L.tutorial_step_3_line_1)
	text2:SetText(L.tutorial_step_3_line_2)
	text3:SetText(L.tutorial_step_3_line_3)
	text4:SetText(L.tutorial_step_3_line_4)

	sbt:SetText("3/6")

	option2:SetScript("OnClick", tut4)
end

local tut2 = function()
	sb:SetValue(2)
	header:SetText(L.install_header_3)
	text1:SetText(L.tutorial_step_2_line_1)
	text2:SetText(L.tutorial_step_2_line_2)
	text3:SetText(L.tutorial_step_2_line_3)
	text4:SetText(L.tutorial_step_2_line_4)

	sbt:SetText("2/6")

	option2:SetScript("OnClick", tut3)
end

local tut1 = function()
	sb:SetMinMaxValues(0, 6)
	sb:Show()
	close:Show()
	sb:SetValue(1)
	sb:SetStatusBarColor(0, 0.76, 1)
	header:SetText(L.install_header_2)
	text1:SetText(L.tutorial_step_1_line_1)
	text2:SetText(L.tutorial_step_1_line_2)
	text3:SetText(L.tutorial_step_1_line_3)
	text4:SetText(L.tutorial_step_1_line_4)
	sbt:SetText("1/6")
	option1:Hide()
	option2.Text:SetText(L.install_button_next)
	option2:SetScript("OnClick", tut2)
end

-- this install DuffedUI with default settings.
local function install()
	f:Show()
	sb:Hide()
	option1:Show()
	option2:Show()
	close:Show()
	header:SetText(L.install_header_1)
	text1:SetText(L.install_init_line_1)
	text2:SetText(L.install_init_line_2)
	text3:SetText(L.install_init_line_3)
	text4:SetText(L.install_init_line_4)

	option1.Text:SetText(L.install_button_tutorial)
	option2.Text:SetText(L.install_button_install)

	option1:SetScript("OnClick", tut1)
	option2:SetScript("OnClick", step1)			
end

------------------------------------------------------------------------
--	On login function, look for some infos!
------------------------------------------------------------------------

local DuffedUIOnLogon = CreateFrame("Frame")
DuffedUIOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
DuffedUIOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	-- create empty saved vars if they doesn't exist.
	if (DuffedUIData == nil) then DuffedUIData = {} end
	if (DuffedUIDataPerChar == nil) then DuffedUIDataPerChar = {} end

	if D.screenwidth < 1200 then
			SetCVar("useUiScale", 0)
			D.ShowPopup("DUFFEDUIDISABLE_UI")
	else		
		-- install default if we never ran DuffedUI on this character.
		if not DuffedUIDataPerChar.install then			
			install()
		end
	end
	
	if (IsAddOnLoaded("DuffedUI_Raid") and IsAddOnLoaded("DuffedUI_Raid_Healing")) then
		D.ShowPopup("DUFFEDUIDISABLE_RAID")
	end
end)

SLASH_TUTORIAL1 = "/uihelp"
SLASH_TUTORIAL2 = "/tutorial"
SlashCmdList.TUTORIAL = function() f:Show() tut1() end

SLASH_VERSION1 = "/version"
SlashCmdList.VERSION = function() if v:IsShown() then v:Hide() else v:Show() end end

SLASH_CONFIGURE1 = "/install"
SlashCmdList.CONFIGURE = install

SLASH_RESETUI1 = "/reset"
SlashCmdList.RESETUI = function() f:Show() step1() end

D.CreatePopup["DUFFEDUIDISABLE_UI"] = {
	question = L.popup_disableui,
	answer1 = ACCEPT,
	answer2 = CANCEL,
	function1 = function() DisableAddOn("DuffedUI") ReloadUI() end,
}

D.CreatePopup["DUFFEDUIDISABLE_RAID"] = {
	question = "Choose your favorite Raidlayout:",
	answer1 = "DPS, Tank",
	answer2 = "Healing",
	function1 = function() DisableAddOn("DuffedUI_Raid_Healing") EnableAddOn("DuffedUI_Raid") ReloadUI() end,
	function2 = function() EnableAddOn("DuffedUI_Raid_Healing") DisableAddOn("DuffedUI_Raid") ReloadUI() end,
}