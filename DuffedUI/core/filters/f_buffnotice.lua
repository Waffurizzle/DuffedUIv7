local D, C, L, G = unpack(select(2, ...))

if C["auras"].buffnotice ~= true then return end

D.remindbuffs = {
	PRIEST = {
		588, -- Inner Fire
		73413, -- Inner Will
	},
	HUNTER = {
		13165, -- Aspect of the Hawk
		5118, -- Aspect of the Cheetah
		13159, -- Aspect of the Pack
		109260, -- Aspect of the Iron Hawk
	},
	MAGE = {
		7302, -- Frost Armor
		6117, -- Mage Armor
		30482, -- Molten Armor
		116257, -- Invoker's Energy
	},
	WARLOCK = {
		1459, -- Arcane Brilliance
		61316, -- Dalaran Brilliance
		109773, -- Dark Intent
	},
	SHAMAN = {
		52127, -- Water Shield
		324, -- Lightning Shield
		974, -- Earth Shield
	},
	WARRIOR = {
		469, -- Commanding Shout
		6673, -- Battle Shout
		93435, -- Roar of Courage (Hunter Pet)
		57330, -- Horn of Winter
		21562, -- PW: Fortitude
	},
	DEATHKNIGHT = {
		57330, -- Horn of Winter
		6673, -- Battle Shout
		93435, -- Roar of Courage (Hunter Pet)
		49222, -- Bone Shield
	},
	ROGUE = {
		2823, -- Deadly Poison
		8679, -- Wound Poison
	},
	DRUID = {
		1126, -- Mark of the Wild
		20217, -- Blessing of Kings
		117666, -- Legacy of the Emperor
		90363, -- Embrace of the Shale Spider
	},
	PALADIN = {
		20217, -- Blessing of Kings
		1126, -- Mark of the Wild
		117666, -- Legacy of the Emperor
		90363, -- Embrace of the Shale Spider
		19740, -- Blessing of Might
	},
	MONK = {
		117666, -- Legacy of the Emperor
		20217, -- Blessing of Kings
		1126, -- Mark of the Wild
		90363, -- Embrace of the Shale Spider
		116781, -- Legacy of the White Tiger
	},
}

D.remindbuffs2 = {
	PRIEST = {
		21562, -- PW: Fortitude
	},
	MAGE = {
		1459, -- Arcane Brilliance
		61316, -- Dalaran Brilliance
		116257, -- Invoker's Energy
	},
	DEATHKNIGHT = {
		48263, -- Blood Presence
		48265, -- Unholy Presence
		48266, -- Frost Presence
		49222, -- Bone Shield
	},
	ROGUE = {
		5761, -- Mind-numbing Poison
		3408, -- Crippling Poison
		108211, -- Leeching Poison
		108215, -- Paralytic Poison
	},
}

D.remindenchants = {
	SHAMAN = {
		8024, -- flametongue
		8232, -- windfury
		51730, -- earthliving
	},
}