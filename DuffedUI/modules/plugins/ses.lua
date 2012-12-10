local D, C, L, G = unpack(select(2, ...))
if C["misc"].sesenable ~= true then return end

-- colors
local hoverovercolor = {.4, .4, .4}
local cp = "|cff319f1b" -- +
local cm = "|cff9a1212" -- -
local dr, dg, db = unpack({ .4, .4, .4 })

-- Gear Settings
local Enablegear = C["misc"].sesenablegear -- herp
local Autogearswap = C["misc"].sesgearswap -- derp
local set1 = C["misc"].sesset1 -- this is the gear set that gets equiped with your primary spec. (must be the NUMBER from 1-10)
local set2 = C["misc"].sesset2 -- this is the gear set that gets equiped with your secondary spec.(must be the NUMBER from 1-10)

--functions
local function HasDualSpec() if GetNumSpecGroups() > 1 then return true end end

local function GetSecondaryTalentIndex()
	local secondary
	if GetActiveSpecGroup() == 1 then
		secondary = 2
	else
		secondary = 1
	end
	return secondary
end

local function ActiveTalents()
	local Tree = GetSpecialization(false, false, GetActiveSpecGroup())
	return Tree
end	

local function UnactiveTalents()
	local sTree = GetSpecialization(false, false, (GetSecondaryTalentIndex()))
	return sTree
end

local function HasUnactiveTalents()
	local sTree = GetSpecialization(false, false, (GetSecondaryTalentIndex()))
	if sTree == nil then
		return false
	else
		return true
	end
end

local function AutoGear(set1, set2)
	local name1 = GetEquipmentSetInfo(set1)
	local name2 = GetEquipmentSetInfo(set2)
	if GetActiveSpecGroup() == 1 then
		if name1 then UseEquipmentSet(name1) end
	else
		if name2 then UseEquipmentSet(name2) end
	end
end

local function SpecSwitcherSpamFilter(self, event, msg, ...)
	if strfind(msg, string.gsub(ERR_LEARN_ABILITY_S:gsub('%.', '%.'), '%%s', '(.*)')) then
		return true
	elseif strfind(msg, string.gsub(ERR_LEARN_SPELL_S:gsub('%.', '%.'), '%%s', '(.*)')) then
		return true
	elseif strfind(msg, string.gsub(ERR_SPELL_UNLEARNED_S:gsub('%.', '%.'), '%%s', '(.*)')) then
		return true
	elseif strfind(msg, string.gsub(ERR_LEARN_PASSIVE_S:gsub('%.', '%.'), '%%s', '(.*)')) then
		return true
	end
    
	return false, msg, ...
end

function EnableSpecSwitcherSpamFilter()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", SpecSwitcherSpamFilter)
end

function DisableSpecSwitcherSpamFilter()
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", SpecSwitcherSpamFilter)
end

-- Spec
local spec = CreateFrame("Button", "DuffedUI_Spechelper", UIParent)
spec:Size(DuffedUIMinimap:GetWidth(), 19)
spec:SetPoint("TOPLEFT", DuffedUIMinimapStatsLeft, "BOTTOMLEFT", 0, -13)
spec:SetTemplate("Default")
spec:SetParent(DuffedUIPetBattleHider)

-- Text
spec.t = spec:CreateFontString(spec, "OVERLAY")
spec.t:SetPoint("CENTER")
spec.t:SetFont(C["media"].font, C["datatext"].fontsize, "THINOUTLINE")

local int = 1
local function Update(self, t)
int = int - t
if int > 0 then return end
	if not GetSpecialization() then spec.t:SetText("No talents") return end
	local Tree = ActiveTalents()
	local name = select(2, GetSpecializationInfo(Tree))
	spec.t:SetText(name)
		
	if HasDualSpec() then
		if HasUnactiveTalents() then 
			local sTree = UnactiveTalents()
			sName = select(2, GetSpecializationInfo(sTree))
			spec:SetScript("OnEnter", function() spec.t:SetText(cm..sName) end)
			spec:SetScript("OnLeave", function() spec.t:SetText(name) end)
		else
			spec:SetScript("OnEnter", function() spec.t:SetText(cm.."No talents") end)
			spec:SetScript("OnLeave", function() spec.t:SetText(name) end)
		end
	end
	int = 1
	self:SetScript("OnUpdate", nil)
end

local function OnEvent(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	else
		self:SetScript("OnUpdate", Update)
	end
end	
	
spec:RegisterEvent("PLAYER_TALENT_UPDATE")
spec:RegisterEvent("PLAYER_ENTERING_WORLD")
spec:RegisterEvent("CHARACTER_POINTS_CHANGED")
spec:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
spec:SetScript("OnEvent", OnEvent) 

spec:SetScript("OnClick", function(self) 
	local i = GetActiveSpecGroup()
	if IsModifierKeyDown() then
		ToggleTalentFrame()
	else
		if i == 1 then SetActiveSpecGroup(2) end
		if i == 2 then SetActiveSpecGroup(1) end
		EnableSpecSwitcherSpamFilter()
	end
end)

D.CreateBtn("MB_reload", DuffedUIMinimap, 19, 19, "Reloads the entire UI", "R")
MB_reload:Point("TOPLEFT", spec, "BOTTOMLEFT", 0, -2)
MB_reload:SetFrameLevel(10)
MB_reload:CreateShadow("Default")
MB_reload:SetAttribute("macrotext1", "/rl")
MB_reload:Hide()

D.CreateBtn("MB_heal", MB_reload, 19, 19, "Switch to heal-layout", "H")
MB_heal:Point("LEFT", MB_reload, "RIGHT", 2, 0)
MB_heal:SetFrameLevel(10)
MB_heal:CreateShadow("Default")
MB_heal:SetAttribute("macrotext1", "/heal")

D.CreateBtn("MB_dps", MB_reload, 19, 19, "Switch to dps-layout", "D")
MB_dps:Point("LEFT", MB_heal, "RIGHT", 2, 0)
MB_dps:SetFrameLevel(10)
MB_dps:CreateShadow("Default")
MB_dps:SetAttribute("macrotext1", "/dps")

D.CreateBtn("MB_am", MB_reload, 19, 19, "Open Addonmanager", "A")
MB_am:Point("LEFT", MB_dps, "RIGHT", 2, 0)
MB_am:SetFrameLevel(10)
MB_am:CreateShadow("Default")
if IsAddOnLoaded("AuctionMaster") then MB_am:SetAttribute("macrotext1", "/ap") else MB_am:SetAttribute("macrotext1", "/am") end

D.CreateBtn("MB_mui", MB_reload, 19, 19, "Move the frames", "M")
MB_mui:Point("LEFT", MB_am, "RIGHT", 2, 0)
MB_mui:SetFrameLevel(10)
MB_mui:CreateShadow("Default")
MB_mui:SetAttribute("macrotext1", "/moveui")

D.CreateBtn("MB_config", MB_reload, 19, 19, "DuffedUI Config", "C")
MB_config:Point("LEFT", MB_mui, "RIGHT", 2, 0)
MB_config:SetFrameLevel(10)
MB_config:CreateShadow("Default")
MB_config:SetAttribute("macrotext1", "/dc")

D.CreateBtn("MB_binds", MB_reload, 19, 19, "Set your keybindings", "K")
MB_binds:Point("LEFT", MB_config, "RIGHT", 2, 0)
MB_binds:SetFrameLevel(10)
MB_binds:CreateShadow("Default")
MB_binds:SetAttribute("macrotext1", "/kb")

D.CreateBtn("MB_help", MB_reload, 28, 19, "Open the Helpframe for DuffedUI", "Help")
MB_help:Point("LEFT", MB_binds, "RIGHT", 2, 0)
MB_help:SetFrameLevel(10)
MB_help:CreateShadow("Default")
MB_help:SetAttribute("macrotext1", "/dhelp")
	
if Enablegear == true then
	local gearSets = CreateFrame("Frame", nil, MB_help)	
	for i = 1, 10 do
			gearSets[i] = CreateFrame("Button", nil, MB_help)
			gearSets[i]:Size(19, 19)
			gearSets[i]:SetPoint("CENTER", MB_help, "CENTER", 0, 0)
			gearSets[i]:SetTemplate("Default")

			if i == 1 then
				gearSets[i]:Point("TOPRIGHT", MB_help, "BOTTOMRIGHT", 0, -2)
			else
				gearSets[i]:SetPoint("BOTTOMRIGHT", gearSets[i-1], "BOTTOMLEFT", -2, 0)
			end
			gearSets[i].texture = gearSets[i]:CreateTexture(nil, "BORDER")
			gearSets[i].texture:SetTexCoord(.08, .92, .08, .92)
			gearSets[i].texture:SetPoint("TOPLEFT", gearSets[i] ,"TOPLEFT", 2, -2)
			gearSets[i].texture:SetPoint("BOTTOMRIGHT", gearSets[i] ,"BOTTOMRIGHT", -2, 2)
			gearSets[i].texture:SetTexture(select(2, GetEquipmentSetInfo(i)))
			gearSets[i]:Hide()
		
		gearSets[i]:RegisterEvent("PLAYER_ENTERING_WORLD")
		gearSets[i]:RegisterEvent("EQUIPMENT_SETS_CHANGED")
		gearSets[i]:SetScript("OnEvent", function(self, event)
			local points, pt = 0, GetNumEquipmentSets()
			local frames = { gearSets[1]:IsShown(), gearSets[2]:IsShown(), gearSets[3]:IsShown(), gearSets[4]:IsShown(), 
						 gearSets[5]:IsShown(), gearSets[6]:IsShown(), gearSets[7]:IsShown(), gearSets[8]:IsShown(),
						 gearSets[9]:IsShown(), gearSets[10]:IsShown() }
			if pt > points then
				for i = points + 1, pt do
					gearSets[i]:Show()
				end
			end
			if frames[pt + 1] == 1 then
				gearSets[pt + 1]:Hide()
			end
			
			gearSets[i].texture = gearSets[i]:CreateTexture(nil, "BORDER")
			gearSets[i].texture:SetTexCoord(.08, .92, .08, .92)
			gearSets[i].texture:SetPoint("TOPLEFT", gearSets[i] ,"TOPLEFT", 2, -2)
			gearSets[i].texture:SetPoint("BOTTOMRIGHT", gearSets[i] ,"BOTTOMRIGHT", -2, 2)
			gearSets[i].texture:SetTexture(select(2, GetEquipmentSetInfo(i)))
			
			gearSets[i]:SetScript("OnClick", function(self) UseEquipmentSet(GetEquipmentSetInfo(i)) end)
			gearSets[i]:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hoverovercolor)) end)
			gearSets[i]:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C["media"].bordercolor)) end)
			
			if Autogearswap == true then
				gearSets[1]:SetBackdropBorderColor(0, 1, 0)
				gearSets[2]:SetBackdropBorderColor(1, 0, 0)
				gearSets[1]:SetScript("OnEnter", nil)
				gearSets[1]:SetScript("OnLeave", nil)
				gearSets[2]:SetScript("OnEnter", nil)
				gearSets[2]:SetScript("OnLeave", nil)
			end
		end)
	end	
	
	if Autogearswap == true then
		gearsetfunc = CreateFrame("Frame", "gearSetfunc", UIParent)
		local function OnEvent(self, event)
			if event == "PLAYER_ENTERING_WORLD" then
				self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			else
				AutoGear(set1, set2) 
			end
		end
		
		gearsetfunc:RegisterEvent("PLAYER_ENTERING_WORLD")
		gearsetfunc:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		gearsetfunc:SetScript("OnEvent", OnEvent)
	end
end

-- toggle button
local toggle = CreateFrame("Button", nil, spec)
toggle:SetTemplate("Default")
toggle:Size(29, 19)
toggle:Point("LEFT", spec, "RIGHT", 2, 0)
toggle:EnableMouse(true)
toggle:RegisterForClicks("AnyUp")

toggle.t = toggle:CreateFontString(nil, "OVERLAY")
toggle.t:SetPoint("CENTER", 0, 0)
toggle.t:SetFont(C["media"].font, C["datatext"].fontsize)
toggle.t:SetText(cp.."+|r")
toggle:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hoverovercolor)) end)
toggle:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C["media"].bordercolor)) end)

toggle:SetScript("OnMouseDown", function(self)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end

	if MB_reload:IsShown() then	
		MB_reload:Hide()
		toggle:SetText(cp.."+|r")
	else
		MB_reload:Show()
		toggle:SetText(cm.."-|r")
	end
end)