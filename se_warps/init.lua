--Set path variables
local modpath = minetest.get_modpath(minetest.get_current_modname())
function save_warps_list()
	local file = io.open(minetest.get_worldpath() .. "/warpslist.txt", "w")
	if file then
		file:write(minetest.serialize(warps_list))
		file:close()
	end
end

function load_warps_list()
	local file = io.open(minetest.get_worldpath() .. "/warpslist.txt", "r")
	if file then
		local table = minetest.deserialize(file:read("*all"))
		if type(table) == "table" then
			return table
		end
	end
	return {}
end

warps_list=load_warps_list()
--Load configuration
dofile(modpath..'/config.txt')

--Warp checker function
function costwarp(name, param)
		local player = minetest.env:get_player_by_name(name)
		
		--Check if Cost_to_warp is enabled in config.
		if Cost_to_warp ~= false then
		
			--If so, check if Cost_to_warp is set to item.
			if Cost_to_warp == item then
			
				--Register and check Itemstack
				local itemstack = ItemStack(Warp_item ..' '.. Warp_item_amount)
				
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
				
				--If everything checks out ok, take the item and warp the player
					local playername = minetest.env:get_player_by_name(name)
					if playername:get_inventory():contains_item("main", itemstack) then
						playername:get_inventory():remove_item("main", itemstack)
						warp(name, param)
					else
					
					--If the player does not have the needed item, tell them that and do not warp.
					minetest.chat_send_player(name, 'You need to have '..Warp_item_amount..' '..Warp_item..'s to warp to a location.')
					return
					end
				end
			end
		else
		--If Cost_to_warp is set to false, warp the player.
		warp(name, param)
		end
end

--Set warp function
local function setwarp(name, param)
warps_list=load_warps_list()
local desc = ""
local wname = ""
if string.find(param, " ") ~= nil then
	if string.find(param, " ") >= 1 then
		print(param)
		wname, desc = string.match(param, "([^ ]+) (.+)")
	end
else
wname = param
desc = "Default Description"
print("no desc")
end
		--Check for a warp name, if none exists, notify player.
		if wname == nil or wname == "" then
			minetest.chat_send_player(name, 'Please provide a warp name.')
			return
		else
			--Register variables
			local player = minetest.env:get_player_by_name(name)
			local ppos = player:getpos()
			local msg = 'Warp '..wname..' set!'
				warps_list[wname] = ppos
				warps_list[wname]["desc"] = desc
				save_warps_list()
				warps_list=load_warps_list()
				--Notify player that warp has been set.
				minetest.chat_send_player(name, msg)

		end
end

--Warp function
function warp(name, param)
warps_list=load_warps_list()
		--Check to see if warp exists. If so, teleport player
			if warps_list[param] ~= nil then
				local player = minetest.env:get_player_by_name(name)
				minetest.chat_send_player(name, 'Warping to location...')
				player:setpos(warps_list[param])
			return
			end
end

--Delete warp function
local function delwarp(name, param)
warps_list=load_warps_list()
	--If no warp is specified, notify player
	if param == nil or param == "" then
		minetest.chat_send_player(name, 'Please specify a valid warp.')
	return
	else
		
		--Check if warp exists. If so, delete the warp.
		if warps_list[param] == nil then
		--If warp does not exist, notify player.
			minetest.chat_send_player(name, 'Warp does not exist.')
		return false;
		else
			warps_list[param] = nil
			save_warps_list()
			warps_list=load_warps_list()
			minetest.chat_send_player(name, 'Warp removed!')
			return
		end
	end
end

function show_warps(name)
	warps_list=load_warps_list()
	if Warp_GUI == true then
		local int = 0
		value = "size[10,10]button_exit[0,8;3,2;close1; Close]label[0,0;Warp:]label[4,0;Description:]"
		for k,v in pairs(warps_list) do
			local size = k:len() / 4
			k = tostring(k)
			value = value.."button_exit[0,"..tostring(int)..";"..size..",3;"..tostring(k)..";"..tostring(k).."]label[4,"..tostring(int+1)..";"..tostring(warps_list[k]["desc"]).."]"
			int = int+1
		end
		minetest.show_formspec(name, "warpslist", tostring(value))
	else
		for k,v in pairs(warps_list) do
			msg = msg..tostring(k)..": "..tostring(warps_list[k]["desc"]).." \n"
		end
		minetest.chat_send_player(name, msg)
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname == "warpslist" then
			for k,v in pairs(warps_list) do
				if fields[k] == k then
					name = player:get_player_name()
					costwarp(name, tostring(fields[k]))
				end
			end
		end
end)

--Register Commands
minetest.register_chatcommand('warp',{
	description = 'Warp to location',
	params = "<warpname> | name of warp",
	privs = {se_warps = true},
	func = function(name, param)
	warps_list = load_warps_list()
	if param == nil or param == "" or not warps_list[param] then
		msg = "Warps:\n"
		show_warps(name)
		
	return
	else
	costwarp(name, param)
	end
end
})

minetest.register_chatcommand('setwarp',{
	description = 'Set a warp',
	params = "<warpname> | name of warp",
	privs = {se_admin = true},
	func = setwarp
})

minetest.register_chatcommand('delwarp',{
	description = 'Delete a warp',
	params = "<warpname> | name of warp",
	privs = {se_admin = true},
	func = delwarp
})
