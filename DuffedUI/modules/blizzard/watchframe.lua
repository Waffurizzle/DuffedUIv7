local D, C, L, G = unpack(select(2, ...))

local DuffedUIWatchFrame = CreateFrame("Frame", "DuffedUIWatchFrame", UIParent)
DuffedUIWatchFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
G.Misc.WatchFrame = DuffedUIWatchFrame

-- to be compatible with blizzard option
local wideFrame = GetCVar("watchFrameWidth")

-- create our moving area
local DuffedUIWatchFrameAnchor = CreateFrame("Button", "DuffedUIWatchFrameAnchor", UIParent)
DuffedUIWatchFrameAnchor:SetFrameStrata("HIGH")
DuffedUIWatchFrameAnchor:SetFrameLevel(20)
DuffedUIWatchFrameAnchor:SetHeight(20)
DuffedUIWatchFrameAnchor:SetClampedToScreen(true)
DuffedUIWatchFrameAnchor:SetMovable(true)
DuffedUIWatchFrameAnchor:EnableMouse(false)
DuffedUIWatchFrameAnchor:SetTemplate("Default")
DuffedUIWatchFrameAnchor:SetBackdropBorderColor(1, 0, 0)
DuffedUIWatchFrameAnchor:SetAlpha(0)
DuffedUIWatchFrameAnchor.text = D.SetFontString(DuffedUIWatchFrameAnchor, C["media"].uffont, 12)
DuffedUIWatchFrameAnchor.text:SetPoint("CENTER")
DuffedUIWatchFrameAnchor.text:SetText(L.move_watchframe)
DuffedUIWatchFrameAnchor.text:Hide()
G.Misc.WatchFrameAnchor = DuffedUIWatchFrameAnchor
tinsert(D.AllowFrameMoving, DuffedUIWatchFrameAnchor)

-- set default position according to how many right bars we have
DuffedUIWatchFrameAnchor:Point("TOPRIGHT", UIParent, -210, -220)

-- width of the watchframe according to our Blizzard cVar.
if wideFrame == "1" then
	DuffedUIWatchFrame:SetWidth(350)
	DuffedUIWatchFrameAnchor:SetWidth(350)
else
	DuffedUIWatchFrame:SetWidth(250)
	DuffedUIWatchFrameAnchor:SetWidth(250)
end

local screenheight = D.screenheight
DuffedUIWatchFrame:SetHeight(screenheight / 1.6)
DuffedUIWatchFrame:ClearAllPoints()
DuffedUIWatchFrame:SetPoint("TOP", DuffedUIWatchFrameAnchor)

local function init()
	DuffedUIWatchFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	DuffedUIWatchFrame:RegisterEvent("CVAR_UPDATE")
	DuffedUIWatchFrame:SetScript("OnEvent", function(_, _, cvar, value)
		if cvar == "WATCH_FRAME_WIDTH_TEXT" then
			if not WatchFrame.userCollapsed then
				if value == "1" then
					DuffedUIWatchFrame:SetWidth(350)
					DuffedUIWatchFrameAnchor:SetWidth(350)
				else
					DuffedUIWatchFrame:SetWidth(250)
					DuffedUIWatchFrameAnchor:SetWidth(250)
				end
			end
			wideFrame = value
		end
	end)
end

local function setup()	
	WatchFrame:SetParent(DuffedUIWatchFrame)
	WatchFrame:SetFrameStrata("LOW")
	WatchFrame:SetFrameLevel(3)
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:ClearAllPoints()
	WatchFrame.ClearAllPoints = function() end
	WatchFrame:SetPoint("TOPLEFT", 32, -2.5)
	WatchFrame:SetPoint("BOTTOMRIGHT", 4,0)
	WatchFrame.SetPoint = D.dummy

	WatchFrameTitle:SetParent(DuffedUIWatchFrame)
	WatchFrameCollapseExpandButton:SetParent(DuffedUIWatchFrame)
	WatchFrameCollapseExpandButton:SetSize(16, 16)
	WatchFrameCollapseExpandButton:SetFrameStrata(WatchFrameHeader:GetFrameStrata())
	WatchFrameCollapseExpandButton:SetFrameLevel(WatchFrameHeader:GetFrameLevel() + 1)
	WatchFrameCollapseExpandButton:SetNormalTexture("")
	WatchFrameCollapseExpandButton:SetPushedTexture("")
	WatchFrameCollapseExpandButton:SetHighlightTexture("")
	WatchFrameCollapseExpandButton:SkinCloseButton()
	WatchFrameCollapseExpandButton.t:SetFont(C["media"].font, 12, "OUTLINE")
	WatchFrameCollapseExpandButton:HookScript("OnClick", function(self) 
		if WatchFrame.collapsed then 
			self.t:SetText("V") 
		else 
			self.t:SetText("X")
		end 
	end)
	WatchFrameTitle:Kill()
	WatchFrameLines:StripTextures()

	-- popup auto-quest
	hooksecurefunc("WatchFrameAutoQuest_GetOrCreateFrame", function(p, i)
		local frame = _G["WatchFrameAutoQuestPopUp"..i.."ScrollChild"]
		if frame and not frame.isSkinned then
			local parent = frame:GetParent()
 			frame:StripTextures()
			parent:CreateBackdrop("Transparent")
			parent.backdrop:ClearAllPoints()
			parent.backdrop:SetPoint("TOPLEFT", frame, 0, 5)
			parent.backdrop:SetPoint("BOTTOMRIGHT", frame, 13, -5)
			parent.backdrop:CreateShadow()
 			frame.isSkinned = true
		end
	end)
end

-- skin buttons
local function SkinQuestButton(self)
	if not self.isSkinned then
		local t = _G[self:GetName().."IconTexture"]
		self:SkinButton()
		self:StyleButton()
		t:SetTexCoord(.1, .9, .1, .9)
		t:SetInside()
		self.isSkinned = true
	end
end
hooksecurefunc("WatchFrameItem_UpdateCooldown", SkinQuestButton)

------------------------------------------------------------------------
-- Execute setup after we enter world
------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f.elapsed = 0
f:SetScript("OnUpdate", function(self, elapsed)
	f.elapsed = f.elapsed + elapsed
	if f.elapsed > .5 then
		setup()
		f:Hide()
	end
end)
DuffedUIWatchFrame:SetScript("OnEvent", function() if not IsAddOnLoaded("Who Framed Watcher Wabbit") or not IsAddOnLoaded("Fux") then init() f:Show() end end)