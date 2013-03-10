local D, C, L, G = unpack(select(2, ...)) 
if C["actionbar"].enable ~= true then return end

---------------------------------------------------------------------------
-- setup MultiBarRight as bar #4
---------------------------------------------------------------------------

local bar = DuffedUIBar3
MultiBarLeft:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarLeftButton"..i]
	local b2 = _G["MultiBarLeftButton"..i-1]
	b:SetSize(D.buttonsize, D.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("TOPLEFT", bar, D.buttonspacing, -D.buttonspacing)
	else
		b:SetPoint("TOP", b2, "BOTTOM", 0, -D.buttonspacing)
	end	
end

local bar = DuffedUIBar3
MultiBarRight:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarRightButton"..i]
	local b2 = _G["MultiBarRightButton"..i-1]
	b:SetSize(D.buttonsize, D.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("TOPRIGHT", bar, -D.buttonspacing, -D.buttonspacing)
	else
		b:SetPoint("TOP", b2, "BOTTOM", 0, -D.buttonspacing)
	end	
end
RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")

---------------
-- Mouseover --
---------------
if C["actionbar"].rightbarsmouseover ~= true then return end

-- Frame i created cause mouseover rightbars sux if it fades out when ur mouse is behind (right) of them ..
local rbmoh = CreateFrame("Frame", nil, DuffedUIBar3)
rbmoh:Point("RIGHT", UIParent, "RIGHT", 0, -14)
rbmoh:SetSize(24, (D.buttonsize * 12) + (D.buttonspacing * 13))

function DuffedUIRightBarsMouseover(alpha)
	DuffedUIBar3:SetAlpha(alpha)
	DuffedUIBar3Button2:SetAlpha(alpha)
	DuffedUIBar3Button:SetAlpha(alpha)
	MultiBarRight:SetAlpha(alpha)
	MultiBarLeft:SetAlpha(alpha)
	if C["actionbar"].petbaralwaysvisible ~= true then
		DuffedUIPetBar:SetAlpha(alpha)
		for i=1, NUM_PET_ACTION_SLOTS do
			_G["PetActionButton"..i]:SetAlpha(alpha)
		end
	end
end

local function mouseover(f)
	f:EnableMouse(true)
	f:SetAlpha(0)
	f:HookScript("OnEnter", function() DuffedUIRightBarsMouseover(1) end)
	f:HookScript("OnLeave", function() DuffedUIRightBarsMouseover(0) end)
end
mouseover(DuffedUIBar3)
mouseover(rbmoh)

for i = 1, 12 do
	_G["MultiBarRightButton"..i]:EnableMouse(true)
	_G["MultiBarRightButton"..i]:HookScript("OnEnter", function() DuffedUIRightBarsMouseover(1) end)
	_G["MultiBarRightButton"..i]:HookScript("OnLeave", function() DuffedUIRightBarsMouseover(0) end)

	_G["MultiBarLeftButton"..i]:EnableMouse(true)
	_G["MultiBarLeftButton"..i]:HookScript("OnEnter", function() DuffedUIRightBarsMouseover(1) end)
	_G["MultiBarLeftButton"..i]:HookScript("OnLeave", function() DuffedUIRightBarsMouseover(0) end)
end

if C["actionbar"].petbaralwaysvisible ~= true then
	for i = 1, NUM_PET_ACTION_SLOTS do
		_G["PetActionButton"..i]:EnableMouse(true)
		_G["PetActionButton"..i]:HookScript("OnEnter", function() DuffedUIRightBarsMouseover(1) end)
		_G["PetActionButton"..i]:HookScript("OnLeave", function() DuffedUIRightBarsMouseover(0) end)
	end
	mouseover(DuffedUIPetBar)
end