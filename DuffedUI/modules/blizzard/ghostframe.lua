local D, C, L, G = unpack(select(2, ...))

-- GhostFrame at top
GhostFrame:SetTemplate("Default")
GhostFrame:SetBackdropColor(0, 0, 0, 0)
GhostFrame:SetBackdropBorderColor(0, 0, 0, 0)
GhostFrame.SetBackdropColor = D.dummy
GhostFrame.SetBackdropBorderColor = D.dummy
GhostFrameContentsFrame:SetTemplate("Default")
GhostFrameContentsFrame:CreateShadow()
GhostFrameContentsFrameIcon:SetTexture(nil)
GhostFrameContentsFrame:Width(148)
GhostFrameContentsFrame:ClearAllPoints()
GhostFrameContentsFrame:SetPoint("CENTER")
GhostFrameContentsFrame.SetPoint = D.dummy
GhostFrame:SetFrameStrata("HIGH")
GhostFrame:SetFrameLevel(10)
GhostFrame:ClearAllPoints()
GhostFrame:Point("TOP", UIParent, 0, 26)
GhostFrameContentsFrameText:ClearAllPoints()
GhostFrameContentsFrameText:Point("BOTTOM", 0, 5)

G.Skins.GhostFrame = GhostFrame
G.Skins.GhostFrame.Content = GhostFrameContentsFrame
G.Skins.GhostFrame.Text = GhostFrameContentsFrameText