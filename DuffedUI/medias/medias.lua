local D, C, L, G = unpack(select(2, ...))

C["media"] = {
	-- fonts (ENGLISH, SPANISH)
	["font"] = [=[Interface\Addons\DuffedUI\medias\fonts\normal_font.ttf]=], -- general font of DuffedUI
	["uffont"] = [[Interface\AddOns\DuffedUI\medias\fonts\uf_font.ttf]], -- general font of unitframes
	["calibri"] = [=[Interface\Addons\DuffedUI\medias\fonts\normal_font2.ttf]=], -- general2 font of DuffedUI
	["ufcalibri"] = [[Interface\AddOns\DuffedUI\medias\fonts\uf_font2.ttf]], -- general2 font of unitframes
	["dmgfont"] = [[Interface\AddOns\DuffedUI\medias\fonts\combat_font.ttf]], -- general font of dmg / sct
	
	-- fonts (DEUTSCH)
	["de_font"] = [=[Interface\Addons\DuffedUI\medias\fonts\normal_font.ttf]=], -- general font of DuffedUI
	["de_uffont"] = [[Interface\AddOns\DuffedUI\medias\fonts\uf_font.ttf]], -- general font of unitframes
	["de_dmgfont"] = [[Interface\AddOns\DuffedUI\medias\fonts\combat_font.ttf]], -- general font of dmg / sct
	
	-- fonts (FRENCH)
	["fr_font"] = [=[Interface\Addons\DuffedUI\medias\fonts\normal_font.ttf]=], -- general font of DuffedUI
	["fr_uffont"] = [[Interface\AddOns\DuffedUI\medias\fonts\uf_font.ttf]], -- general font of unitframes
	["fr_dmgfont"] = [=[Interface\AddOns\DuffedUI\medias\fonts\combat_font.ttf]=], -- general font of dmg / sct
	
	-- fonts (RUSSIAN)
	["ru_font"] = [=[Interface\Addons\DuffedUI\medias\fonts\normal_font.ttf]=], -- general font of DuffedUI
	["ru_uffont"] = [[Fonts\ARIALN.TTF]], -- general font of unitframes
	["ru_dmgfont"] = [[Interface\AddOns\DuffedUI\medias\fonts\combat_font_rus.ttf]], -- general font of dmg / sct
	
	-- fonts (TAIWAN ONLY)
	["tw_font"] = [=[Fonts\bLEI00D.ttf]=], -- general font of DuffedUI
	["tw_uffont"] = [[Fonts\bLEI00D.ttf]], -- general font of unitframes
	["tw_dmgfont"] = [[Fonts\bLEI00D.ttf]], -- general font of dmg / sct
	
	-- fonts (KOREAN ONLY)
	["kr_font"] = [=[Fonts\2002.TTF]=], -- general font of DuffedUI
	["kr_uffont"] = [[Fonts\2002.TTF]], -- general font of unitframes
	["kr_dmgfont"] = [[Fonts\2002.TTF]], -- general font of dmg / sct
	
	-- fonts (China ONLY)
	["cn_font"] = [=[Fonts\ARKai_T.TTF]=], -- general font of DuffedUI
	["cn_uffont"] = [[Fonts\ARHei.TTF]], -- general font of unitframes
	["cn_dmgfont"] = [[Fonts\ARKai_C.TTF]], -- general font of dmg / sct
	
	-- fonts (GLOBAL)
	["pixelfont"] = [=[Interface\Addons\DuffedUI\medias\fonts\pixel_font.ttf]=], -- general font of DuffedUI
	
	-- textures
	["normTex"] = [[Interface\AddOns\DuffedUI\medias\textures\normTex]], -- texture used for DuffedUI healthbar/powerbar/etc
	["glowTex"] = [[Interface\AddOns\DuffedUI\medias\textures\glowTex]], -- the glow text around some frame.
	["bubbleTex"] = [[Interface\AddOns\DuffedUI\medias\textures\bubbleTex]], -- unitframes combo points
	["copyicon"] = [[Interface\AddOns\DuffedUI\medias\textures\copy]], -- copy icon
	["blank"] = [[Interface\AddOns\DuffedUI\medias\textures\blank]], -- the main texture for all borders/panels
	["buttonhover"] = [[Interface\AddOns\DuffedUI\medias\textures\button_hover]],
	["duffed"] = [[Interface\AddOns\DuffedUI\medias\textures\duffed]],
	["largenodes"] = [[Interface\AddOns\DuffedUI\medias\textures\nodesLarge]],
	
	-- colors
	["bordercolor"] = C["general"].bordercolor or { .125, .125, .125 }, -- border color of DuffedUI panels
	["backdropcolor"] = C["general"].backdropcolor or { .05, .05, .05 }, -- background color of DuffedUI panels
	["datatextcolor1"] = { .4, .4, .4 }, -- color of datatext title
	["datatextcolor2"] = { 1, 1, 1 }, -- color of datatext result
	
	-- sound
	["whisper"] = [[Interface\AddOns\DuffedUI\medias\sounds\whisper.mp3]],
	["warning"] = [[Interface\AddOns\DuffedUI\medias\sounds\warning.mp3]],
}

-------------------------------------------------------------------
-- Used to overwrite default medias outside DuffedUI
-------------------------------------------------------------------

local settings = DuffedUIEditedDefaultConfig
if settings then
	local media = settings.media
	if media then
		for option, value in pairs(media) do
			C.media[option] = value
		end
	end
end