local D, C, L, G = unpack(select(2, ...))
if C["misc"].location  ~= true then return end

local locpanel = CreateFrame("Frame", "DuffedUILocationPanel", UIParent)
locpanel:Size(70, 20)
locpanel:SetPoint("TOP", UIParent, "TOP", 0, -1)
locpanel:SetTemplate("Default")
locpanel:SetFrameStrata("Medium")
locpanel:SetFrameLevel(6)
locpanel:EnableMouse(true)

local xcoords = CreateFrame("Frame", "DuffedUIXCoordsPanel", locpanel)
xcoords:Size(35, 20)
xcoords:SetPoint("RIGHT", locpanel, "LEFT", -1, 0)
xcoords:SetTemplate("Default")

local ycoords = CreateFrame("Frame", "DuffedUIYCoordsPanel", locpanel)
ycoords:Size(35, 20)
ycoords:SetPoint("LEFT", locpanel, "RIGHT", 1, 0)
ycoords:SetTemplate("Default")

-- Set font
local locFS = locpanel:CreateFontString(nil, "OVERLAY")
locFS:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")

local xFS = xcoords:CreateFontString(nil, "OVERLAY")
xFS:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")

local yFS = ycoords:CreateFontString(nil, "OVERLAY")
yFS:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")

local function SetLocColor(frame, pvpT)
	if (pvpT == "arena" or pvpT == "combat") then
		frame:SetTextColor(1, 0.5, 0)
	elseif pvpT == "friendly" then
		frame:SetTextColor(0, 1, 0)
	elseif pvpT == "contested" then
		frame:SetTextColor(1, 1, 0)
	elseif pvpT == "hostile" then
		frame:SetTextColor(1, 0, 0)
	elseif pvpT == "sanctuary" then
		frame:SetTextColor(0, .9, .9)
	else
		frame:SetTextColor(0, 1, 0)
	end
end

local function OnEvent()
	location = GetMinimapZoneText()
	pvpType = GetZonePVPInfo();
	locFS:SetText(location)
	locpanel:SetWidth(locFS:GetStringWidth() + 40)
	SetLocColor(locFS, pvpType)
	locFS:SetPoint("CENTER", locpanel, "CENTER", 1, 0.5)
	locFS:SetJustifyH("CENTER")
end

local function xUpdate()
	posX, posY = GetPlayerMapPosition("player");
	posX = math.floor(100 * posX)
	xFS:SetText(posX)
	xFS:SetPoint("CENTER", xcoords, "CENTER", 1, 0.5)
end

local function yUpdate()
	posX, posY = GetPlayerMapPosition("player");
	posY = math.floor(100 * posY)
	yFS:SetText(posY)
	yFS:SetPoint("CENTER", ycoords, "CENTER", 1, 0.5)
end

locpanel:SetScript("OnMouseDown", function()
	if WorldMapFrame:IsShown() then WorldMapFrame:Hide() else WorldMapFrame:Show() end
end)
locpanel:SetScript("OnEnter", function() locFS:SetTextColor(1, 1, 1) end)
locpanel:SetScript("OnLeave", function()
	pvpType = GetZonePVPInfo();
	SetLocColor(locFS, pvpType)	
end)
locpanel:RegisterEvent("ZONE_CHANGED")
locpanel:RegisterEvent("PLAYER_ENTERING_WORLD")
locpanel:RegisterEvent("ZONE_CHANGED_INDOORS")
locpanel:RegisterEvent("ZONE_CHANGED_NEW_AREA")
locpanel:SetScript("OnEvent", OnEvent)
xcoords:SetScript("OnUpdate", xUpdate)
ycoords:SetScript("OnUpdate", yUpdate)