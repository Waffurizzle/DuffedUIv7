local D, C, L, G = unpack(select(2, ...))

-- not fully tested, only tested via: /script LoadAddOn("Blizzard_ItemUpgradeUI") ShowUIPanel(ItemUpgradeFrame)

local function LoadSkin()
	ItemUpgradeFrame:StripTextures()
	ItemUpgradeFrame:SetTemplate("Transparent")
	ItemUpgradeFrame:CreateShadow("Default")
	ItemUpgradeFrameCloseButton:SkinCloseButton()
	
	ItemUpgradeFrame.ItemButton:StripTextures()
	ItemUpgradeFrame.ItemButton:SetTemplate()
	ItemUpgradeFrame.ItemButton:StyleButton()
	ItemUpgradeFrame.ItemButton.IconTexture:ClearAllPoints()
	ItemUpgradeFrame.ItemButton.IconTexture:Point("TOPLEFT", 2, -2)
	ItemUpgradeFrame.ItemButton.IconTexture:Point("BOTTOMRIGHT", -2, 2)

	hooksecurefunc("ItemUpgradeFrame_Update", function()
		if GetItemUpgradeItemInfo() then
			ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(1)
			ItemUpgradeFrame.ItemButton.IconTexture:SetTexCoord(.1,.9,.1,.9)
		else
			ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(0)
		end
	end)

	ItemUpgradeFrameMoneyFrame:StripTextures()
	ItemUpgradeFrameUpgradeButton:StripTextures()
	ItemUpgradeFrameUpgradeButton:SkinButton()
	ItemUpgradeFrame.FinishedGlow:Kill()
	ItemUpgradeFrame.ButtonFrame:DisableDrawLayer("BORDER")
end

D.SkinFuncs["Blizzard_ItemUpgradeUI"] = LoadSkin