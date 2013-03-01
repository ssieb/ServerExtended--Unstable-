local path = minetest.get_modpath(minetest.get_current_modname())

local version = "0.1"
local enabled_mods = {}
dofile(path.."/config.txt")

if Ranks == true then

	dofile(path .."/ranks/ranks.lua")
	table.insert(enabled_mods, "Ranks Module Loaded")
	
end

if TeleportRequest == true then

	dofile(path .."/tpr/tpr.lua")
	table.insert(enabled_mods, "TeleportRequest Module Loaded")

end

if Homes == true then

	dofile(path .."/homes/homes.lua")
	table.insert(enabled_mods, "Homes Module Loaded")

end

if Warps == true then

	dofile(path .."/warps/warps.lua")
	table.insert(enabled_mods, "Warps Module Loaded")

end
--Unused ATM
if CommandBlocks == true then

	dofile(path .."/commandblocks/commandblocks.lua")
	table.insert(enabled_mods, "CommandBlocks Module Loaded")

end

if Economy == true then

	dofile(path .."/economy/economy.lua")
	table.insert(enabled_mods, "Economy Module Loaded")

end

if Player_Extras == true then

	dofile(path .."/player_extras/extra.lua")
	table.insert(enabled_mods, "Player Extras Commands Module Loaded")

end

if Admin_Tools == true then

	dofile(path .."/admin_tools/tools.lua")
	table.insert(enabled_mods, "Admin Tools Commands Module Loaded")

end

if Gui_Module == true then

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
local pname = player:get_player_name()
	local f = io.open(path..'/playerdata/'..pname..'.txt');
		if (f) then
			f:close();
			return
		else
			local f = io.open(path..'/playerdata/'..pname..'.txt','w');
			file:close()
		end
end)

minetest.register_on_newplayer(function(player)
local pname = player:get_player_name()
	local f = io.open(path..'/playerlist.txt');
		if (f) then
			f:close();
			local file = io.open(path..'/playerlist.txt','a+');
			file:write(pname..' = true\n')
			return
		else
		print("[ServerExtended]: Critical Error: unable to locate playerlist file. (/mods/serverextended/playerlist.txt)")
		file:close()
		end
end)
