local D, C, L, G = unpack(select(2, ...))
if C["duffed"].spellannounce ~= true then return end

local Announce = D.spellalert
local Name = UnitName("player")
local GUID = UnitGUID("player")
local format = string.format
local tremove = tremove
local tinsert = tinsert
local unpack = unpack
local select = select
local UnitAura = UnitAura
local SendChatMessage = SendChatMessage
local WaitTable = {}

local OnUpdate = function(self, elapsed)
	local Count = #WaitTable
	local i = 1

	while i <= Count do
		local Table = tremove(WaitTable, i)
		local Delay = tremove(Table, 1)
		local Func = tremove(Table, 1)
		local Args = tremove(Table, 1)

		if Delay > elapsed then
			tinsert(WaitTable, i, {
				Delay - elapsed, Func, Args
			})
			i = i + 1
		else
			Count = Count - 1
			Func(unpack(Args))
		end
	end
end

local Delay = function(delay, func, ...)
	if type(delay) ~= "number" or type(func) ~= "function" then
		return false
	end

	if not AutoAnnounceWaitFrame then
		local WaitFrame = CreateFrame("Frame", "AutoAnnounceWaitFrame", UIParent)
		WaitFrame:SetScript("OnUpdate", OnUpdate)
	end

	tinsert(WaitTable, {
		delay, func, { ... } 
	})
	return true
end

local OnEvent = function(self, event, ...)
	local Time, Type, HideCaster, SourceGUID, SourceName, SourceFlags, SourceRaidFlags, DestGUID, DestName, DestFlags, DestRaidFlags, SpellID, SpellName = ...

	if SourceGUID ~= GUID then
		return
	end

	if Announce[SpellID] and Type == "SPELL_CAST_SUCCESS" then
		if not DestName then
			DestName = SourceName
		end

		local Duration = select(6, UnitAura(DestName, SpellName))
		local SpellString = "\124cff71d5ff\124Hspell:" .. SpellID .. "\124h[" .. SpellName .. "]\124h\124r"
		local AnnounceTo = "SAY"
		
		if DestName ~= Name then
			if Duration == nil then
				SendChatMessage("++ " .. SpellString .. " on " .. DestName .. "!", AnnounceTo)
			else
				SendChatMessage("++ " .. SpellString .. " on " .. DestName .. " for " .. Duration .. "s!", AnnounceTo)
			end
		else
			SendChatMessage("++ " .. SpellString .. " for " .. Duration .. "s!", AnnounceTo)
		end

		Delay(Duration, SendChatMessage, "-- " .. SpellString, AnnounceTo)
	end
end

local AnnounceFrame = CreateFrame("Frame")
AnnounceFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
AnnounceFrame:SetScript("OnEvent", OnEvent)