local configpath = minetest.get_modpath(minetest.get_current_modname()) .. "/config.txt"
dofile(configpath)


playerdata = load_player_data()

--Make /spawn go to a spawnpoint set by admins if it exists.
minetest.register_chatcommand("spawn", {
	params = "",
	privs = {se_player = true},
	description = "Set the spawn point.",
	func = function(name, param)
	local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
			return
		end
		player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
	end
})

--Suicide Command
minetest.register_chatcommand("suicide", {
	params = "",
	privs = {se_player = true},
	description = "Kill yourself...",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		if Allow_Suicide == true then
			minetest.chat_send_all(name.." killed himself.")
			player:set_hp(0)
		else
			minetest.chat_send_player(name, "The server owner does not allow suicide.")
		return
		end
	end
})


if Allow_Messaging == true then

--Message Send System
local function message_send(name, param)

	--Register Variables
	local receiver, message = string.match(param, "([^ ]+) (.+)")
   	local sender = name
		
		--Check for proper usage.
    	if receiver == "" or message == "" or receiver == nil or message == nil then
            minetest.chat_send_player(sender, "Usage: /m [name] [message]")
            return
     	end

		--Do the message and set tables for reply
    	if minetest.env:get_player_by_name(receiver) then
            minetest.chat_send_player(receiver, sender..' -> you: '..message)
            minetest.chat_send_player(sender, 'you -> '..receiver..': '..message)
	
        	message_list[receiver] = nil
        	message_list[receiver] = sender
		end
end

--Message Reply System

local function message_reply(name, param)

	--Register variables.
	local message = param
	local receiver = name
	local sender = message_list[name]
	
	--Check for proper params
	if message_list[name] == nil or message == "" or message == nil then
            minetest.chat_send_player(name, "Usage: If someone has sent a message to you already, you can reply with /r [message].")

		return
	end
	
	--Reply to player
	if message_list[name] then
		minetest.chat_send_player(message_list[receiver], receiver..' -> you: '..message)
		minetest.chat_send_player(receiver, 'you -> '..receiver..': '..message)

		return
	end
	
end


--Initalize Table.

message_list = {}


--Initalize Commands.

minetest.register_chatcommand("m", {
    description = "Message another player. /m [name] [message]",
    params = "<playername> | leave playername empty to see help message",
    privs = {se_player=true},
    func = message_send

})

minetest.register_chatcommand("t", {
    description = "Message another player. /m [name] [message]",
    params = "<playername> | leave playername empty to see help message",
    privs = {se_player=true},
    func = message_send

})

minetest.register_chatcommand("message", {
    description = "Message another player. /m [name] [message]",
    params = "<playername> | leave playername empty to see help message",
    privs = {se_player=true},
    func = message_send

})

minetest.register_chatcommand("r", {
    description = "Reply to the last player who messaged you. /r [message]",
    privs = {se_player=true},
    func = message_reply
})

minetest.register_chatcommand("reply", {
    description = "Reply to the last player who messaged you. /r [message]",
    privs = {se_player=true},
    func = message_reply
})

end

minetest.register_chatcommand('info',{
	description = 'View player info.',
    privs = {se_player=true},
	params = "<player> Name of player",
	func = function(name, param)
	playerdata = load_player_data()
	if param == nil or param == "" then
		minetest.chat_send_player(name, "Type /info [playername] to view [playername]'s information.")
	elseif not playerdata[param] then
		minetest.chat_send_player(name, "There is no player by that name. Type /players to see all registered players.")
		return false
	else
		local list = param.."'s Information\n"
		playerdata = load_player_data()
		for k,v in pairs(playerdata[param]) do
		list = list..k..": "..tostring(v).."\n"
		end
		minetest.chat_send_player(name, list)
	end
end
})

minetest.register_chatcommand('players',{
	description = 'View player list.',
    privs = {se_player=true},
	params = "",
	func = function(name)
	local list = "List of all registered players:\n"
	playerdata = load_player_data()
	for k,v in pairs(playerdata) do
	list = list..k.."\n"
	end
		minetest.chat_send_player(name, list)

end
})

minetest.register_chatcommand('nick',{
	description = 'Set the nick for a player.',
    privs = {se_nick=true},
	params = "<playername>",
	func = function(name, param)
	if param == nil or param == "" then
		if playerdata[name]['nick'] then
			playerdata[name]['nick'] = nil
			save_player_data()
			minetest.chat_send_player(name, "Nickname removed.")
		else
			minetest.chat_send_player(name, "Please enter a valid name and nickname! /nick [name] [nickname]")
		end
	else
		local pname, nick = string.match(param, "([^ ]+) (.+)")
		print(tostring(pname)..": "..tostring(nick))
		playerdata = load_player_data()
		if nick == nil then
		nick = param
		playerdata[name]['nick'] = nick
		save_player_data()
		minetest.chat_send_player(name, "Your nickname has been changed to "..nick..".")
		return
	else
		if nick == "reset" and playerdata[pname] then
			playerdata[pname]['nick'] = nil
			save_player_data()
			minetest.chat_send_player(pname, "Your nickname has been removed.")
			minetest.chat_send_player(name, pname.."'s nickname removed.")
		elseif playerdata[pname] and nick ~= "clear" then
			playerdata[pname]['nick'] = nick
			save_player_data()
			minetest.chat_send_player(name, "Nickname: "..nick.." Set for player "..pname..".")
		else
			minetest.chat_send_player(name, "That name does not exist.\nType /players for a list of all players registered on this server.")
			return false
		end
	end
end

end
})
