local D, C, L, G = unpack(select(2, ...))
if not C["misc"].ilvlcharacter then return end

local time = 3
local slots = {
	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"ShirtSlot",
	"TabardSlot",
	"WristSlot",
	"MainHandSlot",
	"SecondaryHandSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot"
}

local upgrades = {
	["0"] = 0, ["1"] = 8, ["373"] = 4, ["374"] = 8, ["375"] = 4, ["376"] = 4,
	["377"] = 4, ["379"] = 4, ["380"] = 4, ["445"] = 0, ["446"] = 4, ["447"] = 8,
	["451"] = 0, ["452"] = 8, ["453"] = 0, ["454"] = 4, ["455"] = 8, ["456"] = 0,
	["457"] = 8, ["458"] = 0, ["459"] = 4, ["460"] = 8, ["461"] = 12, ["462"] = 16,
	["465"] = 0, ["466"] = 4, ["467"] = 8, ["470"] = 8, ["476"] = 0, ["479"] = 0,
}

local iEqAvg, iAvg

local function CreateButtonsText(frame)
	for _, slot in pairs(slots) do
		local button = _G[frame .. slot]

		button.text = button:CreateFontString(nil, "ARTWORK")
		button.text:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")

		if slot == "HeadSlot" or slot == "NeckSlot" or slot == "ShoulderSlot" or slot == "BackSlot" or slot == "ChestSlot" or slot == "WristSlot" or slot == "ShirtSlot" or slot == "TabardSlot" then
			button.text:SetPoint("CENTER", button, "CENTER", 42, 0)
		elseif slot == "HandsSlot" or slot == "WaistSlot" or slot == "LegsSlot" or slot == "FeetSlot" or slot == "Finger0Slot" or slot == "Finger1Slot" or slot == "Trinket0Slot" or slot == "Trinket1Slot" then
			button.text:SetPoint("CENTER", button, "CENTER", -42, 0)
		elseif slot == "MainHandSlot" or slot == "SecondaryHandSlot" or slot == "RangedSlot" then
			button.text:SetPoint("CENTER", button, "CENTER", 0, 42)
		end

		button.text:SetText("")
	end
end

local function UpdateButtonsText(frame)
	if frame == "Inspect" and not InspectFrame:IsShown() then return end

	for _, slot in pairs(slots) do
		local id = GetInventorySlotInfo(slot)
		local item
		local text = _G[frame .. slot].text

		if frame == "Inspect" then
			item = GetInventoryItemLink("target", id)
		else
			item = GetInventoryItemLink("player", id)
		end

		if slot == "ShirtSlot" or slot == "TabardSlot" then
			text:SetText("")
		elseif item then
			local oldilevel = text:GetText()
			local ilevel = select(4, GetItemInfo(item))
			local heirloom = select(3, GetItemInfo(item))
			local upgrade = item:match(":(%d+)\124h%[")

			if ilevel then
				if ilevel ~= oldilevel then
					if heirloom == 7 then
						text:SetText("")
					else
						if frame ~= "Inspect" then
							local itemDurability, itemMaxDurability = GetInventoryItemDurability(id)
							local ilevelcolor, duracolor
							iEqAvg, iAvg = GetAverageItemLevel()

							if ilevel <= (floor(iEqAvg) - 10) then
								ilevelcolor = "|cFFFF0000"
							elseif ilevel >= (floor(iEqAvg) + 10) then
								ilevelcolor = "|cFF00FF00"
							else
								ilevelcolor = "|cFFFFFFFF"
							end

							if itemDurability then
								local itemDurabilityPercentage = (itemDurability / itemMaxDurability) * 100

								if itemDurabilityPercentage > 25 then
									duracolor = "|cFF00FF00"
								elseif itemDurabilityPercentage > 0 and itemDurabilityPercentage <= 25 then
									duracolor = "|cFFFFFF00"
								elseif itemDurabilityPercentage == 0 then
									duracolor = "|cFFFF0000"
								end

								text:SetText(ilevelcolor..ilevel + upgrades[upgrade].."\n"..duracolor..D.Round(itemDurabilityPercentage).."%|r")
							else
								text:SetText(ilevelcolor..ilevel + upgrades[upgrade])
							end
						else
							text:SetText(ilevel + upgrades[upgrade])
						end
					end
				end
			else
				text:SetText("")
			end
		else
			text:SetText("")
		end
	end
end

local OnEvent = CreateFrame("Frame")
OnEvent:RegisterEvent("PLAYER_LOGIN")
OnEvent:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
OnEvent:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN"  then
		CreateButtonsText("Character")
		UpdateButtonsText("Character")
		self:UnregisterEvent("PLAYER_LOGIN")
	elseif event == "PLAYER_TARGET_CHANGED" or event == "INSPECT_READY"  then
		UpdateButtonsText("Inspect")
	else
		UpdateButtonsText("Character")
	end
end)

OnEvent:SetScript("OnUpdate", function(self, elapsed)
	time = time + elapsed
	if time >= 3 then
		if InspectFrame and InspectFrame:IsShown() then
			UpdateButtonsText("Inspect")
		else
			UpdateButtonsText("Character")
		end
	end
end)

local OnLoad = CreateFrame("Frame")
OnLoad:RegisterEvent("ADDON_LOADED")
OnLoad:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_InspectUI" then
		CreateButtonsText("Inspect")
		InspectFrame:HookScript("OnShow", function(self)
			UpdateButtonsText("Inspect")
		end)

		OnEvent:RegisterEvent("PLAYER_TARGET_CHANGED")
		OnEvent:RegisterEvent("INSPECT_READY")

		self:UnregisterEvent("ADDON_LOADED")
	end
end)