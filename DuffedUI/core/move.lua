local D, C, L, G = unpack(select(2, ...)) 

-- all the frame we want to move
-- all our frames that we want being movable.
D.AllowFrameMoving = {}

-- used to exec various code if we enable or disable moving
local function exec(self, enable)
	if self == DuffedUIGMFrameAnchor or self == TCBanchor or self == FCBanchor or self == RCDAnchor or self == DuffedUISpellCooldowns or self == DuffedUIBnetHolder then
		if enable then
			self:Show()
		else
			self:Hide()
		end
	end

	if self == DuffedUIMinimap then
		if enable then 
			Minimap:Hide()
			self:SetBackdropBorderColor(1, 0, 0, 1)
		else 
			Minimap:Show()
			self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		end
	end

	if self == DuffedUIAurasPlayerBuffs then
		local buffs = DuffedUIAurasPlayerBuffs
		
		if enable then
			buffs.backdrop:SetAlpha(1)
		else
			local position = self:GetPoint()
			if position:match("TOPLEFT") or position:match("BOTTOMLEFT") or position:match("BOTTOMRIGHT") or position:match("TOPRIGHT") then
				buffs:SetAttribute("point", position)
			end
			if position:match("LEFT") then
				buffs:SetAttribute("xOffset", 35)
			else
				buffs:SetAttribute("xOffset", -35)
			end
			if position:match("BOTTOM") then
				buffs:SetAttribute("wrapYOffset", 67.5)
			else
				buffs:SetAttribute("wrapYOffset", -67.5)
			end
			buffs.backdrop:SetAlpha(0)
		end
	end
	
	if self == DuffedUIAurasPlayerDebuffs then
		local debuffs = DuffedUIAurasPlayerDebuffs
		
		if enable then
			debuffs.backdrop:SetAlpha(1)
		else
			local position = self:GetPoint()
			if position:match("TOPLEFT") or position:match("BOTTOMLEFT") or position:match("BOTTOMRIGHT") or position:match("TOPRIGHT") then
				debuffs:SetAttribute("point", position)
			end
			if position:match("LEFT") then
				debuffs:SetAttribute("xOffset", 35)
			else
				debuffs:SetAttribute("xOffset", -35)
			end
			if position:match("BOTTOM") then
				debuffs:SetAttribute("wrapYOffset", 67.5)
			else
				debuffs:SetAttribute("wrapYOffset", -67.5)
			end
			debuffs.backdrop:SetAlpha(0)
		end
	end
	
	if self == DuffedUITooltipAnchor or self == DuffedUIRollAnchor or self == DuffedUIAchievementHolder or self == DuffedUIVehicleAnchor then
		if enable then
			self:SetAlpha(1)
		else
			self:SetAlpha(0)
			if self == DuffedUITooltipAnchor then 
				local position = DuffedUITooltipAnchor:GetPoint()
				local healthBar = GameTooltipStatusBar
				if position:match("TOP") then
					healthBar:ClearAllPoints()
					healthBar:Point("TOPLEFT", healthBar:GetParent(), "BOTTOMLEFT", 2, -5)
					healthBar:Point("TOPRIGHT", healthBar:GetParent(), "BOTTOMRIGHT", -2, -5)
					if healthBar.text then healthBar.text:Point("CENTER", healthBar, 0, -6) end
				else
					healthBar:ClearAllPoints()
					healthBar:Point("BOTTOMLEFT", healthBar:GetParent(), "TOPLEFT", 2, 5)
					healthBar:Point("BOTTOMRIGHT", healthBar:GetParent(), "TOPRIGHT", -2, 5)
					if healthBar.text then healthBar.text:Point("CENTER", healthBar, 0, 6) end			
				end
			end
		end		
	end
	
	if self == DuffedUIWatchFrameAnchor or self == DuffedUIExtraActionBarFrameHolder then
		if enable then
			self:SetAlpha(1)		
		else
			self:SetAlpha(0)		
		end
	end
	
	if self == DuffedUIStance then
		if enable then
			DuffedUIStanceHolder:SetAlpha(1)
		else
			DuffedUIStanceHolder:SetAlpha(0)
		end
	end
end

local enable = true
local origa1, origf, origa2, origx, origy

local gridsize = function()
	local defsize = 16
	local w = tonumber(string.match(({ GetScreenResolutions() })[GetCurrentResolution()], "(%d+)x+%d"))
	local h = tonumber(string.match(({ GetScreenResolutions() })[GetCurrentResolution()], "%d+x(%d+)"))
	local x = tonumber(gridsize) or defsize

	function Grid()
		ali = CreateFrame("Frame", nil, UIParent)
		ali:SetFrameLevel(0)
		ali:SetFrameStrata("BACKGROUND")

		for i = - (w / x / 2), w / x / 2 do
			local aliv = ali:CreateTexture(nil, "BACKGROUND")
			aliv:SetTexture(0.3, 0, 0, 0.7)
			aliv:Point("CENTER", UIParent, "CENTER", i * x, 0)
			aliv:SetSize(1, h)
		end

		for i = - (h / x / 2), h / x / 2 do
			local alih = ali:CreateTexture(nil, "BACKGROUND")
			alih:SetTexture(0.3, 0, 0, 0.7)
			alih:Point("CENTER", UIParent, "CENTER", 0, i * x)
			alih:SetSize(w, 1)
		end
	end

	if Ali then
		if ox ~= x then
			ox = x
			ali:Hide()
			Grid()
			Ali = true
		else
			ali:Hide()
			Ali = false
		end
	else
		ox = x
		Grid()
		Ali = true
	end
end

D.MoveUIElements = function()
	if DuffedUIRaidUtilityAnchor then
		if DuffedUIRaidUtilityAnchor:IsShown() then DuffedUIRaidUtilityAnchor:Hide() else DuffedUIRaidUtilityAnchor:Show() end
	end
	
	if sCombosAnchor then
		if sCombosAnchor:IsShown() then sCombosAnchor:Hide() else sCombosAnchor:Show() end
	end
	
	for i = 1, getn(D.AllowFrameMoving) do
		if D.AllowFrameMoving[i] then		
			if enable then
				D.AllowFrameMoving[i]:EnableMouse(true)
				D.AllowFrameMoving[i]:RegisterForDrag("LeftButton", "RightButton")
				D.AllowFrameMoving[i]:SetScript("OnDragStart", function(self) 
					origa1, origf, origa2, origx, origy = D.AllowFrameMoving[i]:GetPoint() 
					self.moving = true 
					self:SetUserPlaced(true) 
					self:StartMoving() 
				end)			
				D.AllowFrameMoving[i]:SetScript("OnDragStop", function(self) 
					self.moving = false 
					self:StopMovingOrSizing() 
				end)			
				exec(D.AllowFrameMoving[i], enable)			
				if D.AllowFrameMoving[i].text then 
					D.AllowFrameMoving[i].text:Show() 
				end
			else			
				D.AllowFrameMoving[i]:EnableMouse(false)
				if D.AllowFrameMoving[i].moving == true then
					D.AllowFrameMoving[i]:StopMovingOrSizing()
					D.AllowFrameMoving[i]:ClearAllPoints()
					D.AllowFrameMoving[i]:SetPoint(origa1, origf, origa2, origx, origy)
				end
				exec(D.AllowFrameMoving[i], enable)
				if D.AllowFrameMoving[i].text then D.AllowFrameMoving[i].text:Hide() end
				D.AllowFrameMoving[i].moving = false
			end
		end
	end
	
	if enable then 
		enable = false
		gridsize()
	else
		enable = true
		gridsize()
	end
end
SLASH_MOVING1 = "/mduffedui"
SLASH_MOVING2 = "/moveui"
SlashCmdList["MOVING"] = function()
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	
	D.MoveUIElements()
	
	if D.MoveUnitFrames then
		D.MoveUnitFrames()
	end
end

local protection = CreateFrame("Frame")
protection:RegisterEvent("PLAYER_REGEN_DISABLED")
protection:SetScript("OnEvent", function(self, event)
	if enable then return end
	print(ERR_NOT_IN_COMBAT)
	enable = false
	D.MoveUIElements()
end)