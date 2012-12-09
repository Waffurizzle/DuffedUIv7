-- Thanks to Azilroka :) --
local D, C, L, G = unpack(select(2, ...))
if C["auras"].buffnotice ~= true then return end

local enchants = D.remindenchants[D.myclass]
if not enchants then return end

local sound
local currentlevel = UnitLevel("player")
local class = D.myclass

local function EnchantsOnEvent(self, event)
	if (event == "PLAYER_LOGIN") or (event == "ACTIVE_TALENT_GROUP_CHANGED") or (event == "PLAYER_LEVEL_UP") then
		if class == "SHAMAN" then
			local ptt = GetSpecialization()
			if ptt and ptt == 3 and currentlevel > 53 then
				self.icon:SetTexture(select(3, GetSpellInfo(enchants[3])))
			elseif ptt and ptt == 2 and currentlevel > 31 then
				self.icon:SetTexture(select(3, GetSpellInfo(enchants[2])))
			else
				self.icon:SetTexture(select(3, GetSpellInfo(enchants[1])))
			end
			return
		end
	end

	if (class =="SHAMAN") and currentlevel < 10 then return end

	if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
		local mainhand, _, _, offhand, _, _, thrown = GetWeaponEnchantInfo()
		if class == "SHAMAN" then
			local itemid = GetInventoryItemID("player", GetInventorySlotInfo("SecondaryHandSlot"))
			if itemid and select(6, GetItemInfo(itemid)) == ENCHSLOT_WEAPON then
				if mainhand and offhand then
					self:Hide()
					sound = true
					return
				end
			elseif mainhand then
				self:Hide()
				sound = true
				return
			end
		end
		self:Show()
		if sound == true then
			if C["auras"].warning then
				PlaySoundFile(C["media"].warning)
			end
			sound = false
		end
	else
		self:Hide()
		sound = true
	end
end

local frame = CreateFrame("Frame", "DuffedUIEnchantsWarningFrame", UIParent)

frame.icon = frame:CreateTexture(nil, "OVERLAY")
frame.icon:SetPoint("CENTER")
frame:SetTemplate("Default")
frame:Size(40)
frame:Point("CENTER", UIParent, "CENTER", 0, 200)
frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
frame.icon:Size(36)
frame:Hide()

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
frame:RegisterEvent("UNIT_EXITING_VEHICLE")
frame:RegisterEvent("UNIT_EXITED_VEHICLE")

frame:SetScript("OnEvent", EnchantsOnEvent)