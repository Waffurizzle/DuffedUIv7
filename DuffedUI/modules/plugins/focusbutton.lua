local D, C, L, G = unpack(select(2, ...))

local Focus = CreateFrame("Frame", "Focus", UIParent)
for i = 1, 2 do
	Focus[i] = CreateFrame("Button", "Focus"..i, parent, "SecureActionButtonTemplate")
	Focus[i]:Size(50, 10)
	Focus[i]:SetTemplate("Default")
	Focus[i]:EnableMouse(true)
	Focus[i]:RegisterForClicks("AnyUp")
	Focus[i]:StripTextures()
	Focus[i].Text = Focus[i]:CreateFontString(nil, "OVERLAY")
	Focus[i].Text:SetFont(C["media"].font, 12, "THINOUTLINE")
	Focus[i].Text:SetShadowOffset(0, 0)
	Focus[i].Text:SetPoint("CENTER")
	if i == 1 then
		Focus[i]:SetParent(DuffedUITarget)
		if C["unitframes"].layout == 1 then
			Focus[i]:Point("CENTER", DuffedUITarget, "CENTER", 10, -7)
		elseif C["unitframes"].layout == 2 then
			Focus[i]:Point("CENTER", DuffedUITarget, "CENTER", 10, 7)
		elseif C["unitframes"].layout == 3 then
			Focus[i]:Point("BOTTOMRIGHT", DuffedUITarget, "BOTTOMRIGHT", 20, -1)
		end
		Focus[i]:SetAttribute("type1", "macro")
		Focus[i]:SetAttribute("macrotext1", "/focus")
		Focus[i]:SetFrameLevel(DuffedUITarget:GetFrameLevel() + 2)
		Focus[i].Text:SetText(D.panelcolor.."Focus")
	elseif i == 2 then
		Focus[i]:SetParent(DuffedUIFocus)
		if C["unitframes"].layout == 1 then
			if C["unitframes"].largefocus then
				Focus[i]:Point("CENTER", DuffedUIFocus, "CENTER", 0, -5)
			else
				Focus[i]:Point("CENTER", DuffedUIFocus, "CENTER", 0, -1)
			end
		elseif C["unitframes"].layout == 2 then
			if C["unitframes"].largefocus then
				Focus[i]:Point("CENTER", DuffedUIFocus, "CENTER", 0, 7)
			else
				Focus[i]:Point("CENTER", DuffedUIFocus, "CENTER", 0, -1)
			end
		elseif C["unitframes"].layout == 3 then
			Focus[i]:Point("TOPRIGHT", DuffedUIFocus, "TOPRIGHT", 2, 14)
		end
		Focus[i]:SetAttribute("type1", "macro")
		Focus[i]:SetAttribute("macrotext1", "/clearfocus")
		Focus[i]:SetFrameLevel(DuffedUIFocus:GetFrameLevel() + 2)
		Focus[i].Text:SetText(D.panelcolor.."ClearFocus")
	end
end