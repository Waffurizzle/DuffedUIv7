local D, C, L, G = unpack(select(2, ...))

if C["auras"].buffnotice ~= true then return end

D.BuffReminder1 = {
	DEATHKNIGHT = {
		6673, -- Battle Shout
		57330, -- Horn of Winter
		93435, -- Roar of Courage (Hunter Pet)
	},
	DRUID = {
		1126, -- Mark of the Wild
		20217, -- Blessing of Kings
		90363, -- Embrace of the Shale Spider
		117666, -- Legacy of the Emperor
	},
	HUNTER = {
		5118, -- Aspect of the Cheetah
		13159, -- Aspect of the Pack
		13165, -- Aspect of the Hawk
		109260, -- Aspect of the Iron Hawk
	},
	MAGE = {
		6117, -- Mage Armor
		7302, -- Frost Armor
		30482, -- Molten Armor
	},
	MONK = {
		1126, -- Mark of the Wild
		20217, -- Blessing of Kings
		90363, -- Embrace of the Shale Spider
		116781, -- Legacy of the White Tiger
		117666, -- Legacy of the Emperor
	},
	PALADIN = {
		1126, -- Mark of the Wild
		19740, -- Blessing of Might
		20217, -- Blessing of Kings
		90363, -- Embrace of the Shale Spider
		117666, -- Legacy of the Emperor
	},
	PRIEST = {
		588, -- Inner Fire
		73413, -- Inner Will
	},
	ROGUE = {
		2823, -- Deadly Poison
		8679, -- Wound Poison
	},
	SHAMAN = {
		324, -- Lightning Shield
		974, -- Earth Shield
		52127, -- Water Shield
	},
	WARLOCK = {
		109773, -- Dark Intent
	},
	WARRIOR = {
		469, -- Commanding Shout
		6673, -- Battle Shout
		93435, -- Roar of Courage (Hunter Pet)
		57330, -- Horn of Winter
		21562, -- PW: Fortitude
	},
}

D.BuffReminder2 = {
	DEATHKNIGHT = {
		48263, -- Blood Presence
		48265, -- Unholy Presence
		48266, -- Frost Presence
	},
	DRUID = {
	},
	HUNTER = {
	},
	MAGE = {
		1459, -- Arcane Brilliance
		61316, -- Dalaran Brilliance
	},
	MONK = {
	},
	PALADIN = {
	},
	PRIEST = {
		21562, -- PW: Fortitude
	},
	ROGUE = {
		3408, -- Crippling Poison
		5761, -- Mind-numbing Poison
		108211, -- Leeching Poison
		108215, -- Paralytic Poison
	},
	SHAMAN = {
	},
	WARLOCK = {
	},
	WARRIOR = {
	},
}

D.BuffEnchants = {
	SHAMAN = {
		8024, -- flametongue
		8232, -- windfury
		51730, -- earthliving
	},
}