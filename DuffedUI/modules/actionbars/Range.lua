local D, C, L, G = unpack(select(2, ...)) 
--[[
	Thx to Tulla
		Adds out of range coloring to action buttons
		Derived from RedRange and TullaRange
--]]

if not C["actionbar"].enable == true then return end

--locals and speed
local _G = _G
local UPDATE_DELAY = 0.15
local ATTACK_BUTTON_FLASH_TIME = ATTACK_BUTTON_FLASH_TIME
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local ActionButton_GetPagedID = ActionButton_GetPagedID
local ActionButton_IsFlashing = ActionButton_IsFlashing
local ActionHasRange = ActionHasRange
local IsActionInRange = IsActionInRange
local IsUsableAction = IsUsableAction
local HasAction = HasAction

--code for handling defaults
local function removeDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(tbl[k]) == 'table' and type(v) == 'table' then
			removeDefaults(tbl[k], v)
			if next(tbl[k]) == nil then
				tbl[k] = nil
			end
		elseif tbl[k] == v then
			tbl[k] = nil
		end
	end
	return tbl
end

local function copyDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			tbl[k] = copyDefaults(tbl[k] or {}, v)
		elseif tbl[k] == nil then
			tbl[k] = v
		end
	end
	return tbl
end

local function timer_Create(parent, interval)
	local updater = parent:CreateAnimationGroup()
	updater:SetLooping('NONE')
	updater:SetScript('OnFinished', function(self)
		if parent:Update() then
			parent:Start(interval)
		end
	end)

	local a = updater:CreateAnimation('Animation'); a:SetOrder(1)

	parent.Start = function(self)
		self:Stop()
		a:SetDuration(interval)
		updater:Play()
		return self
	end

	parent.Stop = function(self)
		if updater:IsPlaying() then
			updater:Stop()
		end
		return self
	end

	parent.Active = function(self)
		return updater:IsPlaying()
	end

	return parent
end

--stuff for holy power detection
local PLAYER_IS_PALADIN = select(2, UnitClass('player')) == 'PALADIN'
local HAND_OF_LIGHT = GetSpellInfo(90174)
local isHolyPowerAbility
do
	local HOLY_POWER_SPELLS = {
		[85256] = GetSpellInfo(85256), --Templar's Verdict
		[53600] = GetSpellInfo(53600), --Shield of the Righteous
	}

	isHolyPowerAbility = function(actionId)
		local actionType, id = GetActionInfo(actionId)
		if actionType == 'macro' then
			local macroSpell = GetMacroSpell(id)
			if macroSpell then
				for spellId, spellName in pairs(HOLY_POWER_SPELLS) do
					if macroSpell == spellName then
						return true
					end
				end
			end
		else
			return HOLY_POWER_SPELLS[id]
		end
		return false
	end
end

--[[ The main thing ]]--
local DuffedUIRange = timer_Create(CreateFrame('Frame', 'DuffedUIActionButtonsRange'), UPDATE_DELAY)
G.ActionBars.RangeCheck = DuffedUIRange

function DuffedUIRange:Load()
	self:SetScript('OnEvent', self.OnEvent)
	self:RegisterEvent('PLAYER_LOGIN')
	self:RegisterEvent('PLAYER_LOGOUT')
end

--[[ Frame Events ]]--
function DuffedUIRange:OnEvent(event, ...)
	local action = self[event]
	if action then
		action(self, event, ...)
	end
end

--[[ Game Events ]]--
function DuffedUIRange:PLAYER_LOGIN()
	if not DuffedUIRange_COLORS then
		DuffedUIRange_COLORS = {}
	end
	self.colors = copyDefaults(DuffedUIRange_COLORS, self:GetDefaults())

	--add options loader
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)
		LoadAddOn('DuffedUIRange_Config')
	end)

	self.buttonsToUpdate = {}

	hooksecurefunc('ActionButton_OnUpdate', self.RegisterButton)
	hooksecurefunc('ActionButton_UpdateUsable', self.OnUpdateButtonUsable)
	hooksecurefunc('ActionButton_Update', self.OnButtonUpdate)
end

function DuffedUIRange:PLAYER_LOGOUT()
	removeDefaults(DuffedUIRange_COLORS, self:GetDefaults())
end

--[[ Actions ]]--
function DuffedUIRange:Update()
	return self:UpdateButtons(UPDATE_DELAY)
end

function DuffedUIRange:ForceColorUpdate()
	for button in pairs(self.buttonsToUpdate) do
		DuffedUIRange.OnUpdateButtonUsable(button)
	end
end

function DuffedUIRange:UpdateActive()
	if next(self.buttonsToUpdate) then
		if not self:Active() then
			self:Start()
		end
	else
		self:Stop()
	end
end

function DuffedUIRange:UpdateButtons(elapsed)
	if next(self.buttonsToUpdate) then
		for button in pairs(self.buttonsToUpdate) do
			self:UpdateButton(button, elapsed)
		end
		return true
	end
	return false
end

function DuffedUIRange:UpdateButton(button, elapsed)
	DuffedUIRange.UpdateButtonUsable(button)
	DuffedUIRange.UpdateFlash(button, elapsed)
end

function DuffedUIRange:UpdateButtonStatus(button)
	local action = ActionButton_GetPagedID(button)
	if button:IsVisible() and action and HasAction(action) and ActionHasRange(action) then
		self.buttonsToUpdate[button] = true
	else
		self.buttonsToUpdate[button] = nil
	end
	self:UpdateActive()
end

--[[ Button Hooking ]]--
function DuffedUIRange.RegisterButton(button)
	button:HookScript('OnShow', DuffedUIRange.OnButtonShow)
	button:HookScript('OnHide', DuffedUIRange.OnButtonHide)
	button:SetScript('OnUpdate', nil)

	DuffedUIRange:UpdateButtonStatus(button)
end

function DuffedUIRange.OnButtonShow(button)
	DuffedUIRange:UpdateButtonStatus(button)
end

function DuffedUIRange.OnButtonHide(button)
	DuffedUIRange:UpdateButtonStatus(button)
end

function DuffedUIRange.OnUpdateButtonUsable(button)
	button.DuffedUIRangeColor = nil
	DuffedUIRange.UpdateButtonUsable(button)
end

function DuffedUIRange.OnButtonUpdate(button)
	 DuffedUIRange:UpdateButtonStatus(button)
end

--[[ Range Coloring ]]--
function DuffedUIRange.UpdateButtonUsable(button)
	local action = ActionButton_GetPagedID(button)
	local isUsable, notEnoughMana = IsUsableAction(action)

	--usable
	if isUsable then
		--but out of range
		if IsActionInRange(action) == 0 then
			DuffedUIRange.SetButtonColor(button, 'oor')
		--a holy power abilty, and we're less than 3 Holy Power
		elseif PLAYER_IS_PALADIN and isHolyPowerAbility(action) and not(UnitPower('player', SPELL_POWER_HOLY_POWER) >= 3 or UnitBuff('player', HAND_OF_LIGHT)) then
			DuffedUIRange.SetButtonColor(button, 'ooh')
		--in range
		else
			DuffedUIRange.SetButtonColor(button, 'normal')
		end
	--out of mana
	elseif notEnoughMana then
		DuffedUIRange.SetButtonColor(button, 'oom')
	--unusable
	else
		button.DuffedUIRangeColor = 'unusuable'
	end
end

function DuffedUIRange.SetButtonColor(button, colorType)
	if button.DuffedUIRangeColor ~= colorType then
		button.DuffedUIRangeColor = colorType

		local r, g, b = DuffedUIRange:GetColor(colorType)

		local icon =  _G[button:GetName() .. 'Icon']
		icon:SetVertexColor(r, g, b)
	end
end

function DuffedUIRange.UpdateFlash(button, elapsed)
	if ActionButton_IsFlashing(button) then
		local flashtime = button.flashtime - elapsed

		if flashtime <= 0 then
			local overtime = -flashtime
			if overtime >= ATTACK_BUTTON_FLASH_TIME then
				overtime = 0
			end
			flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

			local flashTexture = _G[button:GetName() .. 'Flash']
			if flashTexture:IsShown() then
				flashTexture:Hide()
			else
				flashTexture:Show()
			end
		end

		button.flashtime = flashtime
	end
end


--[[ Configuration ]]--
function DuffedUIRange:GetDefaults()
	return {
		normal = {1, 1, 1},
		oor = {1, .1, .1},
		oom = {.1, .3, 1},
		ooh = {.45, .45, 1},
	}
end

function DuffedUIRange:Reset()
	DuffedUIRange_COLORS = {}
	self.colors = copyDefaults(DuffedUIRange_COLORS, self:GetDefaults())

	self:ForceColorUpdate()
end

function DuffedUIRange:SetColor(index, r, g, b)
	local color = self.colors[index]
	color[1] = r
	color[2] = g
	color[3] = b

	self:ForceColorUpdate()
end

function DuffedUIRange:GetColor(index)
	local color = self.colors[index]
	return color[1], color[2], color[3]
end

--[[ Load The Thing ]]--
DuffedUIRange:Load()