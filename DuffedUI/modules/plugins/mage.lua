if (select(2, UnitClass("player")) ~= "MAGE") or not DuffedUIMinimapStatsLeft then return end
local D, C, L, G = unpack(select(2, ...))

local spells = (UnitFactionGroup("player") == "Horde") and {
	--  Tepelort id, Portal id
	[1] = {53140,53142}, -- Dalaran
	[2] = {3567,11417}, -- Orgrimmar
	[3] = {3563,11418}, -- Undercity
	[4] = {3566,11420}, -- Thunder Bluff
	[5] = {32272,32267}, -- Silvermoon
	[6] = {35715,35717}, -- Shattrath
	[7] = {49358,49361}, -- Stonard
	[8] = {88342,88345}, -- Tol Barad
	[9] = {132627,132626}, -- Vale of Eternal Blossoms
} or { -- ALLIANCE
	[1] = {53140,53142}, -- Dalaran
	[2] = {3561,10059}, -- Stormwind
	[3] = {3562,11416}, -- Ironforge
	[4] = {3565,11419}, -- Darnassus
	[5] = {32271,32266}, -- Exodar
	[6] = {33690,33691}, -- Shattrath
	[7] = {49359,49360}, -- Theramore
	[8] = {88342,88345}, -- Tol Barad
	[9] = {132621,132620}, -- Vale of Eternal Blossoms
};

local abbrev = function(name)
	local newname = (string.len(name) > 12) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return D.UTF(newname, 12, false)
end
 
local f = CreateFrame("Frame", "DuffedUITeleportMenu", UIParent)
f:Size(DuffedUIMinimap:GetWidth(),(#spells + 1) * 21 + 3)
f:SetPoint("TOPLEFT", DuffedUIMinimapStatsLeft, "BOTTOMLEFT", 0, -3)
f:SetFrameStrata("HIGH")
f:CreateShadow("Default")
f:SetTemplate("Transparent")
f:CreateBackdrop()
 
local r = CreateFrame("Frame", nil, f)
r:Size(DuffedUIMinimap:GetWidth() - 4, 20)
r:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
local l = r:CreateFontString("Title", "OVERLAY")
l:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
l:SetPoint("CENTER", r, "CENTER")
r:SetFrameStrata("HIGH")
 
for i, spell in pairs(spells) do
	local b = CreateFrame("Button", nil, f, "SecureActionButtonTemplate")
	b:Size(DuffedUIMinimap:GetWidth() - 4, 20)
	b:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -(i * 21) - 2)
	b:SetFrameStrata("HIGH")
	b:SetTemplate("Transparent")
	b:CreateBackdrop()
 
	local l = b:CreateFontString(nil,"OVERLAY")
	l:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")
	l:SetText(abbrev(GetSpellInfo(spell[1])))
	b:SetFontString(l)
 
	b:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	b:SetAttribute("type1", "spell")
	b:SetAttribute("spell1", GetSpellInfo(spell[1]))
	b:SetAttribute("type2", "spell")
	b:SetAttribute("spell2", GetSpellInfo(spell[2]))
	
	b:HookScript("OnEnter", function(self)
		local r,g,b = unpack(C["media"].datatextcolor1)
		self:SetBackdropColor(r,g,b, 0.15)
		self:SetBackdropBorderColor(r,g,b)
	end)

	b:HookScript("OnLeave", function(self)
		self:SetBackdropColor(unpack(C["media"].backdropcolor))
		self:SetBackdropBorderColor(unpack(C["media"].bordercolor))
	end)
end
f:Hide()
 
local b = CreateFrame("Button", nil, DuffedUIMinimapStatsLeft)
b:SetAllPoints(DuffedUIMinimapStatsLeft)
b:SetScript("OnClick", function(self)
	if DuffedUITeleportMenu:IsShown() then
		DuffedUITeleportMenu:Hide()
	else
		Title:SetText(D.panelcolor.."Portal / Teleportlist")
		DuffedUITeleportMenu:Show()
	end
end)
 
f:RegisterEvent("UNIT_SPELLCAST_START")
f:SetScript("OnEvent",
	function(self)
	if self:IsShown() then
		self:Hide()
	end
end)