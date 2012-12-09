local D, C, L, G = unpack(select(2, ...))

-- Slash commands
if IsAddOnLoaded("AuctionMaster") then
	SLASH_ALOAD1 = "/ap"
	SlashCmdList.ALOAD = function (msg)
		addonBG:Show()
	end
else
	SLASH_ALOAD1 = "/am"
	SlashCmdList.ALOAD = function (msg)
		addonBG:Show()
	end
end

-- Create BG
local addonBG = CreateFrame("Frame", "addonBG", UIParent)
addonBG:SetTemplate("Transparent")
addonBG:Size(D.InfoLeftRightWidth, 500)
addonBG:Point("CENTER", UIParent, "CENTER", 0, 0)
addonBG:EnableMouse(true)
addonBG:SetMovable(true)
addonBG:SetUserPlaced(true)
addonBG:SetClampedToScreen(true)
addonBG:SetScript("OnMouseDown", function(self) self:StartMoving() end)
addonBG:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
addonBG:SetFrameStrata("HIGH")
tinsert(UISpecialFrames, "addonBG")
addonBG:Hide()

local addonHeader = CreateFrame("Frame", "addonHeader", addonBG)
addonHeader:SetTemplate("Transparent")
addonHeader:Size(addonBG:GetWidth(), 23)
addonHeader:Point("BOTTOM", addonBG, "TOP", 0, 3, true)
addonHeader.Text = D.SetFontString(addonHeader, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
addonHeader.Text:SetPoint("LEFT", 5, 1)
addonHeader.Text:SetText(D.panelcolor.."AddOns List"..": "..D.panelcolor..D.myname)

-- Create scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", addonBG, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", addonBG, "TOPLEFT", 10, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", addonBG, "BOTTOMRIGHT", -30, 40)
scrollFrame:SkinScrollBar()


-- Create inside BG (uses scroll frame)
local buttonsBG = CreateFrame("Frame", "buttonsBG", scrollFrame)
buttonsBG:SetPoint("TOPLEFT")
buttonsBG:SetWidth(scrollFrame:GetWidth())
buttonsBG:SetHeight(scrollFrame:GetHeight())
scrollFrame:SetScrollChild(buttonsBG)

local saveButton = CreateFrame("Button", "saveButton", addonBG)
saveButton:SetTemplate("Default")
saveButton:Size(130, 20)
saveButton:Point("BOTTOMLEFT", addonBG, "BOTTOMLEFT", 10, 10, true)
saveButton:SetFrameStrata("TOOLTIP")
saveButton:CreateOverlay(saveButton)
saveButton:SetScript("OnClick", function() ReloadUI() end)
saveButton:HookScript("OnEnter", D.SetModifiedBackdrop)
saveButton:HookScript("OnLeave", D.SetOriginalBackdrop)

saveButton.Text = D.SetFontString(saveButton, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
saveButton.Text:Point("CENTER", saveButton, "CENTER", 1, 1)
saveButton.Text:SetText(D.panelcolor.."Save Changes")


local closeButton = CreateFrame("Button", "closeButton", addonBG)
closeButton:SetTemplate("Default")
closeButton:Size(130, 20)
closeButton:Point("BOTTOMRIGHT", addonBG, "BOTTOMRIGHT", -10, 10, true)
closeButton:SetFrameStrata("TOOLTIP")
closeButton:CreateOverlay(closeButton)
closeButton:SetScript("OnClick", function() addonBG:Hide() end)
closeButton:HookScript("OnEnter", D.SetModifiedBackdrop)
closeButton:HookScript("OnLeave", D.SetOriginalBackdrop)
closeButton.Text = D.SetFontString(closeButton, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
closeButton.Text:Point("CENTER", closeButton, "CENTER", 1, 1)
closeButton.Text:SetText(D.panelcolor.."Cancel")

local function UpdateAddons()
	local addons = {}
	for i=1, GetNumAddOns() do
		addons[i] = select(1, GetAddOnInfo(i))
	end
	table.sort(addons)
	local oldb
	for i,v in pairs(addons) do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v)
		local button = CreateFrame("Button", v.."_Button", buttonsBG, "SecureActionButtonTemplate")
		button:SetFrameLevel(buttonsBG:GetFrameLevel() + 1)
		button:Size(16, 16)
		button:SetTemplate("Default")
		button:CreateOverlay()

		-- to make sure the border is colored the right color on reload
		if enabled then
			button:SetBackdropBorderColor(.67, .83, .45)
		else
			button:SetBackdropBorderColor(.77, .12, .23)
		end

		if i==1 then
			button:Point("TOPLEFT", buttonsBG, "TOPLEFT", 0, 0)
		else
			button:Point("TOP", oldb, "BOTTOM", 0, -7)
		end
		
		local text = D.SetFontString(button, C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
		text:Point("LEFT", button, "RIGHT", 8, 0)
		text:SetText(title)

		button:SetScript("OnMouseDown", function()
            if enabled then
                button:SetBackdropBorderColor(.77, .12, .23)
                DisableAddOn(name)
                enabled = false
            else
                button:SetBackdropBorderColor(.67, .83, .45)
                EnableAddOn(name)
                enabled = true
            end
        end)

		oldb = button
	end
end
UpdateAddons()
scrollFrameScrollBar:SkinScrollBar()