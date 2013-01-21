local D, C, L, G = unpack(select(2, ...))
if C["auras"].buffnotice ~= true then return end

local Buffs1 = D.BuffReminder1[select(2, UnitClass("player"))]
local Buffs2 = D.BuffReminder2[select(2, UnitClass("player"))]
local WeaponBuffs = D.BuffEnchants[select(2, UnitClass("player"))]
local sound

local function Buffs1OnEvent(self, event)
	if (event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB") then
		for i, buff in pairs(Buffs1) do
			local name, _, icon = GetSpellInfo(buff)
			local usable, nomana = IsUsableSpell(name)
			--print(buff, name, usable, nomana)
			if (usable or nomana) then
				self.icon:SetTexture(icon)
				break
			end
		end
		if (not self.icon:GetTexture() and event == "PLAYER_LOGIN") then
			self:UnregisterAllEvents()
			self:RegisterEvent("LEARNED_SPELL_IN_TAB")
			return
		elseif (self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB") then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("PLAYER_LOGIN")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
	end

	if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
		for i, buff in pairs(Buffs1) do
			local name = GetSpellInfo(buff)
			if (name and UnitBuff("player", name)) then
				self:Hide()
				sound = true
				return
			end
		end
		self:Show()
		if C["auras"].warning and sound == true then
			PlaySoundFile(C["media"].warning)
			sound = false
		end
	else
		self:Hide()
		sound = true
	end
end

local function Buffs2OnEvent(self, event)
	if (event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB") then
		for i, buff in pairs(Buffs2) do
			local name, _, icon = GetSpellInfo(buff)
			local usable, nomana = IsUsableSpell(name)
			--print(buff, name, usable, nomana)
			if (usable or nomana) then
				self.icon:SetTexture(icon)
				break
			end
		end
		if (not self.icon:GetTexture() and event == "PLAYER_LOGIN") then
			self:UnregisterAllEvents()
			self:RegisterEvent("LEARNED_SPELL_IN_TAB")
			return
		elseif (self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB") then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("PLAYER_LOGIN")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
	
	if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
		for i, buff in pairs(Buffs2) do
			local name = GetSpellInfo(buff)
			if (name and UnitBuff("player", name)) then
				self:Hide()
				sound = true
				return
			end
		end
		self:Show()
		if C["auras"].warning and sound == true then
			PlaySoundFile(C["media"].warning)
			sound = false
		end
	else
		self:Hide()
		sound = true
	end
end

local function WeaponBuffsOnEvent(self, event)
	if select(2, UnitClass("player")) ~= "SHAMAN" then return end
	if UnitLevel("player") < 10 then return end
	if (event == "PLAYER_LOGIN") or (event == "ACTIVE_TALENT_GROUP_CHANGED") or (event == "PLAYER_LEVEL_UP") or (event == "PLAYER_TALENT_UPDATE") then
		local ptt = GetSpecialization()
		if ptt == 3 and UnitLevel("player") > 53 then
			self.icon:SetTexture(select(3, GetSpellInfo(51730)))
		elseif ptt == 2 and UnitLevel("player") > 31 then
			self.icon:SetTexture(select(3, GetSpellInfo(8033)))
		else
			self.icon:SetTexture(select(3, GetSpellInfo(8024)))
		end
		return
	end

	if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
		local mainhand, _, _, offhand = GetWeaponEnchantInfo()
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
		self:Show()
		if C["auras"].warning and sound == true then
			PlaySoundFile(C["media"].warning)
			sound = false
		end
	else
		self:Hide()
		sound = true
	end
end

local function RegisterFrameEvents(frame)
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	frame:RegisterEvent("UNIT_EXITING_VEHICLE")
	frame:RegisterEvent("UNIT_EXITED_VEHICLE")
	frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	frame:RegisterEvent("PLAYER_TALENT_UPDATE")
end

local function CreateFrameIcon(frame)
	frame:Hide()
	frame:SetSize(40,40)
	frame:SetTemplate()
	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetPoint("CENTER")
	frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.icon:SetInside()
end

function PositionFrames()
	DuffedUIBuffs1:ClearAllPoints()
	DuffedUIBuffs2:ClearAllPoints()
	DuffedUIWeaponBuffs:ClearAllPoints()
	DuffedUIBuffsWarningFrame:SetWidth(40)
	if DuffedUIBuffs1:IsShown() then
		DuffedUIBuffs1:SetPoint("LEFT", DuffedUIBuffsWarningFrame, "LEFT", 0, 0)
	end
	if DuffedUIBuffs2:IsShown() then
		if not DuffedUIBuffs1:IsShown() then
			DuffedUIBuffs2:SetPoint("LEFT", DuffedUIBuffsWarningFrame, "LEFT", 0, 0)
		else
			DuffedUIBuffs2:SetPoint("LEFT", DuffedUIBuffs1, "RIGHT", 8, 0)
			DuffedUIBuffsWarningFrame:SetWidth(88)
		end
	end
	if DuffedUIWeaponBuffs:IsShown() then
		if not DuffedUIBuffs2:IsShown() then
			if not DuffedUIBuffs1:IsShown() then
				DuffedUIWeaponBuffs:SetPoint("LEFT", DuffedUIBuffsWarningFrame, "LEFT", 0, 0)
			else
				DuffedUIWeaponBuffs:SetPoint("LEFT", DuffedUIBuffs1, "RIGHT", 8, 0)
				DuffedUIBuffsWarningFrame:SetWidth(88)
			end
		else
			DuffedUIWeaponBuffs:SetPoint("LEFT", DuffedUIBuffs2, "RIGHT", 8, 0)
			DuffedUIBuffsWarningFrame:SetWidth(136)
		end
	end
	DuffedUIBuffsWarningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
end

DuffedUIBuffsWarningFrame = CreateFrame("Frame", "DuffedUIBuffsWarningFrame", UIParent)
DuffedUIBuffsWarningFrame:SetSize(40,40)
DuffedUIBuffsWarningFrame:SetScript("OnUpdate", PositionFrames)

local DuffedUIBuffs1 = CreateFrame("Frame", "DuffedUIBuffs1", DuffedUIBuffsWarningFrame)
RegisterFrameEvents(DuffedUIBuffs1)
CreateFrameIcon(DuffedUIBuffs1)
DuffedUIBuffs1:SetScript("OnEvent", Buffs1OnEvent)

local DuffedUIBuffs2 = CreateFrame("Frame", "DuffedUIBuffs2", DuffedUIBuffsWarningFrame)
RegisterFrameEvents(DuffedUIBuffs2)
CreateFrameIcon(DuffedUIBuffs2)
DuffedUIBuffs2:SetScript("OnEvent", Buffs2OnEvent)

local DuffedUIWeaponBuffs = CreateFrame("Frame", "DuffedUIWeaponBuffs", DuffedUIBuffsWarningFrame)
RegisterFrameEvents(DuffedUIWeaponBuffs)
CreateFrameIcon(DuffedUIWeaponBuffs)
DuffedUIWeaponBuffs:SetScript("OnEvent", WeaponBuffsOnEvent)

--[[local Buffs1 = D.BuffReminder1[select(2, UnitClass("player"))]
local Buffs2 = D.BuffReminder2[select(2, UnitClass("player"))]
local WeaponBuffs = D.BuffEnchants[select(2, UnitClass("player"))]
local sound

local function Buffs1OnEvent(self, event)
	if (event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB") then
		for i, buff in pairs(Buffs1) do
			local name, _, icon = GetSpellInfo(buff)
			local usable, nomana = IsUsableSpell(name)
			if (usable or nomana) then
				self.icon:SetTexture(icon)
				break
			end
		end
		if (not self.icon:GetTexture() and event == "PLAYER_LOGIN") then
			self:UnregisterAllEvents()
			self:RegisterEvent("LEARNED_SPELL_IN_TAB")
			return
		elseif (self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB") then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("PLAYER_LOGIN")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
	end

	if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
		for i, buff in pairs(Buffs1) do
			local name = GetSpellInfo(buff)
			if (name and UnitBuff("player", name)) then
				self:Hide()
				sound = true
				return
			end
		end
		self:Show()
		if C["auras"].warning and sound == true then
			PlaySoundFile(C["media"].warning)
			sound = false
		end
	else
		self:Hide()
		sound = true
	end
end

local function Buffs2OnEvent(self, event)
	if (event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB") then
		for i, buff in pairs(Buffs2) do
			local name, _, icon = GetSpellInfo(buff)
			local usable, nomana = IsUsableSpell(name)
			if (usable or nomana) then
				self.icon:SetTexture(icon)
				break
			end
		end
		if (not self.icon:GetTexture() and event == "PLAYER_LOGIN") then
			self:UnregisterAllEvents()
			self:RegisterEvent("LEARNED_SPELL_IN_TAB")
			return
		elseif (self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB") then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("PLAYER_LOGIN")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
	
	if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
		for i, buff in pairs(Buffs2) do
			local name = GetSpellInfo(buff)
			if (name and UnitBuff("player", name)) then
				self:Hide()
				sound = true
				return
			end
		end
		self:Show()
		if C["auras"].warning and sound == true then
			PlaySoundFile(C["media"].warning)
			sound = false
		end
	else
		self:Hide()
		sound = true
	end
end

local function WeaponBuffsOnEvent(self, event)
	if UnitClass("player") ~= "SHAMAN" then return end
	if UnitLevel("player") < 10 then return end
	if (event == "PLAYER_LOGIN") or (event == "ACTIVE_TALENT_GROUP_CHANGED") or (event == "PLAYER_LEVEL_UP") then
		if class == "SHAMAN" then
			local ptt = GetSpecialization()
			if ptt == 3 and currentlevel > 53 then
				self.icon:SetTexture(GetSpellTexture(GetSpellInfo(51370)))
			elseif ptt == 2 and currentlevel > 31 then
				self.icon:SetTexture(GetSpellTexture(GetSpellInfo(8232)))
			else
				self.icon:SetTexture(GetSpellTexture(GetSpellInfo(8024)))
			end
			return
		end
	end

	if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
		if UnitClass("player") ~= "SHAMAN" then return end
		if UnitLevel("player") < 10 then return end
		local mainhand, _, _, offhand = GetWeaponEnchantInfo()
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
		self:Show()
		if C["auras"].warning and sound == true then
			PlaySoundFile(C["media"].warning)
			sound = false
		end
	else
		self:Hide()
		sound = true
	end
end

local function RegisterFrameEvents(frame)
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	frame:RegisterEvent("UNIT_EXITING_VEHICLE")
	frame:RegisterEvent("UNIT_EXITED_VEHICLE")
end

local function CreateFrameIcon(frame)
	frame:Hide()
	frame:SetSize(40,40)
	frame:SetTemplate()
	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetPoint("CENTER")
	frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.icon:SetInside()
end

function PositionFrames()
	DuffedUIBuffs1:ClearAllPoints()
	DuffedUIBuffs2:ClearAllPoints()
	DuffedUIWeaponBuffs:ClearAllPoints()
	if DuffedUIBuffs1:IsShown() then
		DuffedUIBuffs1:SetPoint("LEFT", DuffedUIBuffsWarningFrame, "LEFT", 0, 0)
	end
	if DuffedUIBuffs2:IsShown() then
		if not DuffedUIBuffs1:IsShown() then
			DuffedUIBuffs2:SetPoint("LEFT", DuffedUIBuffsWarningFrame, "LEFT", 0, 0)
		else
			DuffedUIBuffs2:SetPoint("LEFT", DuffedUIBuffs1, "RIGHT", 8, 0)
			DuffedUIBuffsWarningFrame:SetWidth(88)
		end
	end
	if DuffedUIWeaponBuffs:IsShown() then
		if not DuffedUIBuffs2:IsShown() then
			DuffedUIWeaponBuffs:SetPoint("LEFT", DuffedUIBuffs1, "RIGHT", 8, 0)
			DuffedUIBuffsWarningFrame:SetWidth(88)
		else
			DuffedUIWeaponBuffs:SetPoint("LEFT", DuffedUIBuffs2, "RIGHT", 8, 0)
			DuffedUIBuffsWarningFrame:SetWidth(136)
		end
	end
	DuffedUIBuffsWarningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
end

DuffedUIBuffsWarningFrame = CreateFrame("Frame", "DuffedUIBuffsWarningFrame", UIParent)
DuffedUIBuffsWarningFrame:SetSize(40,40)
DuffedUIBuffsWarningFrame:SetScript("OnUpdate", PositionFrames)

local DuffedUIBuffs1 = CreateFrame("Frame", "DuffedUIBuffs1", DuffedUIBuffsWarningFrame)
RegisterFrameEvents(DuffedUIBuffs1)
CreateFrameIcon(DuffedUIBuffs1)
DuffedUIBuffs1:SetScript("OnEvent", Buffs1OnEvent)

local DuffedUIBuffs2 = CreateFrame("Frame", "DuffedUIBuffs2", DuffedUIBuffsWarningFrame)
RegisterFrameEvents(DuffedUIBuffs2)
CreateFrameIcon(DuffedUIBuffs2)
DuffedUIBuffs2:SetScript("OnEvent", Buffs2OnEvent)

local DuffedUIWeaponBuffs = CreateFrame("Frame", "DuffedUIWeaponBuffs", DuffedUIBuffsWarningFrame)
RegisterFrameEvents(DuffedUIWeaponBuffs)
CreateFrameIcon(DuffedUIWeaponBuffs)
DuffedUIWeaponBuffs:SetScript("OnEvent", WeaponBuffsOnEvent)]]--