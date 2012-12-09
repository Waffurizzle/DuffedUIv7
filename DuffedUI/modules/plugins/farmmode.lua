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
	
	local defaultBlip, largeBlip = "Interface\\Minimap\\ObjectIcons", C["media"].largenodes
	Minimap:SetBlipTexture(farm == false and defaultBlip or largeBlip)
end
SLASH_FARMMODE1 = '/farmmode'