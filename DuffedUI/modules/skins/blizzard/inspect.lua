local D, C, L, G = unpack(select(2, ...))

local function LoadSkin()
	InspectFrame:StripTextures(true)
	InspectFrameInset:StripTextures(true)
	InspectFrame:CreateBackdrop("Transparent")
	InspectFrame.backdrop:CreateShadow("Default")
	InspectFrame.backdrop:SetAllPoints()
	InspectFrameCloseButton:SkinCloseButton()
	
	for i=1, 4 do
		_G["InspectFrameTab"..i]:SkinTab()
	end
	
	InspectModelFrameBorderTopLeft:Kill()
	InspectModelFrameBorderTopRight:Kill()
	InspectModelFrameBorderTop:Kill()
	InspectModelFrameBorderLeft:Kill()
	InspectModelFrameBorderRight:Kill()
	InspectModelFrameBorderBottomLeft:Kill()
	InspectModelFrameBorderBottomRight:Kill()
	InspectModelFrameBorderBottom:Kill()
	InspectModelFrameBorderBottom2:Kill()
	InspectModelFrameBackgroundOverlay:Kill()
	InspectModelFrame:CreateBackdrop("Default")
	
		local slots = {
			"HeadSlot",
			"NeckSlot",
			"ShoulderSlot",
			"BackSlot",
			"ChestSlot",
			"ShirtSlot",
			"TabardSlot",
			"WristSlot",
			"HandsSlot",
			"WaistSlot",
			"LegsSlot",
			"FeetSlot",
			"Finger0Slot",
			"Finger1Slot",
			"Trinket0Slot",
			"Trinket1Slot",
			"MainHandSlot",
			"SecondaryHandSlot",
		}
		for _, slot in pairs(slots) do
			local icon = _G["Inspect"..slot.."IconTexture"]
			local slot = _G["Inspect"..slot]
			slot:StripTextures()
			slot:StyleButton(false)
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:Point("TOPLEFT", 2, -2)
			icon:Point("BOTTOMRIGHT", -2, 2)
			
			slot:SetFrameLevel(slot:GetFrameLevel() + 2)
			slot:CreateBackdrop("Default")
			slot.backdrop:SetAllPoints()
		end		
	
	InspectPVPFrameBottom:Kill()
	InspectGuildFrameBG:Kill()
	InspectPVPFrame:HookScript("OnShow", function() InspectPVPFrameBG:Kill() end)
	
	for i=1, 3 do
		_G["InspectPVPTeam"..i]:StripTextures()
	end
	
	InspectTalentFrame:StripTextures()

	-- a request to color item by rarity on inspect frame. 
	local CheckItemBorderColor = CreateFrame("Frame") 
	local _MISSING = {} 
	local time = 3 

	local function ColorItemBorder_OnUpdate(self, elapsed) 
	   local found 
	   time = time + elapsed 
	   if (time >3) then 
	       if (not UnitIsPlayer("target")) then 
	         table.wipe(_MISSING) 
	         self:SetScript("OnUpdate", nil) 
	      end 
	      for i, slot in pairs(_MISSING) do 
	         local target = _G["Inspect"..slot] 
	         local slotId, _, _ = GetInventorySlotInfo(slot) 
	         local itemLink = GetInventoryItemLink("target", slotId) 
	         if itemLink then 
	            local rarity= select(3, GetItemInfo(itemLink)) 
	            if rarity then 
	               target.backdrop:SetBackdropBorderColor(GetItemQualityColor(rarity)) 
	            end 
	            _MISSING[i] = nil 
	         end 
	         found = true 
	      end 
	   end 
	   if (not found) then 
	      self:SetScript("OnUpdate", nil) 
	   end 
	end 

	local function ColorItemBorder() 
	   if (not InspectFrame:IsShown()) then return end 
	   for i, slot in pairs(slots) do 
	      -- Colour the equipment slots by rarity 
	      local target = _G["Inspect"..slot] 
	      local slotId, _, _ = GetInventorySlotInfo(slot) 
	      local itemLink = GetInventoryItemLink("target", slotId) 
	      local itemTexture = GetInventoryItemTexture("target", slotId) 

	      if itemLink then 
	         local rarity= select(3, GetItemInfo(itemLink)) 
	         if rarity then 
	            target.backdrop:SetBackdropBorderColor(GetItemQualityColor(rarity)) 
	         end 
	      elseif itemTexture then 
	         _MISSING[i] = slot 
	         CheckItemBorderColor:SetScript("OnUpdate", ColorItemBorder_OnUpdate) 
	      else 
	         target.backdrop:SetBackdropBorderColor(unpack(C.media.bordercolor)) 
	      end 
	   end 
	end 

	-- execute item coloring everytime we open inspect frame 
	InspectFrame:HookScript("OnShow", ColorItemBorder) 

	-- execute item coloring everytime an item is changed 
	CheckItemBorderColor:RegisterEvent("PLAYER_TARGET_CHANGED") 
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)
end

D.SkinFuncs["Blizzard_InspectUI"] = LoadSkin