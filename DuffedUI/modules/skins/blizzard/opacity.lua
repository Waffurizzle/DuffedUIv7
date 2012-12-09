local D, C, L, G = unpack(select(2, ...))

local function LoadSkin()
	OpacityFrame:StripTextures()
	OpacityFrame:SetTemplate("Transparent")
	OpacityFrame:CreateShadow("Default")
end

tinsert(D.SkinFuncs["DuffedUI"], LoadSkin)