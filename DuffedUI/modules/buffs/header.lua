local D, C, L, G = unpack(select(2, ...))

if not C["auras"].player then return end

local frame = DuffedUIAuras
local content = DuffedUIAuras.content

for _, frame in next, {
	"DuffedUIAurasPlayerBuffs",
	"DuffedUIAurasPlayerDebuffs",
	"DuffedUIAurasPlayerConsolidate",
} do
	local header
	
	local wrap
	if D.lowversion then
		wrap = 8
	else
		wrap = C["auras"].wrap
	end
	
	if frame == "DuffedUIAurasPlayerConsolidate" then
		header = CreateFrame("Frame", frame, DuffedUIPetBattleHider, "SecureFrameTemplate")
		header:SetAttribute("wrapAfter", 1)
		header:SetAttribute("wrapYOffset", -35)
	else
		header = CreateFrame("Frame", frame, DuffedUIPetBattleHider, "SecureAuraHeaderTemplate")
		header:SetClampedToScreen(true)
		header:SetMovable(true)
		header:SetAttribute("minHeight", 30)
		header:SetAttribute("wrapAfter", wrap)
		header:SetAttribute("wrapYOffset", -50)
		header:SetAttribute("xOffset", -35)
		header:CreateBackdrop()
		header.backdrop:SetBackdropBorderColor(1, 0, 0)
		header.backdrop:FontString("text", C["media"].uffont, 12)
		header.backdrop.text:SetPoint("CENTER")
		header.backdrop.text:SetText(L.move_buffs)
		header.backdrop:SetAlpha(0)
	end
	header:SetAttribute("minWidth", wrap * 35)
	header:SetAttribute("template", "DuffedUIAurasAuraTemplate")
	header:SetAttribute("weaponTemplate", "DuffedUIAurasAuraTemplate")
	header:SetSize(30, 30)

	-- Swap the unit to vehicle when we enter a vehicle *gasp*.
	RegisterAttributeDriver(header, "unit", "[vehicleui] vehicle; player")

	table.insert(content, header)
end

local buffs = DuffedUIAurasPlayerBuffs
G.Auras.Buffs = buffs
local debuffs = DuffedUIAurasPlayerDebuffs
G.Auras.Debuffs = Debuffs
local consolidate = DuffedUIAurasPlayerConsolidate
G.Auras.Consolidate = consolidate

local filter = 0
if C["auras"].consolidate then
	filter = 1
end

-- set our buff header
if C["misc"].exp_rep == false then
	buffs:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -17, 2)
else
	buffs:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -7, 2)
end
buffs:SetAttribute("filter", "HELPFUL")
buffs:SetAttribute("consolidateProxy", CreateFrame("Frame", buffs:GetName() .. "ProxyButton", buffs, "DuffedUIAurasProxyTemplate"))
buffs:SetAttribute("consolidateHeader", consolidate)
buffs:SetAttribute("consolidateTo", filter)
buffs:SetAttribute("includeWeapons", 1)
buffs:SetAttribute("consolidateDuration", -1)
buffs:Show()
tinsert(D.AllowFrameMoving, DuffedUIAurasPlayerBuffs)

-- create the consolidated button
local proxy = buffs:GetAttribute("consolidateProxy")
proxy:HookScript("OnShow", function(self) if consolidate:IsShown() then consolidate:Hide() end end) -- kind of bug fix for secure aura header

-- create the dropdown and register click
local dropdown = CreateFrame("BUTTON", "DuffedUIAurasPlayerConsolidateDropdownButton", proxy, "SecureHandlerClickTemplate")
dropdown:SetAllPoints()
dropdown:RegisterForClicks("AnyUp")
dropdown:SetAttribute("_onclick", [=[
	local header = self:GetParent():GetFrameRef"header"

	local numChild = 0
	repeat
		numChild = numChild + 1
		local child = header:GetFrameRef("child" .. numChild)
	until not child or not child:IsShown()

	numChild = numChild - 1

	-- needed, else the dropdown is not positionned correctly on opening
	local x, y = self:GetWidth(), self:GetHeight()
	header:SetWidth(x)
	header:SetHeight(y)
	
	if header:IsShown() then
		header:Hide()
	else
		header:Show()
	end
]=]);

-- set our consolidate header
consolidate:SetAttribute("point", "RIGHT")
consolidate:SetAttribute("minHeight", nil)
consolidate:SetAttribute("minWidth", nil)
consolidate:SetParent(proxy)
consolidate:ClearAllPoints()
consolidate:SetPoint("CENTER", proxy, "CENTER", 0, -35)
consolidate:Hide()
SecureHandlerSetFrameRef(proxy, "header", consolidate)

-- set our debuff header
if C["misc"].exp_rep == false then
	debuffs:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -17, -5)
else
	debuffs:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -7, -5)
end
debuffs:SetAttribute("filter", "HARMFUL")
debuffs:Show()
tinsert(D.AllowFrameMoving, DuffedUIAurasPlayerDebuffs)