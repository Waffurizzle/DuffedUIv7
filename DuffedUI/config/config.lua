local D, C, L, G = unpack(select(2, ...))

-----------------------------------------
-- This is the default configuration file
-----------------------------------------

C["general"] = {
	["autoscale"] = true,                               		-- mainly enabled for users that don't want to mess with the config file
	["uiscale"] = 0.71,                                 		-- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["overridelowtohigh"] = false,                      		-- EXPERIMENTAL ONLY! override lower version to higher version on a lower reso.
	["backdropcolor"] = { .05, .05, .05 },              		-- default backdrop color of panels
	["bordercolor"] = { .125, .125, .125 },             		-- default border color of panels
	["classcolor"] = false,										-- enable classcolor
	["classcoloredborder"] = false,								-- classcolored borders
	["lowres"] = false,											-- lowres on highres
}

C["unitframes"] = {
	-- general options
	["enable"] = true,                                  		-- do i really need to explain this?
	["layout"] = 2,												-- set uf-layout
	["percent"] = false,										-- enable percentdisplay
	["healthbarcolor"] = {.125, .125, .125, 1},					-- healthbar color (if unicolor = true) 
	["deficitcolor"] = {
		0, 0, 0,
		.6, .2, .2,
		.125, .125, .125,
	},
	["ColorGradient"] = false,									-- enable colorgradient
	["framewidth"] = 218,										-- framewidth for unitframes
	["totandpetlines"] = true,									-- enable connectlines
	["portraitstyle"] = "MODEL",								-- set portraitstyle
	["largefocus"] = false,										-- enable largefocusframe
	["buffrows"] = 1,											-- Buff rows above Target (and Player if u enable it)
	["debuffrows"] = 2, 										-- Debuff rows above Target (and Player if u enable it)
	["vengeancebar"] = false,									-- enable vengeancebar
	["powerClasscolored"] = true,								-- enable classcolored power
	["sComboenable"] = true,									-- enable combopoint display
	["sComboenergybar"] = true,									-- enable energy bar for sCombo
	["enemyhcolor"] = false,                            		-- enemy target (players) color by hostility, very useful for healer.
	["auratimer"] = true,                               		-- enable timers on buffs/debuffs
	["auratextscale"] = 11,                             		-- the font size of buffs/debuffs timers on unitframes
	["targetauras"] = true,                             		-- enable auras on target unit frame
	["lowThreshold"] = 20,                              		-- global low threshold, for low mana warning.
	["targetpowerpvponly"] = true,                      		-- enable power text on pvp target only
	["totdebuffs"] = false,                             		-- enable tot debuffs (high reso only)
	["showtotalhpmp"] = false,                          		-- change the display of info text on player and target with XXXX/Total.
	["showsmooth"] = true,                              		-- enable smooth bar
	["charportrait"] = true,	                           		-- do i really need to explain this?
	["unicolor"] = true,               		                	-- enable unicolor theme
	["combatfeedback"] = true,                  		        -- enable combattext on player and target.
	["playeraggro"] = true,                             		-- color player border to red if you have aggro on current target.
	["healcomm"] = false,     		                        	-- enable healprediction support.
	["onlyselfdebuffs"] = false,    		                    -- display only our own debuffs applied on target
	["showfocustarget"] = true,             		            -- show focus target
	["showstatuebar"] = true,                       		    -- show statue bar (Dependencies: class bar option)
	["bordercolor"] = { .4, .4, .4 },                  			-- unit frames panel border color
	["focusdebuffs"] = true,									-- enable focus debuffs
	["runeofpower"] = true,										-- enable rune of power
	["fader"] = false,											-- enable fader for unitframes
	["minalpha"] = 0.1,											-- set minalpha for fader
	["weakenedsoulbar"] = true,                         		-- show weakened soul bar
	["classbar"] = true,                                		-- enable tukui classbar over player unit
	["druidmanabar"] = true,                            		-- enable druid class mana bar
	["druidmushroombar"] = false,                      			-- enable druid class mushroom bar
}

C["raid"] = {
	["enable"] = true,											-- enable raid frames
	["showrange"] = true,                               		-- show range opacity on raidframes
	["raidalphaoor"] = 0.3,                             		-- alpha of unitframes when unit is out of range
	["showsymbols"] = true,	                            		-- show symbol.
	["aggro"] = true,                                   		-- show aggro on all raids layouts
	["raidunitdebuffwatch"] = true,                     		-- track important spell to watch in pve for grid mode.
	["gridhealthvertical"] = true,                    			-- enable vertical grow on health bar for grid mode.
	["gridscale"] = 1,                                  		-- set the healing grid scaling
	["gridvertical"] = false,                            		-- grid group displayed vertically
	["showraidpets"] = true,                            		-- show pets in raid unit frames
	["showgroupresurrect"] = false,                     		-- show ressurect icon on raid frames
	["showplayerinparty"] = false,								-- show player in party
	["gridonly"] = true,										-- enable grid only
	["showboss"] = true,                                		-- enable boss unit frames for encounters.
	["arena"] = true,                                   		-- enable arena frames
	["maintank"] = true,                               			-- enable maintank
	["mainassist"] = false,     		                        -- enable mainassist
}

C["skins"] = {
	["blizzardreskin"] = true,									-- enable blizzardskins
	["bigwigs"] = true,											-- enable bigwigs skin
	["dbm"] = true,												-- enable dbm skin
	["omen"] = true,											-- enable omen skin
	["tinydps"] = true,											-- enable tinyDPS skin
	["calendarevent"] = false,									-- disable calendar event textures
}

C["classtimer"] = {
	["enable"] = true,											-- enable classtimer
	["targetdebuffs"] = false,									-- target debuffs above target (looks crappy imo)
	["playercolor"] = {.2, .2, .2, 1 },							-- playerbarcolor
	["targetbuffcolor"] = { 70/255, 150/255, 70/255, 1 },		-- targetbarcolor (buff)
	["targetdebuffcolor"] = { 150/255, 30/255, 30/255, 1 },		-- targetbarcolor (debuff)
	["trinketcolor"] = {75/255, 75/255, 75/255, 1 },			-- trinketbarcolor
}

C["castbar"] = {
	["enable"] = true,											-- enable castbar
	["petenable"] = true,										-- enable petcastbar
	["cblatency"] = false,                              		-- enable castbar latency
	["cbicons"] = true,                                 		-- enable icons on castbar
	["spark"] = true,											-- enable spark
	["classcolor"] = false,										-- enable classcolor for castbar
	["color"] = { .31, .45, .63, .5 },							-- castbar color
	["cbticks"] = true,											-- enable castbar ticks
}

C["auras"] = {
	["player"] = true,                                  		-- enable tukui buffs/debuffs
	["consolidate"] = false,                            		-- enable downpdown menu with consolidate buff
	["flash"] = false,                                  		-- flash warning for buff with time < 30 sec
	["classictimer"] = true,                            		-- Display classic timer on player auras.
	["bufftracker"] = true,										-- enable bufftracker
	["buffnotice"] = true,										-- enable buffnotice
	["warning"] = true,											-- enable warning sound
	["wrap"] = 18,												-- set wrap of buffs
}

C["actionbar"] = {
	["enable"] = true,                                  		-- enable tukui action bars
	["hotkey"] = true,                                  		-- enable hotkey display because it was a lot requested
	["macro"] = false,                                  		-- enable macro display because it was a lot requested
	["hideshapeshift"] = false,                         		-- hide shapeshift or totembar because it was a lot requested.
	["buttonsize"] = 27,                                		-- normal buttons size
	["petbuttonsize"] = 29,                             		-- pet & stance buttons size
	["buttonspacing"] = 4,                              		-- buttons spacing
	["ownshdbar"] = false,                              		-- use a complete new stance bar for shadow dance (rogue only)
	["ownmetabar"] = true,                              		-- use a complete new stance bar for metamorphosis (warlock only)
	["ownwarstancebar"] = false,                        		-- use a different bar for every warrior stance like it was in previous xpac (warrior only)
	["button2"] = false,										-- hiding button between datatetxt
	["layout"] = 1,												-- actionbarlayouts
	["petbaralwaysvisible"] = true,								-- visiblity petbar
	["rightbarsmouseover"] = false,								-- rightbars on mouseover
	["petbarhorizontal"] = false,								-- horizontal petbar
	["shapeshiftborder"] = true,								-- enable stancebarborder
	["verticalshapeshift"] = false,								-- enable vertical stancebar
	["shapeshiftmouseover"] = false,							-- enable mouseover on stancebar
	["swap"] = false,											-- enable actionbar swap
	["borderhighlight"] = false,								-- enable prochighlight on iconborder
}

C["bags"] = {
	["enable"] = true,                                  		-- enable an all in one bag mod that fit tukui perfectly
	["bpr"] = 10,												-- buttons per row
	["moveable"] = false,										-- move your bags
}

C["misc"] = {
	["gold"] = true,											-- enable shorten golddisplay
	["chatalert"] = true,										-- enable chart alert
	["sesenable"] = true,										-- enable specswitcher
	["sesenablegear"] = true,									-- enable gearslots
	["sesgearswap"] = true,										-- enable automatic geearswap
	["sesset1"] = 1,											-- set 1st set (1 - 10)
	["sesset2"] = 2,											-- set 2nd set (1 - 10)
	["combatanimation"] = true,									-- enable combat animation
	["flightpoint"] = true,										-- enable flightpoint list
	["ilvlcharacter"] = true,									-- enable itemlevel display on charscreen
	["loc"] = true,												-- disable loss of control
	["location"] = true,										-- enable location panel
	["exp_rep"] = true,											-- enable EXP / Rep-panel on bottom panel
	["acm_screen"] = true,										-- enable Achievment-screenshot
	["clickcast"] = true,										-- enable click2cast-plugin
}

C["duffed"] = {
	["dispelannouncement"] = false,								-- enable dispel announcement
	["drinkannouncement"] = false,								-- enable drink announcement
	["sayinterrupt"] = true,									-- enable interrupt announcement
	["bossicons"] = true,										-- enable alternative bossicons
	["announcechannel"] = "PARTY",								-- set announcechannel
	["spellannounce"] = true,									-- enable aura announcement
}

C["runes"] = {
	["enable"] = false,											-- enable alternativ runebar
	["barlength"] = 40,											-- bar length of runes
	["barthickness"] = 14,										-- thickness of rune bars
	["displayrpbar"] = true,									-- runic power bar below the runes
	["displayrpbartext"] = true,								-- enable runic power text
	["rpbarthickness"] = 10,									-- thickenes of runic power bar
	["hideooc"] = false,										-- hide drunes ooc
	["growthdirection"] = "VERTICAL",							-- growth direction of rune bars
	["runestrike"] = false,										-- enable rune strike display if usable
}

C["loot"] = {
	["lootframe"] = true,                               		-- reskin the loot frame to fit tukui
	["rolllootframe"] = true,                           		-- reskin the roll frame to fit tukui
}

C["cooldown"] = {
	["enable"] = true,                                  		-- do i really need to explain this?
	["treshold"] = 8,                                   		-- show decimal under X seconds and text turn red
}

C["rcd"] = {
	["enable"] = true,											-- enable raidcooldowns
	["raid"] = true,											-- raidannounce raidcooldowns
	["party"] = false,											-- partyannounce raidcooldowns
	["arena"] = false,											-- arenaannounce raidccooldowns
}

C["scd"] = {
	["enable"] = true,											-- enable spellcooldowns
	["fsize"] = 12,												-- fonsize spellcooldowns
	["size"] = 36,												-- iconsize spellcooldowns
	["spacing"] = 10,											-- spacing spellcooldowns
	["fade"] = 0,												-- fading spellcooldowns
	["direction"] = "HORIZONTAL",								-- direction spellcooldowns
	["display"] = "STATUSBAR",									-- statusbar spellcooldowns
}

C["icd"] = {
	["enable"] = true,
}

C["datatext"] = {
	["dodge"] = 0,												-- show dodge on panels
	["honor"] = 0,												-- show honor on panels
	["honorablekills"] = 0,										-- show honorablekills on panels
	["parry"] = 0,												-- show parry on panels
	["profession"] = 0,											-- show profession on panels
	["smf"] = 4,												-- show system on panels
	["block"] = 0,												-- show block on panels
	["bags"] = 5,                                       		-- show space used in bags on panels
	["gold"] = 6,                                       		-- show your current gold on panels
	["wowtime"] = 8,                                    		-- show time on panels
	["guild"] = 1,                                     			-- show number on guildmate connected on panels
	["dur"] = 2,                                        		-- show your equipment durability on panels.
	["friends"] = 3,                                    		-- show number of friends connected.
	["dps_text"] = 0,                                   		-- show a dps meter on panels
	["hps_text"] = 0,                                   		-- show a heal meter on panels
	["power"] = 7,                                      		-- show your attackpower/spellpower/healpower/rangedattackpower whatever stat is higher gets displayed
	["haste"] = 0,                                      		-- show your haste rating on panels.
	["crit"] = 0,                                       		-- show your crit rating on panels.
	["avd"] = 0,                                        		-- show your current avoidance against the level of the mob your targeting
	["armor"] = 0,                                      		-- show your armor value against the level mob you are currently targeting
	["hit"] = 0,                                        		-- show hit rating
	["mastery"] = 0,                                    		-- show mastery rating
	["micromenu"] = 0,                                  		-- add a micro menu thought datatext
	["regen"] = 0,                                      		-- show mana regeneration
	["talent"] = 0,                                     		-- show talent
	["calltoarms"] = 0,                                 		-- show dungeon and call to arms

	["battleground"] = true,                            		-- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	["time24"] = true,                                  		-- set time to 24h format.
	["localtime"] = false,                              		-- set time to local time instead of server time.
	["fontsize"] = 12,                                  		-- font size for panels.
}

C["chat"] = {
	["enable"] = true,                                  		-- blah
	["whispersound"] = true,                            		-- play a sound when receiving whisper
	["lbackground"] = true,										-- enable left chatbackground
	["rbackground"] = true,										-- enable right chatbackground
	["textright"] = true,										-- set textjustify to right
	["fading"] = true,											-- enables fading
}

C["nameplate"] = {
	["enable"] = true,                                  		-- enable nice skinned nameplates that fit into tukui
	["showhealth"] = false,				                		-- show health text on nameplate
	["enhancethreat"] = false,			                		-- threat features based on if your a tank or not
	["combat"] = false,					                		-- only show enemy nameplates in-combat.
	["goodcolor"] = {75/255,  175/255, 76/255},	        		-- good threat color (tank shows this with threat, everyone else without)
	["badcolor"] = {0.78, 0.25, 0.25},			        		-- bad threat color (opposite of above)
	["transitioncolor"] = {218/255, 197/255, 92/255},			-- threat color when gaining threat
	["debuffs"] = true,											-- enable debuffdisplay
	["width"] = 110,											-- nameplate width
	["height"] = 7,												-- nameplate height
	["nameabbrev"] = false,										-- abbrev names
	["aurassize"] = 20,											-- debuff size
	["showcastbarname"] = false,								-- enable castbarname
}

C["tooltip"] = {
	["enable"] = true,                                  		-- true to enable this mod, false to disable
	["hidecombat"] = false,                             		-- hide bottom-right tooltip when in combat
	["hidebuttons"] = false,                            		-- always hide action bar buttons tooltip.
	["hideuf"] = false,                                 		-- hide tooltip on unitframes
	["cursor"] = false,                                 		-- tooltip via cursor only
	["ilvl"] = true,											-- enable itemlevel display for tooltip
	["ids"] = true,												-- enable spellids
}

C["merchant"] = {
	["sellgrays"] = true,                               		-- automaticly sell grays?
	["autorepair"] = true,                              		-- automaticly repair?
	["sellmisc"] = true,                                		-- sell defined items automatically
	["autoguildrepair"] = true,									-- enables autoguildrepair
}

C["error"] = {
	["enable"] = true,                                  		-- true to enable this mod, false to disable
	filter = {                                          		-- what messages to not hide
		[INVENTORY_FULL] = true,                        		-- inventory is full will not be hidden by default
	},
}

C["invite"] = { 
	["autoaccept"] = true,                              		-- auto-accept invite from guildmate and friends.
}