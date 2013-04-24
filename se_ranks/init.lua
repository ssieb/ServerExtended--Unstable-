--Set path variables.
local configpath = minetest.get_modpath(minetest.get_current_modname()) .. "/config.txt"

playerdata = load_player_data()
--Load Configuration variables
dofile(configpath)

--Function to set privs
function set_privs(pname, rank)
if Ranks[rank] then
	local privstring = Ranks[rank]["privs"]
	
		--Check for valid privstring
		if type(privstring) == "string" then
	
		--Set privs and print successful
			minetest.set_player_privs(pname, minetest.string_to_privs(privstring))
			print("Giving priveleges ".. dump(minetest.string_to_privs(privstring)).." to "..pname)
			return
		else
			--If privstring is not a string, print this error.
			print("Error setting priveleges: "..rank.."'s priv definitions are invalid!!!")
			return false;
		end
	else 
	minetest.chat_send_player(pname, rank.." does not exist.")
	end
end

function set_rank(pname, rank)
	if not playerdata[pname] then
	playerdata[pname] = {}
	end
	playerdata[pname]['rank'] = rank
	save_player_data()
	playerdata = load_player_data()

end

minetest.register_on_newplayer(function(player)
	local pname = player:get_player_name()
	if not playerdata[pname] then
	playerdata[pname] = {}
	save_player_data(playerdata)
	playerdata = load_player_data()
	set_privs(pname, Default_Rank)
	end
end)

--When any player joins the server:
minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()
	if playerdata[pname]['rank'] == nil then
		playerdata[pname]['rank'] = Default_Rank
		save_player_data()
		playerdata = load_player_data()
		set_privs(pname, Default_Rank)
	else
		playerdata = load_player_data()
		set_privs(pname, playerdata[pname]['rank'])
	end
	
end)



minetest.register_chatcommand('setrank',{
	description = 'Change a player\'s Rank.',
    privs = {se_admin=true},
	params = "<playername> <rank>| Name of player, Name of rank",
	func = function(name, param)
	playerdata = load_player_data()
	local pname, rankname = string.match(param, "([^ ]+) (.+)")
	if pname == nil or pname == "" or rankname == nil or rankname == "" then
		minetest.chat_send_player(name, "Please enter a name and rank!")
	elseif not playerdata[pname] then
		minetest.chat_send_player(name, "Invalid player name")
	elseif not Ranks[rankname] then
		minetest.chat_send_player(name, "There is no rank by that name. Type /ranks to see all available ranks.")
	else
		set_rank(pname, rankname)
		set_privs(pname, rankname)
		minetest.chat_send_player(name, "Rank "..rankname.." set for "..pname..".")
	end
end
})

minetest.register_chatcommand('promote',{
	description = 'Promote a player to the next rank up',
    privs = {se_admin=true},
	params = "<playername>| name of recepeient",
	func = function(name, param)
	local pname = param
	if pname == nil or pname == "" then
		minetest.chat_send_player(name, "Please specify a player to be promoted!")
	else
		playerdata = load_player_data()
		if playerdata[pname] then
		local rank = playerdata[pname]['rank']
			--If player file exists, then
			if rank ~= nil then 
				--Load playerdata file for player
				local rankname = nil
				local int = Ranks[rank]["ranklevel"]
				local lastrank = rank
				for k,v in pairs(Ranks) do
					if Ranks[tostring(k)]["ranklevel"] == int + 1 then
						rankname = tostring(k)
						print(int)
						print(tostring(k))
					end
				end
				if rankname == "" or rankname == nil then
					minetest.chat_send_player(name, "Unable to promote any higher!")
					return false;
				else
				--If not, write the rank into the playerdata file and set default privs.
					set_rank(pname, rankname)
					set_privs(pname, rankname)
					minetest.chat_send_all("[ServerExtended]: "..pname.." promoted to "..rankname.." from "..lastrank..".")
					return
				end
			end
		else
		minetest.chat_send_player(name, "Unknown player")
		end
		end
	end
})

minetest.register_chatcommand('demote',{
	description = 'Demote a player to the next rank down.',
    privs = {se_admin=true},
	params = "<playername>| name of recepeient",
	func = function(name, param)
	local pname = param
	if pname == nil or pname == "" then
		minetest.chat_send_player(name, "Please specify a player to be demoted!")
	else
		playerdata = load_player_data()
		if playerdata[pname] then
		local rank = playerdata[pname]['rank']
			--If player file exists, then
			if rank ~= nil then 
				--Load playerdata file for player
				local rankname = nil
				local int = Ranks[rank]["ranklevel"]
				local lastrank = rank
				for k,v in pairs(Ranks) do
					if Ranks[tostring(k)]["ranklevel"] == int - 1 then
						rankname = tostring(k)
						print(int)
						print(tostring(k))
					end
				end
				if rankname == "" or rankname == nil then
					minetest.chat_send_player(name, "Unable to demote any lower!")
					return false;
				else
				--If not, write the rank into the playerdata file and set default privs.
					set_rank(pname, rankname)
					set_privs(pname, rankname)
					minetest.chat_send_all("[ServerExtended]: "..pname.." demoted to "..rankname.." from "..lastrank..".")
					return
				end
			end
		else
		minetest.chat_send_player(name, "Unknown player")
		end
		end
	end
})

minetest.register_chatcommand('updateranks',{
	description = 'Reload the ranks list.',
    privs = {se_admin=true},
	params = "",
	func = function(name)
		dofile(configpath)
		minetest.chat_send_player(name, "Ranks list updated!")
	end
})


minetest.register_chatcommand('ranks',{
	description = 'View the ranks list.',
    privs = {se_admin=true},
	params = "<rankname> Name of rank",
	func = function(name, param)
	if param == nil or param == "" then
		minetest.chat_send_player(name, "Type /ranks [rank name] to view privleges of that rank.")
		for k,v in pairs(Ranks) do
			minetest.chat_send_player(name, k..",\n")
		end
	elseif not Ranks[param] then
		minetest.chat_send_player(name, "There is no rank by that name. Type /ranks to see all ranks.")
		return false
	else
		minetest.chat_send_player(name, Ranks[param]["privs"])
	end
end
})

