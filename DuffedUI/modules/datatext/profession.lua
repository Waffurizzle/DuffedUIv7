local D, C, L, G = unpack(select(2, ...))

if not C["datatext"].profession or C["datatext"].profession == 0 then return end

local Stat = CreateFrame("Frame", "DuffedUIStatProfession")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)
	
local Text = Stat:CreateFontString("DuffedUIStatProfessionText", "OVERLAY")
Text:SetFont(C["media"].font, C["datatext"].fontsize)
D.DataTextPosition(C["datatext"].profession, Text)

local function Update(self)
	for _, v in pairs({GetProfessions()}) do
		if v ~= nil then
			local name, texture, rank, maxRank = GetProfessionInfo(v)
			Text:SetFormattedText(D.panelcolor.."Profession")
		end
	end
	self:SetAllPoints(Text)
end

Stat:SetScript("OnEnter", function()
	local anchor, panel, xoff, yoff = D.DataTextTooltipAnchor(Text)
	GameTooltip:SetOwner(panel, anchor, xoff, yoff)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(D.myname.."'s Professions", .4,.78,1)
	for _, v in pairs({GetProfessions()}) do
		if v ~= nil then
			local name, texture, rank, maxRank = GetProfessionInfo(v)
			GameTooltip:AddDoubleLine(name, rank.." / "..maxRank,.75,.9,1,.3,1,.3)
		end
	end
	GameTooltip:Show()
end)
Stat:SetScript("OnUpdate", Update)
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)

Stat:SetScript('OnMouseDown', function(self, btn)
	if btn == 'LeftButton' then
		ToggleSpellBook("professions")
	end
end)