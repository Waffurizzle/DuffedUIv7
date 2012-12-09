local D, C, L, G = unpack(select(2, ...))

local function LoadSkin()
	TutorialFrame:StripTextures()
	TutorialFrame:CreateBackdrop("Transparent")
	TutorialFrame.backdrop:CreateShadow("Default")
	TutorialFrame.backdrop:Point("TOPLEFT", 6, 0)
	TutorialFrame.backdrop:Point("BOTTOMRIGHT", 6, -6)
	TutorialFrameCloseButton:SkinCloseButton(TutorialFrameCloseButton.backdrop)
	TutorialFramePrevButton:SkinNextPrevButton()
	TutorialFrameNextButton:SkinNextPrevButton()
	TutorialFrameOkayButton:SkinButton()
	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:Point("LEFT", TutorialFrameNextButton,"RIGHT", 10, 0)	
end

tinsert(D.SkinFuncs["DuffedUI"], LoadSkin)