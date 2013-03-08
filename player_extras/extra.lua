local filespath = minetest.get_modpath(minetest.get_current_modname()) .. "/playerdata"
local configpath = minetest.get_modpath(minetest.get_current_modname()) .. "/player_extras/config.txt"
dofile(configpath)

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
