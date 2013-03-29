--[[ 
		Raid utilities are loaded only if you are using DuffedUI raid frames 
		All others raid frames mods or default Blizzard should have already this feature
--]]

local D, C, L, G = unpack(select(2, ...))
local panel_height = ((D.Scale(5) * 4) + (D.Scale(22) * 4))
local r,g,b = C["media"].backdropcolor

local function CreateUtilities(self, event, addon)
	if addon == "DuffedUI_Raid_Healing" or addon == "DuffedUI_Raid" then
		-- it need the DuffedUI minimap
		if not DuffedUIMinimap then return end
		
		-- Anchor
		local anchor = CreateFrame("Frame", "DuffedUIRaidUtilityAnchor", UIParent)
		anchor:SetMovable(true)
		anchor:SetTemplate("Default")
		anchor:Size(DuffedUIMinimap:GetWidth(), 21)
		anchor:Point("TOP", UIParent, "TOP", -200, 0)
		anchor:SetScript("OnMouseDown", function() anchor:StartMoving() end)
		anchor:SetScript("OnMouseUp", function() anchor:StopMovingOrSizing() end)
		anchor:SetBackdropBorderColor(1,0,0)
		anchor:CreateShadow("")
		anchor:SetFrameStrata("HIGH")
		anchor:SetUserPlaced(true)
		anchor:SetClampedToScreen(true)
		anchor:Hide()
		tinsert(D.AllowFrameMoving, DuffedUIRaidUtilityAnchor)
		
		anchor.text = anchor:CreateFontString(nil, "OVERLAY")
		anchor.text:SetFont(C["media"].font, C["datatext"].fontsize)
		anchor.text:SetPoint("CENTER")
		anchor.text:SetText("Move RaidUtility")

		--Create main frame
		local DuffedUIRaidUtility = CreateFrame("Frame", "DuffedUIRaidUtility", DuffedUIMinimap)
		DuffedUIRaidUtility:SetTemplate()
		DuffedUIRaidUtility:Size(DuffedUIMinimap:GetWidth(), panel_height)
		DuffedUIRaidUtility:Point("TOPLEFT", anchor, "TOPLEFT", 0, 0)
		DuffedUIRaidUtility:Hide()
		DuffedUIRaidUtility:SetFrameLevel(10)
		DuffedUIRaidUtility:SetFrameStrata("Medium")

		--Check if We are Raid Leader or Raid Officer
		local function CheckRaidStatus()
			local inInstance, instanceType = IsInInstance()
			if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
				return true
			else
				return false
			end
		end

		--Change border when mouse is inside the button
		local function ButtonEnter(self)
			local color = RAID_CLASS_COLORS[D.myclass]
			self:SetBackdropBorderColor(color.r, color.g, color.b)
		end

		--Change border back to normal when mouse leaves button
		local function ButtonLeave(self)
			self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		end

		-- Function to create buttons in this module
		local function CreateButton(name, parent, template, width, height, point, relativeto, point2, xOfs, yOfs, text, texture)
			local b = CreateFrame("Button", name, parent, template)
			b:SetWidth(width)
			b:SetHeight(height)
			b:SetPoint(point, relativeto, point2, xOfs, yOfs)
			b:HookScript("OnEnter", ButtonEnter)
			b:HookScript("OnLeave", ButtonLeave)
			b:EnableMouse(true)
			b:SetTemplate("Default")
			if text then
				local t = b:CreateFontString(nil,"OVERLAY",b)
				t:SetFont(C["media"].font,12)
				t:SetPoint("CENTER")
				t:SetJustifyH("CENTER")
				t:SetText(text)
				b:SetFontString(t)
			elseif texture then
				local t = b:CreateTexture(nil,"OVERLAY",nil)
				t:SetTexture(normTex)
				t:SetPoint("TOPLEFT", b, "TOPLEFT", D.mult, -D.mult)
				t:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -D.mult, D.mult)
			end
		end

		--Show Button
		CreateButton("DuffedUIRaidUtilityShowButton", DuffedUIMinimap, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", DuffedUIMinimap:GetWidth(), 21, "TOPLEFT", anchor, "TOPLEFT", 0, 0, RAID_ASSISTANT, nil)
		DuffedUIRaidUtilityShowButton:SetFrameRef("DuffedUIRaidUtility", DuffedUIRaidUtility)
		DuffedUIRaidUtilityShowButton:SetAttribute("_onclick", [=[self:Hide(); self:GetFrameRef("DuffedUIRaidUtility"):Show();]=])
		DuffedUIRaidUtilityShowButton:SetScript("OnMouseUp", function(self) DuffedUIRaidUtility.toggled = true end)
		DuffedUIRaidUtilityShowButton:Hide()

		--Close Button
		CreateButton("DuffedUIRaidUtilityCloseButton", DuffedUIRaidUtility, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", DuffedUIMinimap:GetWidth(), 21, "TOP", DuffedUIRaidUtility, "BOTTOM", 0, -2, CLOSE, nil)
		DuffedUIRaidUtilityCloseButton:SetFrameRef("DuffedUIRaidUtilityShowButton", DuffedUIRaidUtilityShowButton)
		DuffedUIRaidUtilityCloseButton:SetAttribute("_onclick", [=[self:GetParent():Hide(); self:GetFrameRef("DuffedUIRaidUtilityShowButton"):Show();]=])
		DuffedUIRaidUtilityCloseButton:SetScript("OnMouseUp", function(self) DuffedUIRaidUtility.toggled = false end)

		--Disband Raid button
		CreateButton("DuffedUIRaidUtilityDisbandRaidButton", DuffedUIRaidUtility, "UIMenuButtonStretchTemplate", DuffedUIRaidUtility:GetWidth() * .95, D.Scale(21), "TOP", DuffedUIRaidUtility, "TOP", 0, D.Scale(-5), "Disband Group", nil)
		DuffedUIRaidUtilityDisbandRaidButton:SetScript("OnMouseUp", function(self)
			if CheckRaidStatus() then
				D.ShowPopup("DUFFEDUIDISBAND_RAID")
			end
		end)

		--Role Check button
		CreateButton("DuffedUIRaidUtilityRoleCheckButton", DuffedUIRaidUtility, "UIMenuButtonStretchTemplate", DuffedUIRaidUtility:GetWidth() * .95, D.Scale(21), "TOP", DuffedUIRaidUtilityDisbandRaidButton, "BOTTOM", 0, D.Scale(-5), ROLE_POLL, nil)
		DuffedUIRaidUtilityRoleCheckButton:SetScript("OnMouseUp", function(self)
			if CheckRaidStatus() then
				if InCombatLockdown() then
					print(ERR_NOT_IN_COMBAT)
				else
					InitiateRolePoll()
				end
			end
		end)

		--MainTank Button
		CreateButton("DuffedUIRaidUtilityMainTankButton", DuffedUIRaidUtility, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate", (DuffedUIRaidUtilityDisbandRaidButton:GetWidth() / 2) - D.Scale(2), D.Scale(21), "TOPLEFT", DuffedUIRaidUtilityRoleCheckButton, "BOTTOMLEFT", 0, D.Scale(-5), MAINTANK, nil)
		DuffedUIRaidUtilityMainTankButton:SetAttribute("type", "maintank")
		DuffedUIRaidUtilityMainTankButton:SetAttribute("unit", "target")
		DuffedUIRaidUtilityMainTankButton:SetAttribute("action", "set")

		--MainAssist Button
		CreateButton("DuffedUIRaidUtilityMainAssistButton", DuffedUIRaidUtility, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate", (DuffedUIRaidUtilityDisbandRaidButton:GetWidth() / 2) - D.Scale(2), D.Scale(21), "TOPRIGHT", DuffedUIRaidUtilityRoleCheckButton, "BOTTOMRIGHT", 0, D.Scale(-5), MAINASSIST, nil)
		DuffedUIRaidUtilityMainAssistButton:SetAttribute("type", "mainassist")
		DuffedUIRaidUtilityMainAssistButton:SetAttribute("unit", "target")
		DuffedUIRaidUtilityMainAssistButton:SetAttribute("action", "set")

		--Ready Check button
		CreateButton("DuffedUIRaidUtilityReadyCheckButton", DuffedUIRaidUtility, "UIMenuButtonStretchTemplate", DuffedUIRaidUtilityRoleCheckButton:GetWidth() * .75, D.Scale(21), "TOPLEFT", DuffedUIRaidUtilityMainTankButton, "BOTTOMLEFT", 0, D.Scale(-5), READY_CHECK, nil)
		DuffedUIRaidUtilityReadyCheckButton:SetScript("OnMouseUp", function(self)
			if CheckRaidStatus() then
				DoReadyCheck()
			end
		end)

		--Reposition/Resize and Reuse the World Marker Button
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetPoint("TOPRIGHT", DuffedUIRaidUtilityMainAssistButton, "BOTTOMRIGHT", 0, D.Scale(-5))
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent(DuffedUIRaidUtility)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetHeight(D.Scale(21))
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetWidth(DuffedUIRaidUtilityRoleCheckButton:GetWidth() * .22)

		--Put other stuff back
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:ClearAllPoints()
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLockedModeToggle, "TOPLEFT", 0, 1)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameHiddenModeToggle, "TOPRIGHT", 0, 1)

		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:ClearAllPoints()
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPLEFT", 0, 1)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPRIGHT", 0, 1)

		--Reskin Stuff
		do
			local buttons = {
				"CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton",
				"DuffedUIRaidUtilityDisbandRaidButton",
				"DuffedUIRaidUtilityMainTankButton",
				"DuffedUIRaidUtilityMainAssistButton",
				"DuffedUIRaidUtilityRoleCheckButton",
				"DuffedUIRaidUtilityReadyCheckButton",
				"DuffedUIRaidUtilityShowButton",
				"DuffedUIRaidUtilityCloseButton"
			}

			for i, button in pairs(buttons) do
				local f = _G[button]
				_G[button.."Left"]:SetAlpha(0)
				_G[button.."Middle"]:SetAlpha(0)
				_G[button.."Right"]:SetAlpha(0)
				f:SetHighlightTexture("")
				f:SetDisabledTexture("")
				f:HookScript("OnEnter", ButtonEnter)
				f:HookScript("OnLeave", ButtonLeave)
				f:SetTemplate("Default", true)
			end
		end

		local function ToggleRaidUtil(self, event)
			if InCombatLockdown() then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				return
			end

			if CheckRaidStatus() then
				if not DuffedUIRaidUtility.toggled then DuffedUIRaidUtilityShowButton:Show() end
			else
				DuffedUIRaidUtilityShowButton:Hide()
				if DuffedUIRaidUtility:IsShown() then DuffedUIRaidUtility:Hide() end
			end

			if event == "PLAYER_REGEN_ENABLED" then
				self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			end
			
			if UnitInRaid("player") then
				DuffedUIRaidUtilityMainTankButton:Enable()
				DuffedUIRaidUtilityMainAssistButton:Enable()
			else
				DuffedUIRaidUtilityMainTankButton:Disable()
				DuffedUIRaidUtilityMainAssistButton:Disable()			
			end
		end

		--Automatically show/hide the frame if we have RaidLeader or RaidOfficer
		local LeadershipCheck = CreateFrame("Frame")
		LeadershipCheck:RegisterEvent("GROUP_ROSTER_UPDATE")
		LeadershipCheck:SetScript("OnEvent", ToggleRaidUtil)
	end
end

local AddonLoaded = CreateFrame("Frame")
AddonLoaded:RegisterEvent("ADDON_LOADED")
AddonLoaded:SetScript("OnEvent", CreateUtilities)