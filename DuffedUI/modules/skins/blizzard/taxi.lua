local D, C, L, G = unpack(select(2, ...))

local function LoadSkin()
	TaxiFrame:StripTextures()
	TaxiFrame.TitleText:SetAlpha(0)
	TaxiRouteMap:CreateBackdrop("Transparent")
	TaxiRouteMap.backdrop:CreateShadow("Default")
	TaxiFrame.CloseButton:SkinCloseButton()
	TaxiFrame.CloseButton:ClearAllPoints()
	TaxiFrame.CloseButton:SetPoint("TOPRIGHT", 0, -20)
end

tinsert(D.SkinFuncs["DuffedUI"], LoadSkin)