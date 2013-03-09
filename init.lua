local path = minetest.get_modpath(minetest.get_current_modname())

local version = "0.5"
local enabled_mods = {}
dofile(path.."/config.txt")
dofile(path.."/api.lua")

if Ranks_Module == true then

	dofile(path .."/ranks/ranks.lua")
	table.insert(enabled_mods, "Ranks Module Loaded")
	
end

if TeleportRequest_Module == true then

	dofile(path .."/tpr/tpr.lua")
	table.insert(enabled_mods, "TeleportRequest Module Loaded")

end

if Homes_Module == true then

	dofile(path .."/homes/homes.lua")
	table.insert(enabled_mods, "Homes Module Loaded")

end

if Warps_Module == true then

	dofile(path .."/warps/warps.lua")
	table.insert(enabled_mods, "Warps Module Loaded")

end

if Economy_Module == true then

	dofile(path .."/economy/economy.lua")
	table.insert(enabled_mods, "Economy Module Loaded")

end

if Player_Extras_Module == true then

	dofile(path .."/player_extras/extra.lua")
	table.insert(enabled_mods, "Player Extras Commands Module Loaded")

end

if Admin_Tools_Module == true then

	dofile(path .."/admin_tools/tools.lua")
	table.insert(enabled_mods, "Admin Tools Commands Module Loaded")

end

if GUI_Module == true then

	dofile(path .."/gui/gui.lua")
	table.insert(enabled_mods, "Gui Module Loaded")

end

print("[ServerExtended] ServerExtended Version "..version.." Loaded!")
print("[ServerExtended] Loading ServerExtended Modules...")
for k,v in pairs(enabled_mods) do print("[ServerExtended] "..v) end
enabled_mods = nil


minetest.register_privilege("se_admin", 
{description = "Admin permissions", 
give_to_singleplayer = false}
)
minetest.register_privilege("se_player", "Player extra permissions")
minetest.register_privilege("se_homes", "Permission to use /sethome and /home")
minetest.register_privilege("se_tpr", "Permission to request teleport to other players.")
minetest.register_privilege("se_tphr", "Permission to request other players to teleport to you.")
minetest.register_privilege("se_warps", "Permission to use /warp.")

minetest.register_on_joinplayer(function(player)
	pname = player:get_player_name()
	playerdata = load_player_data()
	if not playerdata[pname] or not playerdata[pname]['join_date'] then
		playerdata[pname] = {}
		playerdata[pname]['isPlayer'] = true
		playerdata[pname]['join_date'] = os.date("%d.%m.%Y")
		save_player_data()
		playerdata = load_player_data()
	end
end)

minetest.register_on_newplayer(function(player)
	pname = player:get_player_name()
	minetest.chat_send_all(pname, Welcome_String..pname..',')
end)

if Use_Announcer == true then
local int = 1
	function announce()
		Current_String = string.split(Announcer_Messages, ",")
		minetest.after(Announcer_Delay_Time, function()
			if Current_String[int] then
				minetest.chat_send_all(Current_String[int])
				int = int+1
				announce()
			else
				int = 1
				announce()
			end
		end)
	end
		announce()

end