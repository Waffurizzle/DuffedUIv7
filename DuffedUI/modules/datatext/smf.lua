-- Combined datatext for system, memory and fps --
local D, C, L, G = unpack(select(2, ...))
--------------------------------------------------------------------
-- FPS
--------------------------------------------------------------------

if C["datatext"].smf and C["datatext"].smf > 0 then
	local Stat = CreateFrame("Frame")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	Stat.tooltip = false
	local scolor1 = D.RGBToHex(unpack(C["media"].datatextcolor1))
	local scolor2 = D.RGBToHex(unpack(C["media"].datatextcolor2))

	local Text  = DuffedUIInfoLeft:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C["media"].font, C["datatext"].fontsize)
	D.DataTextPosition(C["datatext"].smf, Text)

	local bandwidthString = "%.2f Mbps"
	local percentageString = "%.2f%%"

	local kiloByteString = "%d kb"
	local megaByteString = "%.2f mb"

	local function formatMem(memory)
		local mult = 10^1
		if memory > 999 then
			local mem = ((memory/1024) * mult) / mult
			return string.format(megaByteString, mem)
		else
			local mem = (memory * mult) / mult
			return string.format(kiloByteString, mem)
		end
	end

	local memoryTable = {}

	local function RebuildAddonList(self)
		local addOnCount = GetNumAddOns()
		if (addOnCount == #memoryTable) or self.tooltip == true then return end

		-- Number of loaded addons changed, create new memoryTable for all addons
		memoryTable = {}
		for i = 1, addOnCount do
			memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
		end
		self:SetAllPoints(Text)
	end
	
	local function UpdateMemory()
		-- Update the memory usages of the addons
		UpdateAddOnMemoryUsage()
		-- Load memory usage in table
		local addOnMem = 0
		local totalMemory = 0
		for i = 1, #memoryTable do
			addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
			memoryTable[i][3] = addOnMem
			totalMemory = totalMemory + addOnMem
		end
		-- Sort the table to put the largest addon on top
		table.sort(memoryTable, function(a, b)
			if a and b then
				return a[3] > b[3]
			end
		end)
		
		return totalMemory
	end
	
	local int, int2 = 10, 2
	local function Update(self, t)
		int = int - t
		int2 = int2 - t
		if int < 0 then
			RebuildAddonList(self)
			int = 10
		end	
		if int2 < 0 then
			Text:SetText(floor(GetFramerate())..scolor1.." fps|r & "..select(3, GetNetStats())..scolor1.." ms|r")
			int2 = 2
		end
	end

	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			self.tooltip = true
			local bandwidth = GetAvailableBandwidth()
			local anchor, panel, xoff, yoff = D.DataTextTooltipAnchor(Text)
			local bw_in, bw_out, latencyHome, latencyWorld = GetNetStats()
			ms_combined = latencyHome + latencyWorld
			if panel == DuffedUIMinimapStatsLeft or panel == DuffedUIMinimapStatsRight then
				GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			else
				GameTooltip:SetOwner(self, anchor, xoff, yoff)
			end
			GameTooltip:ClearLines()
			local totalMemory = UpdateMemory()
			GameTooltip:AddDoubleLine(L.datatext_totalmemusage, formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
			for i = 1, #memoryTable do
				if (memoryTable[i][4]) then
					local red = memoryTable[i][3] / totalMemory
					local green = 1 - red
					GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
				end						
			end
			GameTooltip:AddLine(" ")
			if bandwidth ~= 0 then
				GameTooltip:AddDoubleLine(L.datatext_bandwidth , string.format(bandwidthString, bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
				GameTooltip:AddDoubleLine(L.datatext_download , string.format(percentageString, GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
				GameTooltip:AddLine(" ")
			end
			GameTooltip:AddDoubleLine("Home Latency:", latencyHome.." "..MILLISECONDS_ABBR, 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine("World Latency:", latencyWorld.." "..MILLISECONDS_ABBR, 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine("Global Latency:", ms_combined.." "..MILLISECONDS_ABBR, 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Incoming", string.format( "%.4f", bw_in ) .. " kb/s", 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine("Outgoing", string.format( "%.4f", bw_out ) .. " kb/s", 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
			GameTooltip:Show()
		end
	end)

	Stat:SetScript("OnMouseDown", function(self, btn) if(btn == "LeftButton") then ToggleFrame(PVPFrame) else collectgarbage("collect")	end	end)
	Stat:SetScript("OnLeave", function(self) self.tooltip = false GameTooltip:Hide() end)
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end