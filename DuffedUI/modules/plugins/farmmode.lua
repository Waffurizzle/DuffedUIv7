local D, C, L, G = unpack(select(2, ...))

local farm = false
local minisize = 144
local farmsize = 300
function SlashCmdList.FARMMODE(msg, editbox)
    if farm == false then
        DuffedUIMinimap:SetSize(farmsize, farmsize)
		Minimap:SetSize(farmsize, farmsize)
        farm = true
        print("Farm Mode : On")
    else
        DuffedUIMinimap:SetSize(minisize, minisize)
		Minimap:SetSize(minisize, minisize)
        farm = false
        print("Farm Mode : Off")
    end
	
	local defaultBlip = "Interface\\Minimap\\ObjectIcons"
	Minimap:SetBlipTexture(defaultBlip)
end
SLASH_FARMMODE1 = '/farmmode'