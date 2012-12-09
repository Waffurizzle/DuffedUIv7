local D, C, L, G = unpack(select(2, ...))

if C["icd"].enable ~= true then return end

D.ignoredspells = {
	--GetSpellInfo(779),	-- Swipe
	--GetSpellInfo(6807),	-- Maul
}
	
local noscalemult = D.mult * C["general"].uiscale
local fadeInTime, fadeOutTime, maxAlpha, animScale, iconSize, holdTime, threshold
local cooldowns, animating, watching = {}, {}, {}
local GetTime = GetTime

local dicdAnchor = CreateFrame("Frame", "dicdAnchor", UIParent)
dicdAnchor:SetWidth(45)
dicdAnchor:SetHeight(45)
dicdAnchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

local dicd = CreateFrame("Frame")
dicd:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
dicd:SetBackdrop({
	bgFile = C["media"].blank,
	edgeFile = C["media"].blank,
	tile = false, tileSize = 0, edgeSize = noscalemult,
	insets = {left = -noscalemult, right = -noscalemult, top = -noscalemult, bottom = -noscalemult}
})
dicd:SetBackdropBorderColor(unpack(C["media"].bordercolor))
dicd:SetBackdropColor(unpack(C["media"].backdropcolor))

local dicdT = dicd:CreateTexture(nil, "ARTWORK")
dicdT:SetTexCoord(0.1, 0.9, 0.1, 0.9)
dicdT:SetPoint("TOPLEFT", dicd, "TOPLEFT", noscalemult * 2, -noscalemult * 2)
dicdT:SetPoint("BOTTOMRIGHT", dicd, "BOTTOMRIGHT", -noscalemult * 2, noscalemult * 2)

-- Utility Functions
local function tcount(tab)
	local n = 0
	for _ in pairs(tab) do
		n = n + 1
	end
	return n
end

local function GetPetActionIndexByName(name)
	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		if GetPetActionInfo(i) == name then
			return i
		end
	end
	return nil
end

local function RefreshLocals()
	fadeInTime = 0.5
	fadeOutTime = 1
	maxAlpha = 1
	animScale = 1.5
	iconSize = 45
	holdTime = 0
	threshold = 3

	for _, v in pairs(D.ignoredspells) do
		D.ignoredspells[v] = true
	end
end

-- Cooldown/Animation
local elapsed = 0
local runtimer = 0
local function OnUpdate(_, update)
	elapsed = elapsed + update
	if elapsed > 0.05 then
		for i, v in pairs(watching) do
			if GetTime() >= v[1] + 0.5 + threshold then
				if D.ignoredspells[i] then
					watching[i] = nil
				else
					local start, duration, enabled, texture, isPet
					if v[2] == "item" then
						texture = v[3]
						start, duration, enabled = GetItemCooldown(i)
					end
					if enabled ~= 0 then
						if duration and duration > 2.0 and texture then
							cooldowns[i] = {start, duration, texture, isPet}
						end
					end
					if not (enabled == 0 and v[2] == "spell") then
						watching[i] = nil
					end
				end
			end
		end
		for i, v in pairs(cooldowns) do
			local remaining = v[2] - (GetTime() - v[1])
			if remaining <= 0 then
				tinsert(animating, {v[3],v[4]})
				cooldowns[i] = nil
			end
		end

		elapsed = 0
		if #animating == 0 and tcount(watching) == 0 and tcount(cooldowns) == 0 then
			dicd:SetScript("OnUpdate", nil)
			return
		end
	end

	if #animating > 0 then
		runtimer = runtimer + update
		if runtimer > (fadeInTime + holdTime + fadeOutTime) then
			tremove(animating, 1)
			runtimer = 0
			dicdT:SetTexture(nil)
			dicdT:SetVertexColor(1, 1, 1)
			dicd:SetBackdropBorderColor(0, 0, 0, 0)
			dicd:SetBackdropColor(0, 0, 0, 0)
		else
			if not dicdT:GetTexture() then
				dicdT:SetTexture(animating[1][1])
				if animating[1][2] then
					dicdT:SetVertexColor(1, 1, 1)
				end
			end
			local alpha = maxAlpha
			if runtimer < fadeInTime then
				alpha = maxAlpha * (runtimer / fadeInTime)
			elseif runtimer >= fadeInTime + holdTime then
				alpha = maxAlpha - (maxAlpha * ((runtimer - holdTime - fadeInTime) / fadeOutTime))
			end
			dicd:SetAlpha(alpha)
			local scale = iconSize + (iconSize * ((animScale - 1) * (runtimer / (fadeInTime + holdTime + fadeOutTime))))
			dicd:SetWidth(scale)
			dicd:SetHeight(scale)
			dicd:SetBackdropBorderColor(unpack(C.media.bordercolor))
			dicd:SetBackdropColor(unpack(C.media.backdropcolor))
		end
	end
end

-- Event Handlers
function dicd:ADDON_LOADED(addon)
	RefreshLocals()
	self:SetPoint("CENTER", dicdAnchor, "CENTER", 0, 0)
	self:UnregisterEvent("ADDON_LOADED")
end
dicd:RegisterEvent("ADDON_LOADED")

function dicd:UNIT_SPELLCAST_SUCCEEDED(unit, spell)
	if unit == "player" then
		watching[spell] = {GetTime(), "spell", spell}
		if not self:IsMouseEnabled() then
			self:SetScript("OnUpdate", OnUpdate)
		end
	end
end
dicd:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

function dicd:PLAYER_ENTERING_WORLD()
	local inInstance, instanceType = IsInInstance()
	if inInstance and instanceType == "arena" then
		self:SetScript("OnUpdate", nil)
		wipe(cooldowns)
		wipe(watching)
	end
end
dicd:RegisterEvent("PLAYER_ENTERING_WORLD")

hooksecurefunc("UseAction", function(slot)
	local actionType, itemID = GetActionInfo(slot)
	if actionType == "item" then
		local texture = GetActionTexture(slot)
		watching[itemID] = {GetTime(), "item", texture}
	end
end)

hooksecurefunc("UseInventoryItem", function(slot)
	local itemID = GetInventoryItemID("player", slot)
	if itemID then
		local texture = GetInventoryItemTexture("player", slot)
		watching[itemID] = {GetTime(), "item", texture}
	end
end)

hooksecurefunc("UseContainerItem", function(bag, slot)
	local itemID = GetContainerItemID(bag, slot)
	if itemID then
		local texture = select(10, GetItemInfo(itemID))
		watching[itemID] = {GetTime(), "item", texture}
	end
end)

SlashCmdList.PulseCD = function()
	RefreshLocals()
	tinsert(animating, {"Interface\\Icons\\Inv_Misc_Tournaments_Banner_Human"})
	dicd:SetScript("OnUpdate", OnUpdate)
end
SLASH_PulseCD1 = "/icd"