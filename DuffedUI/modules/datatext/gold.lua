local D, C, L, G = unpack(select(2, ...)) 
--------------------------------------------------------------------
-- GOLD
--------------------------------------------------------------------

if not C["datatext"].gold or C["datatext"].gold == 0 then return end
ImprovedCurrency = {}

local Stat = CreateFrame("Frame", "DuffedUIDataInfoGold")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)

Stat.Option = C["datatext"]["gold"]
Stat.Color1 = D.RGBToHex(unpack(C["media"].datatextcolor1))
Stat.Color2 = D.RGBToHex(unpack(C["media"].datatextcolor2))

local Text = Stat:CreateFontString("DuffedUIDataInfoGoldText", "OVERLAY")
Text:SetFont(C["media"].font, C["datatext"].fontsize)
D.DataTextPosition(C["datatext"].gold, Text)

local Profit = 0
local Spent = 0
local OldMoney = 0
local myPlayerRealm = GetCVar("realmName")

local function formatMoney(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)

	if gold ~= 0 then
		return format(Stat.Color2.."%s|r" .. L.goldabbrev .. Stat.Color2.." %s|r" .. L.silverabbrev .. Stat.Color2.." %s|r" .. L.copperabbrev, gold, silver, copper)
	elseif silver ~= 0 then
		return format(Stat.Color2.."%s|r" .. L.silverabbrev .. Stat.Color2.." %s|r" .. L.copperabbrev, silver, copper)
	else
		return format(Stat.Color2.."%s|r" .. L.copperabbrev, copper)
	end
end

local function FormatTooltipMoney(money)
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ""

	cash = format("%.2d" .. L.goldabbrev .. " %.2d" .. L.silverabbrev .. " %.2d" .. L.copperabbrev, gold, silver, copper)

	return cash
end	

local function Currency(id, weekly, capped)
	local name, amount, tex, week, weekmax, maxed, discovered = GetCurrencyInfo(id)
	
	local r, g, b = 1, 1, 1
	for i = 1, GetNumWatchedTokens() do
		local _, _, _, itemID = GetBackpackCurrencyInfo( i )
		if id == itemID then r, g, b = .77, .12, .23 end
	end

	if (amount == 0 and not ImprovedCurrency["Zero"] and r == 1) then return end

	if weekly then
		if discovered then
			if id == 390 then
				GameTooltip:AddDoubleLine("\124T" .. tex .. ":12\124t " .. name, "Current: " .. amount .. " - " .. L.currencyWeekly .. week .. " / " .. weekmax, r, g, b, r, g, b)
			else
				GameTooltip:AddDoubleLine("\124T" .. tex .. ":12\124t " .. name, "Current: " .. amount .. " / " .. maxed .. " - " .. L.currencyWeekly .. week .. " / " .. weekmax, r, g, b, r, g, b)
			end
		end
	elseif capped  then
		if id == 392 or id == 395 then maxed = 4000 end
		if id == 396 then maxed = 3000 end
		if discovered then
			if id == 396 then
				GameTooltip:AddDoubleLine("\124T" .. tex .. ":12\124t " .. name, "Current: " .. amount .. " / " .. maxed .. " - " .. L.currencyWeekly .. week .. " / 1000", r, g, b, r, g, b)
			else
				GameTooltip:AddDoubleLine("\124T" .. tex .. ":12\124t " .. name, amount .. " / " .. maxed, r, g, b, r, g, b)
			end
		end
	else
		if discovered then
			GameTooltip:AddDoubleLine("\124T" .. tex .. ":12\124t " .. name, amount, r, g, b, r, g, b)
		end
	end
end

local function OnEvent(self, event)
	if event == "PLAYER_ENTERING_WORLD" then OldMoney = GetMoney() end

	local NewMoney	= GetMoney()
	local Change = NewMoney - OldMoney

	if OldMoney>NewMoney then Spent = Spent - Change else Profit = Profit + Change end

	Text:SetText(formatMoney(NewMoney))
	self:SetAllPoints(Text)

	local myPlayerName  = UnitName("player")
	if DuffedUIData == nil then DuffedUIData = {} end

	if DuffedUIData.gold == nil then DuffedUIData.gold = {} end

	if DuffedUIData.gold[myPlayerRealm] == nil then DuffedUIData.gold[myPlayerRealm] = {} end

	DuffedUIData.gold[myPlayerRealm][myPlayerName] = GetMoney()
	OldMoney = NewMoney
end

Stat:RegisterEvent("PLAYER_MONEY")
Stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
Stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
Stat:RegisterEvent("PLAYER_TRADE_MONEY")
Stat:RegisterEvent("TRADE_MONEY_CHANGED")
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")

Stat:SetScript("OnEvent", OnEvent)
Stat:SetScript("OnEnter", function(self)
	if InCombatLockdown() then return end
	if ImprovedCurrency["Archaeology"] == nil then ImprovedCurrency["Archaeology"] = true end
	if ImprovedCurrency["Cooking"] == nil then ImprovedCurrency["Cooking"] = true end
	if ImprovedCurrency["Jewelcrafting"] == nil then ImprovedCurrency["Jewelcrafting"] = true end
	if ImprovedCurrency["Miscellaneous"] == nil then ImprovedCurrency["Miscellaneous"] = true end
	if ImprovedCurrency["PvP"] == nil then ImprovedCurrency["PvP"] = true end
	if ImprovedCurrency["Raid"] == nil then ImprovedCurrency["Raid"] = true end
	if ImprovedCurrency["Zero"] == nil then ImprovedCurrency["Zero"] = true end

	local prof1, prof2, archaeology, _, cooking = GetProfessions()

	local anchor, panel, xoff, yoff = D.DataTextTooltipAnchor(Text)
	GameTooltip:SetOwner(panel, anchor, xoff, yoff)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(L.datatext_session)
	GameTooltip:AddDoubleLine(L.datatext_earned, formatMoney(Profit), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(L.datatext_spent, formatMoney(Spent), 1, 1, 1, 1, 1, 1)

	if Profit < Spent then
		GameTooltip:AddDoubleLine(L.datatext_deficit, formatMoney(Profit - Spent), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent) > 0 then
		GameTooltip:AddDoubleLine(L.datatext_profit, formatMoney(Profit - Spent), 0, 1, 0, 1, 1, 1)
	end

	GameTooltip:AddLine(" ")

	local totalGold = 0
	GameTooltip:AddLine(L.datatext_character)

	local thisRealmList = DuffedUIData.gold[myPlayerRealm]
	for k, v in pairs(thisRealmList) do
		GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
		totalGold = totalGold + v
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L.datatext_server)
	GameTooltip:AddDoubleLine(L.datatext_totalgold, FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)

	if archaeology and ImprovedCurrency["Archaeology"] then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L.gametooltip_gold_a)
		Currency(398)
		Currency(384)
		Currency(393)
		Currency(677)
		Currency(400)
		Currency(394)
		Currency(397)
		Currency(676)
		Currency(401)
		Currency(385)
		Currency(399)
	end

	if cooking and ImprovedCurrency["Cooking"] then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L.gametooltip_gold_c)
		Currency(81)
		Currency(402)
	end

	if (prof1 == 9 or prof2 == 9) and ImprovedCurrency["Jewelcrafting"] then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L.gametooltip_gold_jc)
		Currency(61)
		Currency(361)
		Currency(698)
	end

	if ImprovedCurrency["Raid"] then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L.gametooltip_gold_dr)
		Currency(752, false, true)
		Currency(697, false, true)
		Currency(738)
		Currency(615)
		Currency(614)
		Currency(395, false, true)
		Currency(396, false, true)
	end

	if ImprovedCurrency["PvP"] then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(PVP_FLAG)
		Currency(390, true)
		Currency(392, false, true)
		Currency(391)
	end

	if ImprovedCurrency["Miscellaneous"] then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(MISCELLANEOUS)
		Currency(241)
		Currency(416)
		Currency(515)
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("|cffC41F3BReset Data: Hold Shift + Right Click|r")

	GameTooltip:Show()
	GameTooltip:SetTemplate("Default")
end)

Stat:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

local RightClickMenu = {
	{ text = "Tukui Improved Currency Options", isTitle = true , notCheckable = true },
	{ text = "Show Archaeology Fragments", checked = function() return ImprovedCurrency["Archaeology"] end, func = function()
		if ImprovedCurrency["Archaeology"] then
			ImprovedCurrency["Archaeology"] = false
		else
			ImprovedCurrency["Archaeology"] = true
		end
	end	},
	{ text = "Show Jewelcrafting Tokens", checked = function() return ImprovedCurrency["Jewelcrafting"] end, func = function()
		if ImprovedCurrency["Jewelcrafting"] then
			ImprovedCurrency["Jewelcrafting"] = false
		else
			ImprovedCurrency["Jewelcrafting"] = true
		end
	end	},
	{ text = "Show Player vs Player Currency", checked = function() return ImprovedCurrency["PvP"] end, func = function()
		if ImprovedCurrency["PvP"] then 
			ImprovedCurrency["PvP"] = false
		else
			ImprovedCurrency["PvP"] = true
		end
	end	},
	{ text = "Show Dungeon and Raid Currency", checked = function() return ImprovedCurrency["Raid"] end, func = function()
		if ImprovedCurrency["Raid"] then
			ImprovedCurrency["Raid"] = false
		else
			ImprovedCurrency["Raid"] = true
		end
	end	},
	{ text = "Show Cooking Awards", checked = function() return ImprovedCurrency["Cooking"] end, func = function()
		if ImprovedCurrency["Cooking"] then
			ImprovedCurrency["Cooking"] = false
		else
			ImprovedCurrency["Cooking"] = true
		end
	end	},
	{ text = "Show Miscellaneous Currency", checked = function() return ImprovedCurrency["Miscellaneous"] end, func = function()
		if ImprovedCurrency["Miscellaneous"] then
			ImprovedCurrency["Miscellaneous"] = false
		else
			ImprovedCurrency["Miscellaneous"] = true
		end
	end	},
	{ text = "Show Zero Currency", checked = function() return ImprovedCurrency["Zero"] end, func = function()
		if ImprovedCurrency["Zero"] then
			ImprovedCurrency["Zero"] = false
		else
			ImprovedCurrency["Zero"] = true
		end
	end	},
}

local TukuiImprovedCurrencyDropDown = CreateFrame("Frame", "TukuiImprovedCurrencyDropDown", UIParent, "UIDropDownMenuTemplate")

local function RESETGOLD()
	local myPlayerRealm = GetCVar("realmName")
	local myPlayerName  = UnitName("player")

	DuffedUIData.gold = {}
	DuffedUIData.gold[myPlayerRealm] = {}
	DuffedUIData.gold[myPlayerRealm][myPlayerName] = GetMoney()
end
SLASH_RESETGOLD1 = "/resetgold"
SlashCmdList["RESETGOLD"] = RESETGOLD

Stat:SetScript("OnMouseDown", function(self, btn)
	if btn == "RightButton" and IsShiftKeyDown() then
		local myPlayerRealm = GetCVar("realmName")
		local myPlayerName  = UnitName("player")
	
		DuffedUIData.gold = {}
		DuffedUIData.gold[myPlayerRealm] = {}
		DuffedUIData.gold[myPlayerRealm][myPlayerName] = GetMoney()
	else
		EasyMenu(RightClickMenu, TukuiImprovedCurrencyDropDown, "cursor", 0, 0, "MENU", 2)
	end
end)