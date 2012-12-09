local D, C, L, G = unpack(select(2, ...))

local function LoadSkin()
	DressUpFrame:StripTextures(true)
	DressUpFrame:CreateBackdrop("Transparent")
	DressUpFrame.backdrop:CreateShadow("Default")
	DressUpFrame.backdrop:Point("TOPLEFT", 6, 0)
	DressUpFrame.backdrop:Point("BOTTOMRIGHT", -32, 70)

	DressUpFrameResetButton:SkinButton()
	DressUpFrameCancelButton:SkinButton()
	DressUpFrameCloseButton:SkinCloseButton(DressUpFrame.backdrop)
	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -2, 0)
end

tinsert(D.SkinFuncs["DuffedUI"], LoadSkin)