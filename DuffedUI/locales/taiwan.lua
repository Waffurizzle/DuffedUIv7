local D, C, L, G = unpack(select(2, ...))

if D.client == "zhTW" then
	L.UI_Outdated = "DuffedUI 版本已過期，請至 www.tukui.org 下載最新版"
	L.UI_Talent_Change_Bug = "一個由暴雪產生的故障已阻止你改變你當前的天賦,這發生在你使用觀察功能查看其他玩家角色裝備時.不幸的是在這個魔獸補丁中我們對修正它無能為力,請/reload你的Ui程式介面並且再次嘗試."

	L.welcome_1 = "Hello |cffc41f3b".. D.myname.."!|r".."\n".."感謝您使用|cffc41f3bDuffedUI "..D.version.."|r (基於Tukui編譯)."
	L.welcome_2 = "詳細資訊請訪問 |cffc41f3bhttp://www.tukui.org|r. 進一步資訊及額外的使用幫助請使用小地圖 H 按鈕或者聊天窗口輸入/dhelp."

	-- specswitcher buttons
	L.sesbutton_reload = "重新載入Ui介面"
	L.sesbutton_heal = "切換到治療佈局"
	L.sesbutton_dps = "切換到Dps輸出佈局"
	L.sesbutton_am = "打開插件管理器 Addonmanager"
	L.sesbutton_move = "移動框體"
	L.sesbutton_config = "DuffedUI 設置"
	L.sesbutton_kb = "設置您的按鍵綁定"
	L.sesbutton_help = "打開DuffedUI幫助面板"
	L.sesbutton_Thelp = "幫助"
	
	-- helpframe 
	L.Duffed_HELP_HEADER = "|cffc41f3bDuffedUI|r - 帮助" 
	L.Duffed_HELP_BUTTON1 = "快捷命令" 
	L.Duffed_HELP_BUTTON2 = "天赋/装备切换助手" 
	L.Duffed_HELP_BUTTON3 = "特殊按鈕" 
	L.Duffed_HELP_BUTTON4 = "動作條"   
	L.Duffed_HELP_BUTTON5 = "內容準備中"  --內容準備中 
	L.Duffed_HELP_BUTTON6 = "內容準備中"  --內容準備中 
	L.Duffed_HELP_BUTTON7 = "內容準備中"  --內容準備中 
	L.Duffed_HELP_BUTTON8 = "已知問題"   
	L.Duffed_HELP_BUTTON9 = "鳴謝" 

	L.Duffed_HELP_CONTENT0_TITLE = "總覽" 
	L.Duffed_HELP_CONTENT0_LINE1 = "歡迎使用 |cffc41f3bDuffedUI|r的幫助面版!\n這個面板將幫助你找到|cffc41f3bDuffedUI|r 一些重要的設定和指令的操作:)" 
	L.Duffed_HELP_CONTENT0_LINE2 = "請選擇一個使用類型(Dps佈局,治療佈局)" 
	L.Duffed_HELP_CONTENT0_LINE3 = "遊戲愉快!" 
	L.Duffed_HELP_CONTENT0_LINE4 = "製作人:greetz Merith - 服務器: Zirkel des Cenarius EU" 

	L.Duffed_HELP_CONTENT9_TITLE = "鳴謝" 
	L.Duffed_HELP_CONTENT9_LINE1 = "" 
	L.Duffed_HELP_CONTENT9_LINE2 = "Tukz, Elv, nightcracker, Ecl韕s? Hydra, Asphyxia, Jasje, Epicgrimm, JerichoHM 感謝以上和所有為了不起的Tukui, Tukz和所有編譯者們提供過幫助的人" 
	L.Duffed_HELP_CONTENT9_LINE3 = "另外由衷感謝我的Beta版測試者:" 
	L.Duffed_HELP_CONTENT9_LINE4 = "Kanestorm, Juhawny, Elenarda, macgee, loveran, transform, Optional, Pixelfcuk, Shera, lefirez, jones7 和所有其他的測試者:)" 

	L.Duffed_HELP_CONTENT8_TITLE = "已知問題"
	L.Duffed_HELP_CONTENT8_LINE1 = ""
	L.Duffed_HELP_CONTENT8_LINE2 = "這裏你將找到一個DuffedUi已知問題的列表"
	L.Duffed_HELP_CONTENT8_LINE3 = "問題:"
	L.Duffed_HELP_CONTENT8_LINE4 = "- 裝備等級在人物角色面板顯示錯誤(由5.1補丁更新系統函數引起) \n- 滑鼠提示他人裝備等級估算錯誤."

	L.Duffed_HELP_CONTENT7_TITLE = "內容準備中"   --內容準備中 
	L.Duffed_HELP_CONTENT7_LINE1 = "" 
	L.Duffed_HELP_CONTENT7_LINE2 = "" 
	L.Duffed_HELP_CONTENT7_LINE3 = "" 
	L.Duffed_HELP_CONTENT7_LINE4 = "" 

	L.Duffed_HELP_CONTENT6_TITLE = "內容準備中" 
	L.Duffed_HELP_CONTENT6_LINE1 = "" 
	L.Duffed_HELP_CONTENT6_LINE2 = "" 
	L.Duffed_HELP_CONTENT6_LINE3 = "" 
	L.Duffed_HELP_CONTENT6_LINE4 = "" 

	L.Duffed_HELP_CONTENT5_TITLE = "iCD / sCD控件"
	L.Duffed_HELP_CONTENT5_LINE1 = ""
	L.Duffed_HELP_CONTENT5_LINE2 = "什麼是iCD和sCD設定?兩個名稱的意義都是<物品冷卻>(iCD)和<技能冷卻>(sCD)的縮寫.."
	L.Duffed_HELP_CONTENT5_LINE3 = "使用<物品冷卻>將會啟用一個非常強力的插件功能,顯示你物品CD結束的脈衝動畫.這個脈衝效果將出現在你的螢幕中部."
	L.Duffed_HELP_CONTENT5_LINE4 = "使用<技能冷卻>將會啟用一個非常強力的插件功能,顯示你重要技能的CD結束.這兩個插件功能使用技能白名單過濾,如果有需要添加的監視技能,請將技能的SpellID告訴我,我會後續添加."

	L.Duffed_HELP_CONTENT4_TITLE = "動作條"
	L.Duffed_HELP_CONTENT4_LINE1 = ""
	L.Duffed_HELP_CONTENT4_LINE2 = "在DuffedUi中,你將擁有3種不同的動作條佈局模式.模式為:\n\n1x24 & 1x12 底部動作條 and 2x12 右邊動作條\nx12 底部動作條, 2x6 分割動作條, 2x12 右邊動作條\n3x12 底部動作條, 2x12 右邊動作條"
	L.Duffed_HELP_CONTENT4_LINE3 = "如果要使用 2x12 底部動作條佈局模式,你必須在遊戲內Tukui設置中設定//動作條佈局//模式為 2 . 第三種3x12佈局模式需要你在一般設定中去掉勾選//使用高解析度設定於低解析度//選項（目前這個佈局有bug,不推薦使用).每種佈局都有一個隱藏按鈕在底部動作條下(或者在左下方聊天框右下角).若你開啟了動作條1與動作條3互換位置的選項,在底部將缺少隱藏按鈕+號設置."
	L.Duffed_HELP_CONTENT4_LINE4 = "如果你有這些佈局的建議或者問題請使用論壇反饋給我." 

	L.Duffed_HELP_CONTENT3_TITLE = "特殊按鈕" 
	L.Duffed_HELP_CONTENT3_LINE1 = "位於小地圖下方的一排按鈕將有各自獨立的功能." 
	L.Duffed_HELP_CONTENT3_LINE2 = "R => 重載插件\nH => 切換為治療者佈局 (團隊界面)" 
	L.Duffed_HELP_CONTENT3_LINE3 = "D => 切換為Dps佈局 (團隊界面)\nA => Addonmanager(內置插件管理器)" 
	L.Duffed_HELP_CONTENT3_LINE4 = "M => 移動你的界面框體(頭像,任務追踪等)\nC => 打開Tukui遊戲內置控制台\nK => 設定遊戲熱鍵" 

	L.Duffed_HELP_CONTENT2_TITLE = "天賦/裝備切換助手" 
	L.Duffed_HELP_CONTENT2_LINE1 = "切換助手相關插件位於右邊拾取聊天框背景條上.滑鼠,鼠標單擊這些切換按鈕將使你方便地進行天賦及裝備的切換/更換." 
	L.Duffed_HELP_CONTENT2_LINE2 = "" 
	L.Duffed_HELP_CONTENT2_LINE3 = "在遊戲的Misc選項中,這個插件能為你的每個天賦設定一套單獨的裝備使用,在你每次切換天賦時自動穿上該設定好的裝備.(例如切換為Dps天賦時自動穿上Dps裝,切換治療天賦時,穿上治療裝).可以通過啟用 / 禁用來設置開關." 
	L.Duffed_HELP_CONTENT2_LINE4 = "他可以支持創建及設定多達10套裝備." 

	L.Duffed_HELP_CONTENT1_TITLE = "快速指令" 
	L.Duffed_HELP_CONTENT1_LINE1 = "/dhelp => 打開這個幫助面板\n/resetui => 重置插件的所有描點位置為原狀\n/install => 重新安裝所有Duffed設置(當你的聊天框或者某個功能出現問題時)" 
	L.Duffed_HELP_CONTENT1_LINE2 = "/moveui or /mduffedui => 移動所有界面元素(頭像,任務追踪)\n/kb => 滑鼠,鼠標移動到動作條上進行熱鍵綁定\n/rl => 重載UI" 
	L.Duffed_HELP_CONTENT1_LINE3 = "/heal => 切換到治療佈局\n/dps => 切換到Dps佈局\n/dc => 打開Tukui遊戲內置控制台\n/ddbm apply => 應用特殊的 DBM-Skin(皮膚)" 
	L.Duffed_HELP_CONTENT1_LINE4 = "/dbigwigs apply => 應用特殊的 BigWigs-Skin(皮膚)\n/am => 打開 Addonmanager(內置插件管理器)\n/version => 顯示插件版本號\n/farmmode => Enable the farmmode" 
	
	L.chat_INSTANCE_CHAT = "I"
	L.chat_INSTANCE_CHAT_LEADER = "IL"
	L.chat_BN_WHISPER_GET = "密語"
	L.chat_GUILD_GET = "公"
	L.chat_OFFICER_GET = "官"
	L.chat_PARTY_GET = "隊"
	L.chat_PARTY_GUIDE_GET = "地下城向導"
	L.chat_PARTY_LEADER_GET = "隊長"
	L.chat_RAID_GET = "團"
	L.chat_RAID_LEADER_GET = "團長"
	L.chat_RAID_WARNING_GET = "團長警告"
	L.chat_WHISPER_GET = "密語"
	L.chat_FLAG_AFK = "[AFK]"
	L.chat_FLAG_DND = "[DND]"
	L.chat_FLAG_GM = "[GM]"
	L.chat_ERR_FRIEND_ONLINE_SS = "|cff05e9FF上線了|r"
	L.chat_ERR_FRIEND_OFFLINE_S = "|cffff0000下線了|r"
	
	L.chat_general = "綜合"
	L.chat_trade = "交易"
	L.chat_defense = "本地防務"
	L.chat_recrutment = "公會招募"
	L.chat_lfg = "尋求組隊"
	
	L.disband = "正在解散隊伍"

	L.datatext_notalents ="無天賦"
	L.datatext_download = "下載: "
	L.datatext_bandwidth = "寬頻: "
	L.datatext_inc = "接收"
	L.datatext_out = "發送"
	L.datatext_home = "本地延遲:"
	L.datatext_world = "世界延遲:"
	L.datatext_global = "全局延遲:"
	L.datatext_guild = "公會"
	L.datatext_noguild = "沒有公會"
	L.datatext_bags = "背包: "
	L.datatext_friends = "好友"
	L.datatext_online = "線上: "
	L.datatext_armor = "耐久度"
	L.datatext_earned = "賺取:"
	L.datatext_spent = "花費:"
	L.datatext_deficit = "赤字:"
	L.datatext_profit = "利潤:"
	L.datatext_timeto = "時間直到"
	L.datatext_friendlist = "好友名單:"
	L.datatext_playersp = "法傷"
	L.datatext_playerap = "強度"
	L.datatext_playerhaste = "加速"
	L.datatext_dps = "dps"
	L.datatext_hps = "hps"
	L.datatext_playerarp = "護甲穿透"
	L.datatext_session = "本次概況: "
	L.datatext_character = "角色: "
	L.datatext_server = "伺服器: "
	L.datatext_totalgold = "總額: "
	L.gametooltip_gold_a = "考古學: "
	L.gametooltip_gold_c = "烹飪: "
	L.gametooltip_gold_jc = "珠寶: "
	L.gametooltip_gold_dr = "地城 & 團隊: "
	L.datatext_savedraid = "已有進度的團隊副本"
	L.datatext_currency = "兌換通貨:"
	L.datatext_fps = " fps & "
	L.datatext_ms = " ms"
	L.datatext_playercrit = "% 致命"
	L.datatext_playerheal = " 治療"
	L.datatext_avoidancebreakdown = "免傷分析"
	L.datatext_lvl = "等級"
	L.datatext_boss = "首領"
	L.datatext_miss = "未擊中"
	L.datatext_dodge = "閃躲"
	L.datatext_block = "格檔"
	L.datatext_parry = "招架"
	L.datatext_playeravd = "免傷: "
	L.datatext_servertime = "伺服器時間: "
	L.datatext_localtime = "本地時間: "
	L.datatext_mitigation = "等級緩和: "
	L.datatext_healing = "治療: "
	L.datatext_damage = "傷害: "
	L.datatext_honor = "榮譽: "
	L.datatext_killingblows = "擊殺 : "
	L.datatext_ttstatsfor = "狀態 "
	L.datatext_ttkillingblows = "擊殺:"
	L.datatext_tthonorkills = "榮譽擊殺:"
	L.datatext_ttdeaths = "死亡:"
	L.datatext_tthonorgain = "獲得榮譽:"
	L.datatext_ttdmgdone = "傷害輸出:"
	L.datatext_tthealdone = "治療輸出:"
	L.datatext_basesassaulted = "基地突襲:"
	L.datatext_basesdefended = "基地防禦:"
	L.datatext_towersassaulted = "哨塔突襲:"
	L.datatext_towersdefended = "哨塔防禦:"
	L.datatext_flagscaptured = "佔領旗幟:"
	L.datatext_flagsreturned = "交還旗幟:"
	L.datatext_graveyardsassaulted = "墓地突襲:"
	L.datatext_graveyardsdefended = "墓地防守:"
	L.datatext_demolishersdestroyed = "石毀車摧毀:"
	L.datatext_gatesdestroyed = "大門摧毀:"
	L.datatext_totalmemusage = "總共記憶體使用:"
	L.datatext_control = "控制方:"
	L.datatext_cta_allunavailable = "無法獲取戰鬥的召喚信息."
	L.datatext_cta_nodungeons = "目前沒有可用的戰鬥的召喚地下城."
	L.datatext_carts_controlled = "礦車控制:"
	L.datatext_victory_points = "勝利點數:"
	L.datatext_orb_possessions = "能量寶珠點數:"
 
	L.Slots = {
		[1] = {1, "頭部", 1000},
		[2] = {3, "肩部", 1000},
		[3] = {5, "胸部", 1000},
		[4] = {6, "腰部", 1000},
		[5] = {9, "手腕", 1000},
		[6] = {10, "手", 1000},
		[7] = {7, "腿部", 1000},
		[8] = {8, "腳", 1000},
		[9] = {16, "主手", 1000},
		[10] = {17, "副手", 1000},
		[11] = {18, "遠程", 1000}
	}
 
	L.popup_disableui = "DuffedUI並不支援此解析度, 你想要停用DuffedUI嗎? (若果您想要嘗試其他解析度, 請按取消)"
	L.popup_install = "這個角色首次使用DuffedUI V13, 您必需先重載介面以完成設定"
	L.popup_reset = "警告! 此動作會重置任何設定至DuffedUI預設值. 您是否依然決定這樣做?"
	L.popup_2raidactive = "2個團隊框架正在運行, 請選擇以下其中一個."
	L.popup_install_yes = "當然是! (建議!)"
	L.popup_install_no = "不用了, 救命這UI真差"
	L.popup_reset_yes = "當然啦, 預設就是美!"
	L.popup_reset_no = "不囉, 不然我會發文抱怨!"
	L.popup_fix_ab = "動作列發生問題, 您想要重新載入介面來修復嗎?"
 
	L.merchant_repairnomoney = "您沒有足夠的金錢來修理!"
	L.merchant_repaircost = "您的裝備已修理, 花費了"
	L.merchant_trashsell = "您背包內的粗糙物品已被自動賣出, 您賺取了"
 
	L.goldabbrev = "|cffffd700g|r"
	L.silverabbrev = "|cffc7c7cfs|r"
	L.copperabbrev = "|cffeda55fc|r"
 
	L.error_noerror = "沒有錯誤"
 
	L.unitframes_ouf_offline = "離線"
	L.unitframes_ouf_dead = "死亡"
	L.unitframes_ouf_ghost = "鬼魂"
	L.unitframes_ouf_lowmana = "法力過低"
	L.unitframes_ouf_threattext = "當前目標的仇恨:"
	L.unitframes_ouf_offlinedps = "離線"
	L.unitframes_ouf_deaddps = "|cffff0000[死亡]|r"
	L.unitframes_ouf_ghostheal = "鬼魂"
	L.unitframes_ouf_deadheal = "死亡"
	L.unitframes_ouf_gohawk = "切換為雄鷹守護"
	L.unitframes_ouf_goviper = "切換為蝮蛇守護"
	L.unitframes_disconnected = "斷線"
	L.unitframes_ouf_wrathspell = "憤怒"
	L.unitframes_ouf_starfirespell = "星火術"
 
	L.tooltip_count = "數量"
 
	L.bags_noslots = "不能再購買更多的背包欄位!"
	L.bags_costs = "花費: %.2f 金"
	L.bags_buyslots = "輸入 /bags purchase yes 以購買銀行背包欄位"
	L.bags_openbank = "您需要先造訪您的銀行"
	L.bags_sort = "將背包或銀行內的物品分類及排序"
	L.bags_stack = "將背包或銀行內的不完整的物品堆疊重新堆疊"
	L.bags_buybankslot = "購買銀行背包欄位. (需要造訪銀行)"
	L.bags_search = "搜尋"
	L.bags_sortmenu = "分類及排序"
	L.bags_sortspecial = "分類及排序特殊物品"
	L.bags_stackmenu = "堆疊"
	L.bags_stackspecial = "堆疊特殊物品"
	L.bags_showbags = "顯示背包"
	L.bags_sortingbags = "分類及排序完成"
	L.bags_nothingsort= "不需要分類"
	L.bags_bids = "使用背包: "
	L.bags_stackend = "重新堆疊完成"
	L.bags_rightclick_search = "點擊右鍵以搜尋物品."
	
	L.loot_fish = "漁獲"
	L.loot_empty = "無戰利品"
	L.loot_randomplayer = "隨機隊伍玩家"
	L.loot_self = "自我獲取"
 
	L.chat_invalidtarget = "無效的目標"
 
	L.mount_wintergrasp = "冬握湖"
 
	L.core_autoinv_enable = "啟用自動邀請: invite"
	L.core_autoinv_enable_c = "自動邀請功能已啟用: "
	L.core_autoinv_disable = "自動邀請功能已關閉"
	L.core_wf_unlock = "解鎖任務追蹤"
	L.core_wf_lock = "鎖定任務追蹤"
	L.core_welcome1 = "歡迎使用 |cffC495DDDuffedUI|r "
	L.core_welcome2 = "輸入 |cff00FFFF/uihelp|r 以獲得更多資訊"
 
	L.core_uihelp1 = "|cff00ff00通用指令|r"
	L.core_uihelp2 = "|cffFF0000/moveui|r - 解鎖並移動任何您看得見的框架及UI元素"
	L.core_uihelp3 = "|cffFF0000/rl|r - 重新載入UI"
	L.core_uihelp4 = "|cffFF0000/gm|r - 傳送回報單給GM或開啟幫助介面"
	L.core_uihelp5 = "|cffFF0000/frame|r - 偵測滑鼠位置下的框架名稱. (對lua編輯者非常有幫助!)"
	L.core_uihelp6 = "|cffFF0000/heal|r - 啟用Heal介面"
	L.core_uihelp7 = "|cffFF0000/dps|r - 啟用Dps/Tank介面"
	L.core_uihelp8 = "|cffFF0000/bags|r - 排序背包, 購買銀行背包位置或堆疊物品"
	L.core_uihelp9 = "|cffFF0000/resetui|r - 重置DuffedUI到預設設置"
	L.core_uihelp10 = "|cffFF0000/rd|r - 解散團隊"
	L.core_uihelp11 = "|cffFF0000/ainv|r - 啟用密語自動邀請, 您可以設定輸入`/ainv myword`以設置您的密語關鍵字"
	L.core_uihelp100 = "(想看更多? 向上拉吧! ...)"
 
	L.symbol_CLEAR = "清除"
	L.symbol_SKULL = "頭顱"
	L.symbol_CROSS = "十字"
	L.symbol_SQUARE = "方形"
	L.symbol_MOON = "月亮"
	L.symbol_TRIANGLE = "三角"
	L.symbol_DIAMOND = "鑽石"
	L.symbol_CIRCLE = "圈圈"
	L.symbol_STAR = "星星"
 
	L.bind_combat = "您不能在戰鬥中設定快捷鍵"
	L.bind_saved = "所有快捷鍵修改已儲存"
	L.bind_discard = "這次的快捷鍵修改已重設為上一次修改"
	L.bind_instruct = "將滑鼠指向動作列上以綁定快捷鍵, 您可以按ESC或以右鍵點擊快捷列上任何一格以清除該位置的設定"
	L.bind_save = "儲存"
	L.bind_discardbind = "放棄"
 
	L.hunter_unhappy = "你的寵物感到不高興!"
	L.hunter_content = "你的寵物感到滿足!"
	L.hunter_happy = "你的寵物感到高興!"
	
	L.move_tooltip = "移動指示資訊"
	L.move_minimap = "移動小地圖"
	L.move_watchframe = "移動任務追蹤框架"
	L.move_gmframe = "移動GM回報單及幫助介面"
	L.move_buffs = "移動玩家Buff介面"
	L.move_debuffs = "移動玩家Debuff介面"
	L.move_shapeshift = "移動變形或圖騰列"
	L.move_achievements = "移動成就介面"
	L.move_roll = "移動Roll戰利品的介面"
	L.move_vehicle = "移動載具坐位介面"
	L.move_extrabutton = "額外的按鈕"
	
	-- tuto/install
	L.install_header_1 = "歡迎"
	L.install_header_2 = "1. 基本要素"
	L.install_header_3 = "2. 單位框架"
	L.install_header_4 = "3. 特點"
	L.install_header_5 = "4. 您應該知道的事!"
	L.install_header_6 = "5. 指令"
	L.install_header_7 = "6. 完成"
	L.install_header_8 = "1. 必要的設定"
	L.install_header_9 = "2. 社交"
	L.install_header_10= "3. 框架"
	L.install_header_11= "4. 成功!"

	L.install_init_line_1 = "感謝您選擇DuffedUI!"
	L.install_init_line_2 = "透過幾個簡單的步驟，將會引導您通過整個安裝過程。每個步驟您都可以決定是否套用或略過所呈現的設定。"
	L.install_init_line_3 = "您也可以選擇顯示關於DuffedUI功能的簡短指南。"
	L.install_init_line_4 = "點選'指南'來獲得簡介，或者點選'安裝'以略過這步驟。"

	L.tutorial_step_1_line_1 = "這個快速指南將向您展示一些DuffedUI的特點及功能。"
	L.tutorial_step_1_line_2 = "首先，基本要素將會告訴您使用這個UI前該知道的事項。"
	L.tutorial_step_1_line_3 = "這個安裝程序部分是角色特定，一些設定將會全帳號套用，您必須為每一個有使用DuffedUI的新角色執行安裝程序。程序將會在新角色第一次登入DuffedUI時自動顯示。同時，進階使用者可以在/DuffedUI/config/config.lua中找到選項，友善使用者可以在遊戲中輸入/tukui。"
	L.tutorial_step_1_line_4 = "進階使用者是指有能力會使用一般使用者所不會的進階功能(如：編輯lua)的個人電腦使用者。友善使用者為一般使用者，並不需要編寫程式的能力，推薦他們使用我們的遊戲內設定工具(/tukui)來設定DuffedUI上想呈現的功能。"

	L.tutorial_step_2_line_1 = "DuffedUI包含一個內建版本的oUF，由Trond (Haste) A Ekseth創造，處理畫面中所有的單位框架，增/減益狀態及職業特色元素。"
	L.tutorial_step_2_line_2 = "您可以拜訪 http://www.wowinterface.com 蒐尋oUF以獲得更多這項工具的資訊。"
	L.tutorial_step_2_line_3 = "假如您是治療者或是團隊領隊，您可能想啟用治療者團隊框架，它們提供更多團隊資訊(/heal)。傷害輸出玩家或是坦克應該使用簡潔的團隊框架(/dps)。如果不想顯示任一團隊框架或是其他東西，您可以在角色選單的插件管理中關閉它。"
	L.tutorial_step_2_line_4 = "鍵入/moveui可以簡單地改變單位框架的位置。"

	L.tutorial_step_3_line_1 = "DuffedUI是一個重新設計過的Blizzard UI，不多也不少。大部分你可以在預設UI上看到的都是DuffedUI，只有一些自動化功能是畫面中看不到的，如：拜訪商人時自動販賣灰色物品，或是自動分類背包中的物品。"
	L.tutorial_step_3_line_2 = "並不是每個人都滿意傷害輸出統計、首領模組，仇恨監控等等，但我們認為這是最好的事情。DuffedUI是在符合所有職業、角色、天賦、玩法、玩家品味...等等的概念下產生，這就是為什麼DuffedUI是現今最受歡迎的UI之一，它適合每個人的玩法且可任意地調整。它也設計成可讓任何想做客製化UI卻沒有關聯插件的人有一個好的開始。自2009年後，許多玩家使用DuffedUI為基礎來創作自己的UI，可以到我們網站的Edited Packages論壇專區看看!"
	L.tutorial_step_3_line_3 = "使用者可能有興趣到我們網站的額外模組專區看看，或是拜訪 http://www.wowinterface.com 來獲得額外的功能或模組。"
	L.tutorial_step_3_line_4 = ""

	L.tutorial_step_4_line_1 = "將滑鼠移至在底部快捷列背景的最左/右邊，可設定底部快捷列的數目，畫面右邊的快捷列同樣可藉由上方或底部調整。點擊對話框的右上角游標懸停顯示的按鈕即可複製聊天文字。"
	L.tutorial_step_4_line_2 = "小地圖邊框將會改變顏色，收到新郵件時為綠色，受到新的行事曆邀請時為紅色，兩項皆有時為橘色。"
	L.tutorial_step_4_line_3 = "您可以左鍵點擊80%的資訊欄位來顯示各種Blizzard的面板，好友資訊及公會資訊同時擁有右鍵點擊功能。"
	L.tutorial_step_4_line_4 = "這裡有一些下拉式選單可供使用。右鍵點擊背包的[X](關閉)按鈕將會顯示功能選單以顯示背包、排列物品、顯示鑰匙圈等等。中鍵點擊小地圖可顯示微型選單。"

	L.tutorial_step_5_line_1 = "最近，DuffedUI有許多實用的指令，以下列表。"
	L.tutorial_step_5_line_2 = "/moveui 允許你移動畫面上大部分的框架。 /enable 及 /disable 快速啟用或關閉插件。 /rl 重新載入UI。 /heal 啟用治療者團隊框架。 /dps 啟用傷害輸出/坦克團隊框架。"
	L.tutorial_step_5_line_3 = "/tt 密語目標。 /rc 發起團隊確認。 /rd 解散隊伍或團隊。 /bags 顯示可用的背包指令。 /ainv 啟用自動密語邀請。(/ainv off 關閉功能)"
	L.tutorial_step_5_line_4 = "/gm 開啟尋求幫助選單。 /install, /resetui 或 /tutorial 載入安裝程序。 /frame 列出滑鼠游標下的框架名稱及額外資訊。"

	L.tutorial_step_6_line_1 = "指南到此結束，您可藉由輸入/tutorial 以再次諮詢。"
	L.tutorial_step_6_line_2 = "建議您開啟config/config.lua或鍵入/DuffedUI來自訂符合您需求的UI。"
	L.tutorial_step_6_line_3 = "如果安裝程序未完成，您現在可繼續安裝此UI。或者您想重置至預設值!"
	L.tutorial_step_6_line_4 = ""

	L.install_step_1_line_1 = "這些步驟將為DuffedUI套用正確的CVar設定。"
	L.install_step_1_line_2 = "第一個步驟套用必要的設定。"
	L.install_step_1_line_3 = "這個步驟|cffff0000建議|r給任何一位新使用者，除非您只想套用這些設定的特定部分。"
	L.install_step_1_line_4 = "點選'繼續'以套用設定，如果您希望跳過這個步驟請點選'略過'。"

	L.install_step_2_line_0 = "發現到其他的聊天插件。我們將會忽略這個步驟，請點擊略過以繼續安裝。"
	L.install_step_2_line_1 = "第二個步驟將會套用正確的聊天設定。"
	L.install_step_2_line_2 = "如果您是一位新使用者，我們建議這個步驟。如果是現有使用者，您可能想略過這個步驟。"
	L.install_step_2_line_3 = "經由這些設定，您的聊天字體顯示過大是正常的，當安裝完成後將會還原。"
	L.install_step_2_line_4 = "點選'繼續'以套用設定，如果您希望跳過這個步驟請點選'略過'。"

	L.install_step_3_line_1 = "第三和最後的步驟將套用預設框架位置。"
	L.install_step_3_line_2 = "我們|cffff0000建議|r這個步驟給任何一位新使用者。"
	L.install_step_3_line_3 = ""
	L.install_step_3_line_4 = "點選'繼續'以套用這些設定，如果您希望跳過這個步驟請點選'略過'。"

	L.install_step_4_line_1 = "安裝完成。"
	L.install_step_4_line_2 = "請點擊'完成'以重新載入UI。"
	L.install_step_4_line_3 = ""
	L.install_step_4_line_4 = "享受DuffedUI吧! 拜訪我們 http://www.tukui.org!"

	L.install_button_tutorial = "指南"
	L.install_button_install = "安裝"
	L.install_button_next = "下一步"
	L.install_button_skip = "略過"
	L.install_button_continue = "繼續"
	L.install_button_finish = "完成"
	L.install_button_close = "關閉"
end