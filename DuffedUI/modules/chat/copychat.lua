local D, C, L, G = unpack(select(2, ...)) 
-----------------------------------------------------------------------------
-- Copy on chatframes feature
-----------------------------------------------------------------------------

if C["chat"].enable ~= true then return end

local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreateCopyFrame()
	frame = CreateFrame("Frame", "DuffedUIChatCopyFrame", UIParent)
	frame:SetTemplate("Transparent")
	frame:Width(DuffedUIBar1:GetWidth())
	frame:Height(250)
	frame:SetScale(1)
	frame:Point("BOTTOM", UIParent, "BOTTOM", 0, 10)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "DuffedUIChatCopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:Point("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	editBox = CreateFrame("EditBox", "DuffedUIChatCopyEditBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	if D.lowversion then
		editBox:Width(DuffedUIBar1:GetWidth() + 10)
	else
		editBox:Width((DuffedUIBar1:GetWidth() * 2) + 20)
	end
	editBox:Height(250)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	close:SkinCloseButton()
	DuffedUIChatCopyScrollScrollBar:SkinScrollBar()

	isf = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, .01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreateCopyFrame() end
	if frame:IsShown() then frame:Hide() return end
	frame:Show()
	editBox:SetText(text)
end

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G[format("ChatFrame%d",  i)]
	local button = CreateFrame("Button", format("DuffedUIButtonCF%d", i), cf)
	if C["actionbar"].layout == 1 then
		if C["chat"].lbackground and C["chat"].rbackground then button:SetPoint("TOPRIGHT", 4, 25) else button:SetPoint("TOPRIGHT", 0, 0) end
	else
		if C["chat"].lbackground and C["chat"].rbackground then button:SetPoint("TOPRIGHT", 5, 25) else button:SetPoint("TOPRIGHT", 0, 0) end
	end
	button:Height(20)
	button:Width(20)
	button:SetNormalTexture(C["media"].copyicon)
	if C["chat"].lbackground and C["chat"].rbackground then button:SetAlpha(1) else button:SetAlpha(0) end
	button:SetTemplate("Default")

	button:SetScript("OnMouseUp", function(self)
		Copy(cf)
	end)
	if not C["chat"].lbackground and C["chat"].rbackground then
		button:SetScript("OnEnter", function() 
			button:SetAlpha(1) 
		end)
		button:SetScript("OnLeave", function() button:SetAlpha(0) end)
	end
	
	G.Chat["ChatFrame"..i].Copy = button
end

-- little fix for RealID text copy/paste (real name bug)
for i=1, NUM_CHAT_WINDOWS do
	local editbox = _G["ChatFrame"..i.."EditBox"]
	editbox:HookScript("OnTextChanged", function(self)
		local text = self:GetText()
		
		local new, found = gsub(text, "|Kf(%S+)|k(%S+)%s(%S+)k:%s", "%2 %3: ")
		
		if found > 0 then
			new = new:gsub('|', '')
			self:SetText(new)
		end
	end)
end