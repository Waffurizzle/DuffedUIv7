local D, C, L, G = unpack(select(2, ...)) 
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomLeft as bar #2
---------------------------------------------------------------------------

local bar = DuffedUIBar1
MultiBarBottomLeft:SetParent(bar)

-- setup the bar
for i=1, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton"..i-1]
	b:SetSize(D.buttonsize, D.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if C["actionbar"].layout == 2 and C["actionbar"].swap then
		if i == 1 then
			b:SetPoint("BOTTOMLEFT", bar, D.buttonspacing, D.buttonspacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", D.buttonspacing, 0)
		end
	else
		if i == 1 then
			if D.lowversion or C["actionbar"].layout == 2 then
				b:SetPoint("TOPLEFT", bar, "TOPLEFT", D.buttonspacing, -D.buttonspacing)
			else
				b:SetPoint("BOTTOMLEFT", bar, "BOTTOM", D.buttonspacing / 2, D.buttonspacing)
			end
		else
			b:SetPoint("LEFT", b2, "RIGHT", D.buttonspacing, 0)
		end
	end
	
	G.ActionBars.Bar2["Button"..i] = b
end