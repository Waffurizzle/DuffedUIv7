local D, C, L, G = unpack(select(2, ...))

hooksecurefunc("StaticPopup_Show", function(which)
	if which == "DEATH" and not UnitIsDeadOrGhost("player") then
		StaticPopup_Hide("DEATH")
	end
end)

local function FixTradeSkillReagents()
	local function TradeSkillReagent_OnClick(self)
		if IsModifiedClick() then
			local link, name = GetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, self:GetID())
			if not link then
				name, link = GameTooltip:GetItem()
				if name == self.name:GetText() then
					HandleModifiedItemClick(link)
				end
			end
		end
	end
	
	for i = 1, 8 do
		_G["TradeSkillReagent"..i]:HookScript("OnClick", TradeSkillReagent_OnClick)
	end
end

if TradeSkillReagent1 then
	FixTradeSkillReagents()
else
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(f, e, a)
		if a == "Blizzard_TradeSkillUI" then
			FixTradeSkillReagents()
			f:UnregisterAllEvents()
			f:SetScript("OnEvent", nil)
		end
	end)
end