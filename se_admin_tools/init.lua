--Set path variables
local filespath = minetest.get_modpath(minetest.get_current_modname()) .. "/playerdata"
local configpath = minetest.get_modpath(minetest.get_current_modname()) .. "/config.txt"

--Load Configuration
dofile(configpath)

--Register variables for commands
local god = false
local pname = nil
minetest.register_chatcommand('god',{
	description = 'Never die.',
	params = "<playername>",
	privs = {se_god = true},
	func = function(name, param)
		if param == nil or param == "" or minetest.env:get_player_by_name(param) == nil or minetest.env:get_player_by_name(param) == "" then
		
			--True-False check used to toggle god on/off
			if god == true then
				god = false
				minetest.chat_send_player(name, "God mode disabled!")
			return
			else
				god = true
				pname = minetest.env:get_player_by_name(name)
				minetest.chat_send_player(name, "God mode enabled!")

			return
			end
		else
		
			--True-False check used to toggle god on/off
			if god == true then
				god = false
				minetest.chat_send_player(param, "God mode disabled!")
				minetest.chat_send_player(name, "God mode disabled for "..param.."!")
			return
			else
				god = true
				pname = minetest.env:get_player_by_name(param)
				minetest.chat_send_player(param, "God mode enabled for "..param.."!")

			return
			end
		end
	end
})

--Check if God is true. If so, set hp for players with god to 20.
minetest.register_globalstep(function (dtime)
	if god == true then
	pname:set_hp(20)
	end
end)

--Heal command
minetest.register_chatcommand('heal',{
	description = 'Restore full health to anyone.',
	privs = {se_heal = true},
	func = function(name, param)
	
	--Check if sender wants to heal someone other than himself
	if param == "" or param == nil then
	
		--If he dosn't, heal the sender
		local player = minetest.env:get_player_by_name(name)
		player:set_hp(20)
		minetest.chat_send_player(name, "You have been healed.")
	else
		--If he is healing someone else, check and see if that someone exists.
		local player = minetest.env:get_player_by_name(param)
		if player == "" or player == nil then
			minetest.chat_send_player(name, "Invalid player name!")
		else
			--If player exists, set his HP to 20 and notify him and the sender.
			player:set_hp(20)
			minetest.chat_send_player(param, "You have been healed.")
			minetest.chat_send_player(name, "You have healed "..param.."")
		end
	end
end
})

--Time commands. I won't document these. Figure them out yourself :P
minetest.register_chatcommand("morning",{
	params = "",
	privs = {se_time = true},
	description = "Set time to morning",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.2)
	end,
})
minetest.register_chatcommand("noon",{
	params = "",
	privs = {se_time = true},
	description = "Set time to noon",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.5)
	end,
})
minetest.register_chatcommand("evening",{
	params = "",
	privs = {se_time = true},
	description = "Set time to evening",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.77)
	end,
})
minetest.register_chatcommand("night",{
	params = "",
	privs = {se_time = true},
	description = "Set time to night",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0)
	end,
})


--Set spawn command
minetest.register_chatcommand("setspawn", {
	params = "",
	privs = {se_admin = true},
	description = "Set the spawn point.",
	func = function(name, param)
		--Check for proper player [forbids console commands, not really needed]
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		--Get player position and set spawn just below that just because it looks cooler.
		local pos = player:getpos()
		pos.x = math.floor(0.5+pos.x)
		pos.z = math.floor(0.5+pos.z)
		minetest.setting_set("static_spawnpoint", minetest.pos_to_string(pos))
		
		--Notify admin who set spawn.
		minetest.chat_send_player(name, "Spawn set at, "..minetest.setting_get("static_spawnpoint"));
	end,
})

--Make sure player spawns at set spawnpoint when he dies if it exists.
minetest.register_on_respawnplayer(function(player)
	if not player then
		return
	end
	if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
		return
	end
	player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
end)

--Make sure player spawns at set spawnpoint when he joins if it exists.
minetest.register_on_newplayer(function(player)
	if not player then
		return
	end
	minetest.chat_send_all(Welcome_String.." "..player:get_player_name().."!")
	if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
		return
	end
	player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
end)

function clearinventory(name, param)
	if param == nil or param == "" then
		local playername = minetest.env:get_player_by_name(name)
		local inventory = {}
		playername:get_inventory():set_list("main", inventory)
		print(name.." has cleared his inventory.")
		minetest.chat_send_player(name, 'Inventory Cleared!')
	return
	elseif minetest.check_player_privs(name, {se_clearinventory_admin=true}) then
		local playername = minetest.env:get_player_by_name(param)
		local inventory = {}
		playername:get_inventory():set_list("main", inventory)
		print(name.." has cleared " ..param.."'s inventory.")
		minetest.chat_send_player(name, 'Inventory Cleared!')
	return
	else
		minetest.chat_send_player(name, 'You do not have the priveleges necessary to clear another\'s inventory')
		return false;
	end
end
minetest.register_chatcommand('clearinv',{
	description = 'Clear your inventory.',
	params = "<playername> | name of player (optional)",
	privs = {se_clearinventory=true},
	func = clearinventory
})

minetest.register_chatcommand('tp',{
	description = 'Teleport to a player',
	params = "<playername> | name of player to teleport to.",
	privs = {se_teleport=true},
	func = function(name, param)
		if param == nil then
			minetest.chat_send_player(name, "Please specify a player to teleport to!")
		elseif minetest.env:get_player_by_name(param) then
				local target = minetest.env:get_player_by_name(param)
				local sender = minetest.env:get_player_by_name(name)
				sender:setpos(target:getpos())
				minetest.chat_send_player(name, "Teleported to "..param..".")
		else
			minetest.chat_send_player(name, "That player is not online.")
		end
	end
})
minetest.register_privilege("se_clearinventory", "Permission to use /clearinventory to clear your inventory.")

minetest.register_privilege("se_clearinventory_admin", "Permission to use /clearinventory to clear your inventory.")
