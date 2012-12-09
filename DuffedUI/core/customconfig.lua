----------------------------------------------------------------------------
-- This Module loads custom settings for edited package
----------------------------------------------------------------------------

--[[
		To add your own custom config into your edited version,
		You need to create the addons (example: GoogleUI and 
		GoogleUI_Config) and add your custom configuration into 
		GoogleUI_Config.
		
		A configuration guide (example) can be downloaded at:
		(link to be updated with a new edit example)
		
		Don't forget to add in the .toc, in your edited DuffedUI 
		(ex: GoogleUI) version: ## RequiredDeps: DuffedUI

		That's it! That's all!
--]]

local D, C, L, G = unpack(select(2, ...))

if not DuffedUIEditedDefaultConfig then return end

local settings = DuffedUIEditedDefaultConfig

-- add our new options and update default
for group, options in pairs(settings) do
	-- create a new group of option if not found on DuffedUI
	if not C[group] then
		C[group] = {}
	end
	
	-- set all the options
	for option, value in pairs(options) do
		if group ~= "media" then
			C[group][option] = value
		end
	end
end