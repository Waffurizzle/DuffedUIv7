local D, C, L, G = unpack(select(2, ...))

local function LoadSkin()
	ItemTextFrame:StripTextures(true)
	ItemTextFrameInset:StripTextures()
	ItemTextScrollFrame:StripTextures()
	ItemTextFrame:SetTemplate("Transparent")
	ItemTextFrame:CreateShadow("Default")
	ItemTextScrollFrameScrollBar:SkinScrollBar()
	ItemTextFrameCloseButton:SkinCloseButton()
	ItemTextPrevPageButton:SkinNextPrevButton()
	ItemTextNextPageButton:SkinNextPrevButton()
	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = D.dummy
end

tinsert(D.SkinFuncs["DuffedUI"], LoadSkin)