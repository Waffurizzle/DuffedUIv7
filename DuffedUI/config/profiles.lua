local D, C, L, G = unpack(select(2, ...))

---------------------------------------------------------------------------
-- Per Class Config (overwrite general)
-- Class need to be UPPERCASE
-- This is an example, note that "WIZARD" doesn't exist on WoW. :P
-- It's just to give an example without interfering the default config.
-- A full configuration list can be found in /DuffedUI/config/config.lua
---------------------------------------------------------------------------

if D.myclass == "WIZARD" then
	C["actionbar"].hotkey = false
	C["actionbar"].hideshapeshift = true
	C["unitframes"].enemyhcolor = true
end

---------------------------------------------------------------------------
-- Per Character Name Config (overwrite /DuffedUI/config/config.lua and class)
-- Name need to be case sensitive
---------------------------------------------------------------------------

if D.myname == "Merith" and D.myrealm == "Zirkel des Cenarius" then
	-- blub
end