local D, C, L, G = unpack(select(2, ...))

if not IsAddOnLoaded("TinyDPS") or C["skins"].tinydps ~= true then return end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
	local frame = tdpsFrame
	local anchor = tdpsAnchor
	local status = tdpsStatusBar
	local tdps = tdps
	local font = tdpsFont
	local position = tdpsPosition
	local button = DuffedUIRaidUtilityShowButton

	if tdps then
		tdps.width = DuffedUIMinimap:GetWidth()
		tdps.spacing = 2
		tdps.barHeight = 16
		tdps.hideOOC = true
		tdps.showMinimapButton = false
		font.name = C["media"].font
		font.size = 12
		font.outline = "MONOCHROMEOUTLINE"
	end

	anchor:ClearAllPoints()
	anchor:SetPoint("BOTTOMLEFT", DuffedUIMinimap, "BOTTOMLEFT", 0, -26)

	frame:SetWidth(DuffedUIMinimap:GetWidth())
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(4)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	frame:CreateShadow("Default")

	position = { x = 0, y = -6 }

	if status then
		tdpsStatusBar:SetBackdrop({
			bgFile = C["media"]["normTex"],
			edgeFile = C["media"]["blank"],
			tile = false,
			tileSize = 0,
			edgeSize = 1,
			insets = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0
			}
		})
		tdpsStatusBar:SetStatusBarTexture(C["media"].normTex)
	end

	if button then
		button:HookScript("OnShow", function(self) 
			anchor:ClearAllPoints()
			anchor:Point("BOTTOMLEFT", DuffedUIMinimap, "BOTTOMLEFT", 0, -49)
		end)
		button:HookScript("OnHide", function(self) 
			anchor:ClearAllPoints()
			anchor:Point("BOTTOMLEFT", DuffedUIMinimap, "BOTTOMLEFT", 0, -26)
		end)
	end
end)