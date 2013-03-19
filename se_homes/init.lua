--Set path variables.
local modpath = minetest.get_modpath(minetest.get_current_modname())
--Load configuration
dofile(modpath..'/config.txt')
playerdata = load_player_data()

--Sethome checker function
local function costsethome(name, param)
playerdata = load_player_data()

		local player = minetest.env:get_player_by_name(name)
		
		--Check if Cost_to_sethome is enabled in config.
		if Cost_to_sethome ~= false then
		
			--If so, check if Cost_to_sethome is set to item.
			if Cost_to_sethome == item then
			
				--Register and check Itemstack
				local itemstack = ItemStack(Sethome_item ..' '.. Sethome_item_amount)
				
				--If Config variable does not exist
				if itemstack:is_empty() then
					minetest.chat_send_player(name, 'Error: cannot take an empty item. Please contact the server administrator.')
					print('Error: cannot take an empty item. Please contact the server administrator.')

				return
				--If Config variable is unknown.
				elseif not itemstack:is_known() then
					minetest.chat_send_player(name, 'Error: cannot take an unknown item. Please contact the server administrator.')
					print('Error: cannot take an unknown item. Please contact the server administrator.')

				return
				else
					
					--If everything checks out ok, take the item and set the player's home
					local playername = minetest.env:get_player_by_name(name)
					if playername:get_inventory():contains_item("main", itemstack) then
						playername:get_inventory():remove_item("main", itemstack)
						sethome(name, param)
					else
					
					--If the player does not have the needed item, tell them that and do not sethome.
					minetest.chat_send_player(name, 'You need to have '..Sethome_item_amount..' '..Sethome_item..'s to sethome.')
					return
					end
				end
			end
		else
		
		--If Cost_to_sethome is set to false, set the player's home.
		sethome(name, param)
		end
end

local function costhome(name, param)
playerdata = load_player_data()

		local player = minetest.env:get_player_by_name(name)

		--Check if Cost_to_home is enabled in config.
		if Cost_to_home ~= false then
		
			--If so, check if Cost_to_sethome is set to item.
			if Cost_to_home == item then
			
				--Register and check Itemstack
				local itemstack = ItemStack(Home_item ..' '.. Home_item_amount)
				
				--If Config variable does not exist
				if itemstack:is_empty() then
					minetest.chat_send_player(name, 'Error: cannot take an empty item. Please contact the server administrator.')
					print('Error: cannot take an empty item. Please contact the server administrator.')

				return
				
				--If Config variable is unknown.
				elseif not itemstack:is_known() then
					minetest.chat_send_player(name, 'Error: cannot take an unknown item. Please contact the server administrator.')
					print('Error: cannot take an unknown item. Please contact the server administrator.')

				return
				else
				
					--If everything checks out ok, take the item and set the player's home
					local playername = minetest.env:get_player_by_name(name)
					if playername:get_inventory():contains_item("main", itemstack) then
						playername:get_inventory():remove_item("main", itemstack)
						home(name, param)
					else
					
					--If the player does not have the needed item, tell them that and do not sethome.
					minetest.chat_send_player(name, 'You need to have '..Home_item_amount..' '..Home_item..'s to teleport to your home.')
					return
					end
				end
			end
		else
		home(name, param)
		end
end

--Set the players home
function sethome(name, param)
		
		--Register variables
		local player = minetest.env:get_player_by_name(name)
		local ppos = player:getpos()
		local msg = 'Home set!'
		
		--Check for playerdata file, if so, write the home position.
		playerdata = load_player_data()
			if playerdata[name] then
				print('Player '..name..' has set a home at '.. minetest.pos_to_string(ppos)..'.')
				playerdata[name]['home'] = minetest.pos_to_string(ppos)
				save_player_data()
				playerdata = load_player_data()
				minetest.chat_send_player(name, msg)
			else
			
				--If not, notify player and admin.
				print("Error: Unable to locate playerdata file.")
				minetest.chat_send_player(name, 'Unable to find playerdata file, please contact an admin')
			end
end

--Main home function
function home(name, param)

	--Register playername and load playerdata file.
	local player = minetest.env:get_player_by_name(name)
	playerdata = load_player_data()
	--Check to ensure home is set, if so, set the player's position.
	if playerdata[name]['home'] then
		local ppos = minetest.string_to_pos(playerdata[name]['home'])
		minetest.chat_send_player(name, 'Teleporting to home...')
		player:setpos(ppos)
	else
		--If not, send a message to the player and return.
		minetest.chat_send_player(name, 'You have not set a home. Set a home with /sethome.')
		return
	end
end


--Registering Commands
minetest.register_chatcommand('home',{
	description = 'Teleport you to your home.',
	privs = {se_homes = true},
	func = costhome
})

minetest.register_chatcommand('sethome',{
	description = 'Set your home teleport',
	params = "<homename> | name of home (optional)",
	privs = {se_homes = true},
	func = costsethome
})
