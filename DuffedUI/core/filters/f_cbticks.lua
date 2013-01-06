local D, C, L, G = unpack(select(2, ...))

if C["castbar"].cbticks ~= true then return end

D.channelticks = {
	[GetSpellInfo( 10 )] = 8,
	[GetSpellInfo( 689 )] = 6,
	[GetSpellInfo( 755 )] = 6,
	[GetSpellInfo( 1120 )] = 6,
	[GetSpellInfo( 1949 )] = 15,
	[GetSpellInfo( 5143 )] = 5,
	[GetSpellInfo( 5740 )] = 4,
	[GetSpellInfo( 12051 )] = 4,
	[GetSpellInfo( 15407 )] = 3,
	[GetSpellInfo( 16914 )] = 10,
	[GetSpellInfo( 44203 )] = 4,
	[GetSpellInfo( 47540 )] = 2,
	[GetSpellInfo( 48045 )] = 5,
	[GetSpellInfo( 64843 )] = 4,
	[GetSpellInfo( 64901 )] = 4,
	[GetSpellInfo( 103103 )] = 3,
	[GetSpellInfo( 106996 )] = 10,
	[GetSpellInfo( 108371 )] = 6,
	[GetSpellInfo( 115175 )] = 9,
}

D.hasteticks = {
	[GetSpellInfo( 1120 )] = true,
	[GetSpellInfo( 64843 )] = true,
	[GetSpellInfo( 64901 )] = true,
}