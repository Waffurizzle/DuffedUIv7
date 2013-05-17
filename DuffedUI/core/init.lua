--------------------------------------------------
-- How to Import Engine
--------------------------------------------------

-- Add the line below at the top of every created .lua file:	
-- local T, C, L, G = unpack(DuffedUI)

----------------------------------------------------------------
-- Initiation of DuffedUI engine
----------------------------------------------------------------

local addon, engine = ...
engine[1] = {} -- D, functions, constants, variables
engine[2] = {} -- C, config
engine[3] = {} -- L, localization
engine[4] = {} -- G, globals (Optionnal)

DuffedUI = engine -- Allow other addons to use Engine

--------------------------------------------------
-- We need this as soon we begin loading DuffedUI
--------------------------------------------------

local D, C, L, G = unpack(select(2, ...))

-- functions, constants, variables
D.dummy = function() return end
D.myname = select(1, UnitName("player"))
D.myclass = select(2, UnitClass("player"))
D.myrace = select(2, UnitRace("player"))
D.myfaction = UnitFactionGroup("player")
D.client = GetLocale() 
D.resolution = GetCVar("gxResolution")
D.screenheight = tonumber(string.match(D.resolution, "%d+x(%d+)"))
D.screenwidth = tonumber(string.match(D.resolution, "(%d+)x+%d"))
D.version = GetAddOnMetadata("DuffedUI", "Version")
D.versionnumber = tonumber(D.version)
D.incombat = UnitAffectingCombat("player")
D.patch, D.buildtext, D.releasedate, D.toc = GetBuildInfo()
D.build = tonumber(D.buildtext)
D.level = UnitLevel("player")
D.myrealm = GetRealmName()
D.InfoLeftRightWidth = 370

-- Modules
G.ActionBars = {}
G.Bags = {}
G.Auras = {}
G.Chat = {}
G.DataText = {}
G.Loot = {}
G.Maps = {}
G.Misc = {}
G.NamePlates = {}
G.Panels = {}
G.Skins = {}
G.Tooltips = {}
G.UnitFrames = {}
G.Install = {}

-- Hider
local UIHider = CreateFrame("Frame", "DuffedUIUIHider", UIParent)
UIHider:Hide()
G.Misc.UIHider = UIHider

-- Hider Secure (mostly used to hide stuff while in pet battle)
local PetBattleHider = CreateFrame("Frame", "DuffedUIPetBattleHider", UIParent, "SecureHandlerStateTemplate");
PetBattleHider:SetAllPoints(UIParent)
RegisterStateDriver(PetBattleHider, "visibility", "[petbattle] hide; show")

-- Credits is important! (please do not edit this, thank you!)
D.Credits = {
	"Azilroka",
	"Caith",
	"Ishtara",
	"Hungtar",
	"Tulla",
	"P3lim",
	"Alza",
	"Roth",
	"Tekkub",
	"Shestak",
	"Caellian",
	"Haleth",
	"Nightcracker",
	"Haste",
	"Hydra",
	"Elv",
	"Tukz",
}

D.DuffedCredits = {
	"jones7",
	"Waffurizzle",
	"Carbonium",
	"Optional",
	"Pixelfcuk",
	"Shera",
	"lefirez",
	"PATix",
	"macgee",
	"Roglash",
	"loveran",
	"transform",
	"Kanestorm",
	"Sinaris",
	"Juhawny",
	"Elenarda",
	"Zenglao",
}

ERR_NOT_IN_RAID = "";