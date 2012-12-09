local D, C, L, G = unpack(select(2, ...)) 
if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarLeft as bar #3 
---------------------------------------------------------------------------

if C["actionbar"].layout ~= 1 then
	local barL = DuffedUIBar2
	local barR = DuffedUIBar4
	barR:SetParent(barL)
	MultiBarBottomRight:SetParent(barL)

	for i= 1, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i-1]
		b:SetSize(D.buttonsize, D.buttonsize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)

		if i == 1 then
			b:SetPoint("TOPLEFT", barL, D.buttonspacing, -D.buttonspacing)
		elseif i == 4 then
			b:SetPoint("BOTTOMLEFT", barL, D.buttonspacing, D.buttonspacing)
		elseif i == 7 then
			b:SetPoint ("TOPLEFT", barR, D.buttonspacing, -D.buttonspacing)
		elseif i == 10 then
			b:SetPoint ("BOTTOMLEFT", barR, D.buttonspacing, D.buttonspacing)
		else
			b:SetPoint ("LEFT", b2, "RIGHT", D.buttonspacing, 0)
		end
	end
	RegisterStateDriver(barL, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
	RegisterStateDriver(barR, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
else
	local bar = DuffedUIBar2
	if C["actionbar"].swap and C["actionbar"].layout == 1 then bar = DuffedUIBar1 end
	MultiBarBottomRight:SetParent(bar)

	for i= 1, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i-1]
		b:SetSize(D.buttonsize, D.buttonsize)
		b:ClearAllPoints()
		b:SetFrameStrata("BACKGROUND")
		b:SetFrameLevel(15)
		
		if i == 1 then
			b:SetPoint("BOTTOMLEFT", bar, D.buttonspacing, D.buttonspacing)
		else
			b:SetPoint("LEFT", b2, "RIGHT", D.buttonspacing, 0)
		end
		
		G.ActionBars.Bar3["Button"..i] = b
	end
	RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end
