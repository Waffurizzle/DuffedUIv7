local D, C, L, G = unpack(select(2, ...)) 
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Setup Main Action Bar.
-- Now used for stances, Bonus, Vehicle at the same time.
-- Since t12, it's also working for druid cat stealth. (a lot requested)
---------------------------------------------------------------------------

local bar = DuffedUIBar1
if C["actionbar"].swap and C["actionbar"].layout == 1 then bar = DuffedUIBar2 end

local shd = 7
local meta = ""
local warstance = ""

if C["actionbar"].ownshdbar then shd = 10 end
if C["actionbar"].ownmetabar then meta = "[stance:1] 10; [stance:2] 10;" end
if C["actionbar"].ownwarstancebar then warstance = "[stance:1] 7; [stance:2] 8; [stance:3] 9;" end

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = warstance,
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [stance:3] "..shd..";",
	["MONK"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["WARLOCK"] = meta,
	["DEFAULT"] = "[vehicleui:12] 12; [possessbar] 12; [overridebar] 14; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
}

local function GetBar()
	local condition = Page["DEFAULT"]
	local class = D.myclass
	local page = Page[class]
	if page then
		condition = condition.." "..page
	end
	condition = condition.." 1"

	return condition
end

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
bar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
bar:RegisterEvent("BAG_UPDATE")
bar:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
bar:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
bar:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
			G.ActionBars.Bar1["Button"..i] = button
		end	

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		]])

		self:SetAttribute("_onstate-page", [[ 
			for i, button in ipairs(buttons) do
				button:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
		
		RegisterStateDriver(self, "page", GetBar())	
	elseif event == "PLAYER_ENTERING_WORLD" then
		local button
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:SetSize(D.buttonsize, D.buttonsize)
			button:ClearAllPoints()
			button:SetParent(bar)
			button:SetFrameStrata("BACKGROUND")
			button:SetFrameLevel(15)
			if C["actionbar"].layout == 2 and C["actionbar"].swap then
				if i == 1 then
					button:SetPoint("TOPLEFT", D.buttonspacing, -D.buttonspacing)
				else
					local previous = _G["ActionButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", D.buttonspacing, 0)
				end
			else
				if i == 1 then
					button:SetPoint("BOTTOMLEFT", D.buttonspacing, D.buttonspacing)
				else
					local previous = _G["ActionButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", D.buttonspacing, 0)
				end
			end
		end
	elseif event == "UPDATE_VEHICLE_ACTIONBAR" or event == "UPDATE_OVERRIDE_ACTIONBAR" then
		if HasVehicleActionBar() or HasOverrideActionBar() then
			if not self.inVehicle then
				DuffedUIBar2Button:Hide()
				DuffedUIBar3Button:Hide()
				DuffedUIBar3Button2:Hide()
				self.inVehicle = true
			end
		else
			if self.inVehicle then
				DuffedUIBar2Button:Show()
				DuffedUIBar3Button:Show()
				DuffedUIBar3Button2:Show()
				self.inVehicle = false
			end
		end
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)