local path = minetest.get_modpath(minetest.get_current_modname())

local version = "0.5"
local enabled_mods = {}
dofile(path.."/config.txt")

if Ranks_Module == true then

	table.insert(enabled_mods, "Ranks Module Loaded")
	
end

if TeleportRequest_Module == true then

	table.insert(enabled_mods, "TeleportRequest Module Loaded")

end

if Homes_Module == true then

	table.insert(enabled_mods, "Homes Module Loaded")

end

if Warps_Module == true then

	table.insert(enabled_mods, "Warps Module Loaded")

end

if Economy_Module == true then

	table.insert(enabled_mods, "Economy Module Loaded")

end

if Player_Extras_Module == true then

	table.insert(enabled_mods, "Player Extras Commands Module Loaded")

end

if Admin_Tools_Module == true then

	table.insert(enabled_mods, "Admin Tools Commands Module Loaded")

end

if GUI_Module == true then

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
minetest.register_privilege("se_warps", "Permission to use /warp.")
minetest.register_privilege("se_nick", "Permission to use /nick.")
minetest.register_privilege("se_god", "Permission to use /god.")
minetest.register_privilege("se_heal", "Permission to use /heal.")
minetest.register_privilege("se_teleport", "Permission to use /tp.")
minetest.register_privilege("se_time", "Permission to use time commands.")




minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()
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
	local pname = player:get_player_name()
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

if type(Chat_String) == "string" then
minetest.register_on_chat_message(function(name, message)
	playerdata = load_player_data()
	local chatmessage = string.gsub(Chat_String, "(&message)", message)
	chatmessage = string.gsub(chatmessage, "(&rank)", tostring(playerdata[name]['rank']))
	chatmessage = string.gsub(chatmessage, "(&dname)", name)
	if playerdata[name]['nick'] then
	chatmessage = string.gsub(chatmessage, "(&nick)", "~"..tostring(playerdata[name]['nick']))
	chatmessage = string.gsub(chatmessage, "(&name)", "~"..tostring(playerdata[name]['nick']))
	else
	chatmessage = string.gsub(chatmessage, "(&nick)", '')
	chatmessage = string.gsub(chatmessage, "(&name)", name)
	end
	minetest.chat_send_all(chatmessage)
	return true
end)

end

minetest.register_chatcommand('restart',{
	description = 'Restart the Server.',
	privs = {se_admin = true},
	func = function(name, param)
	local rtime = nil
	if param == nil or param == "" then
		rtime = 20
	elseif(param:find("%D+")) then
		rtime = 20
	else 
		rtime = tonumber(param)
	end
	minetest.chat_send_all(name.." is restarting the server!")
	local i = rtime
	local function timer()
		if i < 1 then 
			minetest.chat_send_all("Server Restarting")
			minetest.request_shutdown()
		else
			i = i-1
			minetest.chat_send_all("Restarting in: "..i)
			minetest.after(1.0, timer)
		end
	end
	timer()
end
})

