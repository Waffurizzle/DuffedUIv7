local D, C, L, G = unpack(select(2, ...))

-- Allow the use of color picker with DuffedUI Config.
ColorPickerFrame:SetParent(nil)
ColorPickerFrame:SetScale(C["general"].uiscale)

local function LoadSkin()
	ColorPickerFrame:SetTemplate("Transparent")
	ColorPickerFrame:CreateShadow("Default")
	ColorPickerOkayButton:SkinButton()
	ColorPickerCancelButton:SkinButton()
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:Point("RIGHT", ColorPickerCancelButton,"LEFT", -2, 0)
	ColorPickerFrameHeader:ClearAllPoints()
end

tinsert(D.SkinFuncs["DuffedUI"], LoadSkin)