local D, C, L, G = unpack(select(2, ...))
if C["scd"].enable ~= true then return end

local font = C["media"].font
local fontSize = C["scd"].fsize
local fontStyle = "THINOUTLINE"
local texture = C["media"].normTex
local size = D.Scale(C["scd"].size)
local spacing = D.Scale(C["scd"].spacing)
local anchor = {"BOTTOM", UIParent, "BOTTOM", 0, D.Scale(325)}
local color = {1, 1, 0, 1}
local fade = C["scd"].fade
local direction = C["scd"].direction
local mode = "HIDE"
local displayMode = C["scd"].display

if D.myclass == "WARRIOR" or D.myclass == "HUNTER" or D.myclass == "DEATHKNIGHT" or D.myclass == "ROGUE" then
	mode = "HIDE"
end

spellCooldowns = {
	["PRIEST"] = {
		47585, -- Dispersion
		34433, -- Shadowfiend
		8092,  -- Mind Blast
		8122,  -- Psychic Scream
		64044, -- Psychic Horror
		586,   -- Fade
		15487, -- Silence
		64901, -- Hymn of Hope
		724,   -- Lightwell
		34861, -- Circle of Healing
		33076, -- Prayer of Mending
		64843, -- Divine Hymn
		47788, -- Guardian Spirit
		19236, -- Desperate Prayer
		10060, -- Power Infusion
		62618, -- Power Word: Barrier
		47540, -- Penance
		89485, -- Inner Focus
		81700, -- Archangel
		87153, -- Dark Archangel
		33206, -- Pain Supression
		6346,  -- Fear Ward
		-- Chakra stuff
		14751, -- Chakra
		88625, -- Holy Word: Chastise
		88682, -- HW: Aspire
		88684, -- HW: Serenity
		88685, -- HW: Sanctuary
		73325, -- Leap of Faith
	},
	["SHAMAN"] = {
		51490, -- 59159, -- Thunderstorm
		16166, -- Elemental Mastery // Bugged, shows this cooldown along with nature's swiftness as they share cooldowns
		16190, -- Mana Tide Totem
		16188, -- Nature's Swiftness // Bugged
		55198, -- Tidal Force
		51533, -- Feral Spirit
		30823, -- Shamanistic Rage
		8177, -- Grounding Totem
		2825, -- Bloodlust
		32182, -- Heroism
		79206, -- Spiritwalker's Grace
		114049, -- Ascendance
		98008, -- Spirit Link Totem
		108280, -- Healing Tide Totem
		120668, -- Stormlash Totem
		108285, -- Call of the Elements
	},
	["ROGUE"] = {
		1856, -- Vanish
		5277, -- Evasion
		31224, -- Cloak of Shadows
		2983, -- Sprint
		2094, -- Blind
		51713, -- Shadow Dance
		14183, -- Premeditation
		14185, -- Preparation
		36554, -- Shadowstep
		79140, -- Vendetta
		14177, -- Cold Blood
		13877, -- Blade Flurry
		51690, -- Killing Spree
		13750, -- Adrenaline Rush
		76577, -- Smoke Bomb
		73981, -- Redirect
		74001, -- Combat Readiness
		57934, -- Tricks
		1966, -- Feint
	},
	["DRUID"] = {
		49376, -- Feral Charge - Cat
		16979, -- Feral Charge - Bear
		20484, -- Rebirth
		1850, -- Dash
		5209, -- Challenging Roar
		22842, -- Frenzied Regeneration
		740, -- Tranquility
		5217, -- Tiger's Fury
		16689, -- Nature's Grasp
		48505, -- Starfall
		33831, -- Force of Nature
		50516, -- Typhoon
		50334, -- Berserk
		61336, -- Survival Instincts
		17116, -- Nature's Swiftness
		77764, -- Stampeding Roar
		124974, -- Nature's Vigil
		112071, -- Celestial Alignment
		110621, -- Mirror Images
		29166, -- Innervate
	},
	["MAGE"] = {
		12472, -- Icy Veins
		122,   -- Frost Nova
		120,   -- Cone of Cold
		11426, -- Ice Barrier
		11958, -- Cold Snap
		44572, -- Deep Freeze
		31687, -- Water Elemental
		11113, -- Blast Wave
		31661, -- Dragon Breath
		11129, -- Combustion
		12043, -- Presense of Mind
		12042, -- Arcane Power
		45438, -- Ice Block
		543,   -- Magic Protection (Fire/Frost Ward)
		12051, -- Evocation
		2139,  -- Counterspell
		55342, -- Mirror Images
		1953,  -- Blink
		66,    -- Invisibility
		1463,  -- Mana Shield
		80353, -- Time Warp
		82676, -- Ring of Frost
		82731, -- Flame Orb
	},
	["MONK"] = {
		116680, -- Thunder Focus Tea
		122470, -- Touch of Karma
		115080, -- Touch of Death
		115295, -- Guard
		116849, -- Life Cocoon
		115213, -- Avert Harm
		119392, -- Charging Ox Wave
		119381, -- Leg Sweep
		122278, -- Dampen Harm
		122783, -- Diffuse Magic
		123904, -- Invoke Xuen
		109132, -- Roll
		115098, -- Chi Wave
		115310, -- Revival
		115313, -- Jade Serpent Statue
		116841, -- Tiger's Lust
		115151, -- Renewing Mist
	},
	["WARLOCK"] = {
		5484, -- Howl of Terror
		6789, -- Death Coil
		17962, -- Conflagrate
		18540, -- Summon Doomguard / Infernal
		18708, -- Fel Domination
		29858, -- Soulshatter
		30283, -- Shadowfury
		47241, -- Metamorphosis
		47897, -- Shadowflame
		48020, -- Demonic Circle: Teleport
		74434, -- Soul Burn
		77801, -- Demon Soul
		79268, -- Soul Harvest
		86121, -- Soul Swap
		113860, -- Dark Soul: Misery
		113858, -- Dark Soul: Instability
		113861, -- Dark Soul: Knowledge
		120451, -- Flames of Xoroth
		80240, -- Havoc
		108416, -- Sacrificial Pact
		132409, -- Spell Lock
	},
	["PALADIN"] = {
		498,   -- Divine Protection
		642,   -- Divine Shield
		2812,  -- Holy Wrath
		6940,  -- Hand of Sacrifice
		1022,  -- 10278, -- Hand of Protection
		1044,  -- Hand of Freedom
		1038,  -- Hand of Salvation
		633,   -- Lay on Hands
		31884, -- Avenging Wrath
		54428, -- Divine Plea /wo Glyph
		118730, -- Divine Plea /w Glyph
		20066, -- Repentance
		853,   -- Hammer of Justice
		31821, -- Aura Mastery
		20216, -- Divine Favor
		31850, -- Ardent Defender
		85222, -- Light of Dawn
		82327, -- Holy Radiance
		26573, -- Consecration
		85285, -- Rebuke
		85696, -- Zealotry
		20473, -- Holy Shock
		86698, -- Guardian of Ancient Kings
		82327, -- Holy Radiance
		31842, -- Divine Favor
		114158, -- Light's Hammer
		86669, -- Guardian of Ancient Kings
	},
	["DEATHKNIGHT"] = {
		43265, -- Death and Decay
		46584, -- Raise Dead
		47528, -- Mind Freeze
		47568, -- Empower Rune Weapon
		48707, -- Anti-magic shield
		48743, -- Death Pact
		48792, -- Icebound Fortitude
		48982, -- Rune Tap
		49016, -- Hysteria
		49028, -- Dancing Runic Blade
		49206, -- Summon Gargoyle
		49222, -- Bone Shield
		49796, -- Deathchill
		51052, -- Anti-magic zone
		51271, -- Unbreakable Armor
		55233, -- Vampiric Blood
		57330, -- Horn of Winter
		77575, -- Outbreak
		108194, -- Asphyxiate
		108199, -- Gorefiend's Grasp
		108201, -- Desecreated Ground
		108200, -- Remorseless Winter
		115989, -- Unholy Blight
		123693, -- Plague Leech
	},
	["HUNTER"] = {
		5384,  -- Feign Death
		781,    -- Disengage
		34477, -- Misdirection
		53271, -- Master's Call
		3045,   -- Rapid Fire
		1543,   -- Flare
		19263, -- Deterrence
		19503, -- Scatter Shot
		34026, -- Kill Command
		23989, -- Readiness
		-- Looks like hunters have different spell ID's for traps used with or without a launcher, test and report please.
		34600, -- Snake Trap
		82948, -- Snake Trap Launcher
		13813, -- Explosive Trap
		82939, -- Explosive Trap Launcher
		1499,   -- Freezing Trap
		60192, -- Freezing Trap Launcher
		13795, -- Immolation Trap
		82945, -- Immolation Trap Launcher
		13809, -- Ice Trap
		82941, -- Ice Trap Launcher
		51753, -- Camouflage		
	},
	["WARRIOR"] = {
		676,     -- Disarm
		1161,   -- Challenging Shout
		1719,   -- Recklessness
		2565,   -- Shield Block
		64382, -- Shattering Throw
		57755, -- Heroic Throw
		46968, -- Shockwave
		46924, -- Bladestorm
		12328, -- Sweeping Strikes
		85388, -- Throwdown
		60970, -- Heroic Fury
		12809, -- Concussion Blow
		12292, -- Death Wish
		5246,   -- Intimidating Shout
		18499, -- Berserker Rage
		20230, -- Retaliation
		871,     -- Shield Wall
		12975, -- Last Stand
		100,    -- Charge
		20252, -- Intercept
		3411,   -- Intervene
		6544, -- Heroic Leap
		86346, -- Colossus Smash
		355, -- Taunt
		114028, -- Mass Spell Reflect
	},
	["RACE"] = {
		["Orc"] = {
			33697, -- Orc Blood Fury Shaman
			33702, -- Orc Blood Fury Warlock
			20572, -- Orc Blood Fury AP
		},
		["BloodElf"] = {
			25046, -- Blood Elf Arcane Torrent Rogue
		},
		["Scourge"] = {		
			20577, -- Cannibalize
			7744,   -- Will of the Forsaken
		},
		["Tauren"] = {
			20549, -- War Stomp
		},
		["Troll"] = {
			26297, -- Berserking
		},
		["Goblin"] = {
			69070, -- Rocket Jump and Rocket Barrage
		},
		["Draenei"] = {
			59545, -- Gift of the Naaru DK
			59543, -- GotN Hunter
			59548, -- GotN Mage
			59542, -- GotN Paladin
			59544, -- GotN Priest
			59547, -- GotN Shaman
			28880, -- GotN Warrior
			121093, -- GotN Monk
		},
		["Dwarf"] = {
			20594, -- Stoneform
		},
		["Gnome"] = {
			20589, -- Escape Artist
		},
		["Human"] = {
			59752, -- Every Man for Himself
		},
		["NightElf"] = {
			58984, -- Shadowmeld
		},		
		["Worgen"] = {
			68992, -- Darkflight
			68996, -- Two Forms
		},
		["Pandaren"] = {
			107079, -- Quaking Palm
		}
	},
	["PET"] = {
		-- Warlock
		6360, -- Succubus Whiplash
		7812, -- Voidwalker Sacrifice
		19647, -- Felhunter Spell Lock
		89766, -- Felguard Axe Toss
		89751, -- Felguard Felstorm
		30151, -- Felguard Pursuit
		-- Hunter
	},
}

trinketCooldowns = {
	81268 -- testtrinket
}

-- Timer update throttle (in seconds). The lower, the more precise. Set it to a really low value and don't blame me for low fps
local throttle = 0.3
local spells = {}
local frames = {}

local GetTime = GetTime
local pairs = pairs
local xSpacing, ySpacing = spacing, 0
local width, height = size, size
local anchorPoint = "TOPRIGHT"
if direction == "VERTICAL" then
	xSpacing = 0
	ySpacing = spacing
	anchorPoint = "BOTTOMLEFT"
end
if displayMode == "SPIRAL" then
	width = size
end

local onUpdate

local SpellCooldownFrame = CreateFrame("Frame", "DuffedUISpellCooldowns", UIParent)
SpellCooldownFrame:SetFrameStrata("BACKGROUND")
SpellCooldownFrame:SetHeight(height)
SpellCooldownFrame:SetWidth(width)
SpellCooldownFrame:SetPoint(unpack(anchor))
SpellCooldownFrame:SetClampedToScreen(true)
SpellCooldownFrame:SetMovable(true)
tinsert(D.AllowFrameMoving, SpellCooldownFrame)

local function enableCooldown (self)
	self.enabled = true
	if self.StatusBar then
		self.StatusBar:Show()
		self.DurationText:Show()
	end
	if self.Cooldown then
		self.Cooldown:Show()
	end
	self:SetScript("OnUpdate", onUpdate)
	onUpdate(self, 1)
	if mode == "HIDE" then
		self:Show()
	else
		self.Icon:SetVertexColor(1, 1, 1, 1)
		self:SetAlpha(1)
	end
end

local function disableCooldown(self)
	self.enabled = false
	if mode == "HIDE" then
		self:Hide()
	else
		self.Icon:SetVertexColor(1, 1, 1, .15)
		self:SetAlpha(.2)
	end
	if self.StatusBar then
		self.StatusBar:Hide()
		self.DurationText:SetText("")
	end
	if self.Cooldown then
		self.Cooldown:Hide()
	end
	self:SetScript("OnUpdate", nil)
end

local function positionHide()
	local lastFrame = SpellCooldownFrame
	local index = 0
	for k,v in pairs(frames) do
		local frame = frames[k]
		
		-- Check if the spell is in the spellbook. E.G. will of the forsaken will show as a black icon if you're not a Forsaken, when using a PvP trinket, as it has 45s shared cooldown.
		if GetSpellTexture(GetSpellInfo(frame.spell)) or D.myclass == "PRIEST"then
			local start, duration = GetSpellCooldown(frame.spell)
			frame.start = start
			frame.duration = duration
			if duration and duration > 1.5 then
				-- fix for setting textures again when respecced. lol.
				-- Holy Word: ... Chakra state spell textures fix, sets all Holy Word: something textures to Holy Word: Chastise
				if D.myclass == "PRIEST" and frame.spell == 88682 or frame.spell == 88684 or frame.spell == 88685 then
					frame.Icon:SetTexture(GetSpellTexture(GetSpellInfo(88625)))
				else
					frame.Icon:SetTexture(GetSpellTexture(GetSpellInfo(frame.spell)))
				end
				frame:ClearAllPoints()
				if index == 0 then
					frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", xSpacing, ySpacing)
				else
					frame:SetPoint("TOPLEFT", lastFrame, anchorPoint, xSpacing, ySpacing)
				end
				if not frame.disabled then
					enableCooldown(frame)
				end
				lastFrame = frame
				index = index + 1
			else
				if frame.enabled then
					disableCooldown(frame)
				end
			end
		end
	end
	if direction == "HORIZONTAL" then
		SpellCooldownFrame:SetWidth(width * index + (index + 1) * xSpacing)
	else
		SpellCooldownFrame:SetHeight(height * index + (index + 1) * ySpacing)
	end
end

local function positionDim()
	local lastFrame = SpellCooldownFrame
	local index = 0
	for k,v in pairs(frames) do
		local frame = frames[k]
		
		-- Check if the spell is in the spellbook. E.G. will of the forsaken will show as a black icon if you're not a Forsaken, when using a PvP trinket, as it has 45s shared cooldown.
		if GetSpellTexture(GetSpellInfo(frame.spell)) or T.myclass == "PRIEST"then
			local start, duration, enable = GetSpellCooldown(frame.spell)
			frame.start = start
			frame.duration = duration
			if duration and duration > 1.5 then
				-- fix for setting textures again when respecced. lol.
				-- Holy Word: ... Chakra state spell textures fix, sets all Holy Word: something textures to Holy Word: Chastise
				if D.myclass == "PRIEST" and frame.spell == 88682 or frame.spell == 88684 or frame.spell == 88685 then
					frame.Icon:SetTexture(GetSpellTexture(GetSpellInfo(88625)))
				else
					frame.Icon:SetTexture(GetSpellTexture(GetSpellInfo(frame.spell)))
				end
				if not frame.enabled then
					enableCooldown(frame)	
				end
			else
				if frame.enabled then
					disableCooldown(frame)
				end
			end
		end
		if (index == 0) then
			frame:SetPoint("TOPLEFT", lastFrame, "TOPLEFT", xSpacing, ySpacing)
		else
			frame:SetPoint("TOPLEFT", lastFrame, anchorPoint, xSpacing, ySpacing)
		end
		lastFrame = frame
		index = index + 1
	end
	if (direction == "HORIZONTAL") then
		SpellCooldownFrame:SetWidth(width * index + (index + 1) * xSpacing)
	else
		SpellCooldownFrame:SetHeight(height * index + (index + 1 ) * ySpacing)
	end
end


local function position()
	if mode == "HIDE" then
		positionHide() 
	else
		positionDim()
	end
end

-- Frames
local function createCooldownFrame(spell)
	-- Background
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:CreateBackdrop("Transparent")
	--frame:CreateShadow()
	frame:SetHeight(height)
	frame:SetWidth(width)
	frame:SetFrameStrata("MEDIUM")
	
	-- Cooldown Texture
	local icon = frame:CreateTexture()
	local spellInfo = GetSpellInfo(spell)
	if not spellInfo then return nil end
	local texture = GetSpellTexture(spellInfo)
	icon:SetAllPoints(frame)
	-- Holy Word: ... Chakra state spell textures fix, sets all Holy Word: something textures to Holy Word: Chastise
	if D.myclass == "PRIEST" and spell == 88682 or spell == 88684 or spell == 88685 then
		texture = GetSpellTexture(GetSpellInfo(88625))
	end
	if not texture then return nil end
	icon:SetTexture(texture)
	icon:SetTexCoord(.08, .92, .08, .92)
	frame.Icon = icon	

	if displayMode == "STATUSBAR" then
		-- Text Timer
		local durationText = frame:CreateFontString(nil, "OVERLAY")
		durationText:SetFont(font, fontSize, fontStyle)
		durationText:SetTextColor(unpack(color))
		durationText:SetText("")
		durationText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
		frame.DurationText = durationText

		-- Status Bar Timer
		local statusBar = CreateFrame("StatusBar", nil, frame, "TextStatusBar")
		statusBar:SetStatusBarTexture(C["media"].normTex)
		statusBar:SetStatusBarColor(.77, .12, .23)
		statusBar:CreateBackdrop("Transparent")
		statusBar:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -6)
		statusBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, -10)
		statusBar:SetMinMaxValues(0, 1)
		frame.StatusBar = statusBar
	elseif displayMode == "SPIRAL" then
		local cooldown = CreateFrame("Cooldown", nil, frame)
		cooldown:SetAllPoints(icon)
		frame.Cooldown = cooldown
	end
	
	frame.lastupdate = 0
	frame.spell = spell
	frame.start = GetTime()
	frame.duration = 0

	disableCooldown(frame)
	return frame
end

-- Event Handling
local function OnEvent(self, event, arg1)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" then	
		for k, v in pairs(spells) do
			if GetSpellInfo(v) then
				frames[v] = frames[v] or createCooldownFrame(spells[k])
			else
				frames[v] = createCooldownFrame(spells[k])
			end
		end
		position()
	end
	
	if event == "SPELL_UPDATE_COOLDOWN" then
		position()
	end
end

-- Import your class abilities
spells = spellCooldowns[select(2, UnitClass("player"))]

-- And Race
local race = spellCooldowns["RACE"]
for i = 1, table.getn(race[select(2, UnitRace("player"))]) do
	table.insert(spells, race[select(2, UnitRace("player"))][i])
end

-- And Pet, if you have one
local _, pra = UnitRace("player")
if D.myclass == "WARLOCK" or D.myclass == "HUNTER" then
	for i = 1, table.getn(spellCooldowns["PET"]) do
		table.insert(spells, spellCooldowns["PET"][i])
	end
end

-- Update function
onUpdate = function (self, elapsed)
	self.lastupdate = self.lastupdate + elapsed
	if self.lastupdate > throttle then
		local start, duration = GetSpellCooldown(self.spell)
		if duration and duration > 1.5 then
			local currentDuration = (start + duration - GetTime())
			local normalized = currentDuration/self.duration
			if self.StatusBar then
				self.StatusBar:SetValue(normalized)
				self.DurationText:SetText(math.floor(currentDuration))
				-- if fade is 1 make it gradient, else keep it as it was
				if fade == 1 then
					self.StatusBar:GetStatusBarTexture():SetVertexColor(1 - normalized, normalized, 0 / 255)
				elseif fade == 2 then	
					self.StatusBar:GetStatusBarTexture():SetVertexColor(normalized, 1 - normalized, 0 / 255)
				end
			end
			if (self.Cooldown) then
				self.Cooldown:SetCooldown(start, duration)
			end
		else
			if self.enabled then
				disableCooldown(self)
			end
			position()
		end
		self.lastupdate = 0
	end
end

SpellCooldownFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
SpellCooldownFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
SpellCooldownFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
SpellCooldownFrame:SetScript("OnEvent", OnEvent)