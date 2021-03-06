local D, C, L, G = unpack(select(2, ...))

if C["rcd"].enable ~= true then return end

-- Config start
local anchor = "TOPLEFT"
local x, y = 150, -150
local width, height = 200, 15
local spacing = -5
local icon_size = 15
local font = C["media"].font
local font_size = 12
local font_style = "OUTLINE"
local show_icon = true
local texture = C["media"].normTex

local show = {
	raid = C["rcd"].raid,
	party = C["rcd"].party,
	arena = C["rcd"].arena,
}

local spells = {
	[20484] = 600,		-- Rebirth
	[740] = 180,		-- Tranq
	[64843] = 180,		-- Divine Hymn
	[20707] = 600,		-- Soulstone res
	[64901] = 360,		-- Hymn of Hope
	[29166] = 180,		-- Innervate
	[31821] = 180,		-- Aura Mastery
	[47788] = 180,		-- GS
	[33206] = 180,		-- Pain Supp
	[61999] = 600,		-- Raise Ally
	[16190] = 180, 		-- Mana Tide
	[98008] = 180, 		-- Spirit Link
	[115176] = 180, 	-- Zen Meditation
	[120668] = 300, 	-- Stormlash Totem
	[115310] = 180, 	-- Revival
	[108280] = 180,		-- Healing Tide Totem
	[80353] = 300, 		-- Time Warp
	[32182] = 300, 		-- Heroism
	[76095] = 60,		-- Potion of Mogu Power
	[76093] = 60,		-- Potion of the Jade Serpent
}

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0

local backdrop = {
	bgFile = C["media"].normTex,
	edgeFile = C["media"].blank, tile = false,
	tileSize = 0,
	edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local bars = {}

local rcda = CreateFrame("Frame", "RCDAnchor", UIParent)
rcda:SetSize(width, height)
rcda:SetPoint(anchor, x, y)
rcda:SetTemplate("Default")
rcda:SetClampedToScreen(true)
rcda:SetMovable(true)
rcda:SetBackdropBorderColor(1,0,0)
rcda.text = D.SetFontString(rcda, font, font_size)
rcda.text:SetPoint("CENTER")
rcda.text:SetText("Move RaidCD")
rcda:SetFrameLevel(10)
rcda:Hide()
tinsert(D.AllowFrameMoving, rcda)

local FormatTime = function(time)
	if time >= 60 then
		return sformat('%.2d:%.2d', floor(time / 60), time % 60)
	else
		return sformat('%.2d', time)
	end
end

local CreateFS = CreateFS or function(frame)
	local fstring = frame:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	fstring:SetFont(font, font_size, font_style)
	fstring:SetShadowColor(0, 0, 0, 1)
	fstring:SetShadowOffset(0.5, -0.5)
	return fstring
end

local CreateBG = CreateBG or function(parent)
	local bg = CreateFrame("Frame", nil, parent)
	bg:SetPoint("TOPLEFT", parent, "TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 1, -1)
	bg:SetFrameStrata("LOW")
	bg:SetBackdrop(backdrop)
	bg:SetTemplate("Default")
	return bg
end

local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("TOPLEFT", rcda, "TOPLEFT", 0, 0)
		else
			bars[i]:SetPoint("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, spacing)
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self.status:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(self.spell, self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		if IsInRaid() then
			SendChatMessage(sformat("Cooldown - %s [%s] %s", self.left:GetText(), self.spell, self.right:GetText()), "RAID")
		elseif IsInGroup() then
			SendChatMessage(sformat("Cooldown - %s [%s] %s", self.left:GetText(), self.spell, self.right:GetText()), "PARTY")
		else
			SendChatMessage(sformat("Cooldown - %s [%s] %s", self.left:GetText(), self.spell, self.right:GetText()), "SAY")
		end
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Frame", nil, UIParent)
	bar:SetSize(width, height)
	bar.status = CreateFrame("Statusbar", nil, bar)
	if show_icon then
		bar.icon = CreateFrame("button", nil, bar)
		bar.icon:SetSize(icon_size, icon_size)
		bar.icon:SetPoint("BOTTOMLEFT", 0, 0)
		bar.status:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", 3, 0)
	else
		bar.status:SetPoint("BOTTOMLEFT", 0, 0)
	end
	bar.status:SetPoint("BOTTOMRIGHT", 0, 0)
	bar.status:SetHeight(height)
	bar.status:SetStatusBarTexture(texture)
	bar.status:SetMinMaxValues(0, 100)
	bar.status:SetFrameLevel(bar:GetFrameLevel()-1)
	
	bar.left = CreateFS(bar)
	bar.left:SetPoint('LEFT', bar.status, 2, 0)
	bar.left:SetJustifyH('LEFT')
	
	bar.right = CreateFS(bar)
	bar.right:SetPoint('RIGHT', bar.status, -2, 0)
	bar.right:SetJustifyH('RIGHT')
	
	CreateBG(bar.icon)
	CreateBG(bar.status)
	return bar
end	

local StartTimer = function(name, spellId)
	local spell, rank, icon = GetSpellInfo(spellId)
	for _, v in pairs(bars) do
		if v.name == name and v.spell == spell then
			return
		end
	end
	local bar = CreateBar()
	bar.endTime = GetTime() + spells[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.name = name
	bar.right:SetText(FormatTime(spells[spellId]))
	if icon and bar.icon then
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	bar.spell = spell
	bar:Show()
	
	local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
	bar.status:SetStatusBarColor(color.r, color.g, color.b)
	
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags = ...
		if band(sourceFlags, filter) == 0 then return end
		if eventType == "SPELL_RESURRECT" or eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" then
			local spellId = select(12, ...)
			--sourceName = sourceName:gsub(" - %w+", "")
			if spells[spellId] and show[select(2, IsInInstance())] then
				StartTimer(sourceName, spellId)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end

local addon = CreateFrame("frame")
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")

SlashCmdList["RaidCD"] = function(msg) 
	StartTimer(UnitName("player"), 20484)	-- Rebirth
	StartTimer(UnitName("player"), 20707)	-- Soulstone
	StartTimer(UnitName("player"), 29166)	-- Innervate
	StartTimer(UnitName("player"), 115176)	-- Zen Meditation
end
SLASH_RaidCD1 = "/raidcd"