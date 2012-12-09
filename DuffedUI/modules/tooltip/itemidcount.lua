local D, C, L, G = unpack(select(2, ...)) 
if C["tooltip"].enable ~= true then return end

local function ClearItemID(self)
	self.DuffedUIItemTooltip = nil
end
D.ClearTooltipItemID = ClearItemID

local function ShowItemID(self)
	if (IsShiftKeyDown() or IsAltKeyDown()) and (DuffedUIItemTooltip and not self.DuffedUIItemTooltip and (DuffedUIItemTooltip.id or DuffedUIItemTooltip.count)) then
		local item, link = self:GetItem()
		local num = GetItemCount(link)
		local left = ""
		local right = ""
		
		if DuffedUIItemTooltip.id and link ~= nil then
			left = "|cFFCA3C3CID|r "..link:match(":(%w+)")
		end
		
		if DuffedUIItemTooltip.count and num > 1 then
			right = "|cFFCA3C3C"..L.tooltip_count.."|r "..num
		end
				
		self:AddLine(" ")
		self:AddDoubleLine(left, right)
		self.DuffedUIItemTooltip = 1
	end
end
D.ShowTooltipItemID = ShowItemID

GameTooltip:HookScript("OnTooltipCleared", ClearItemID)
GameTooltip:HookScript("OnTooltipSetItem", ShowItemID)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
	if name ~= "DuffedUI" then return end
	f:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
	DuffedUIItemTooltip = DuffedUIItemTooltip or {count = true, id = true}
end)