--Set path variables.
local filespath = minetest.get_modpath(minetest.get_current_modname()) .. "/playerdata"
local configpath = minetest.get_modpath(minetest.get_current_modname()) .. "/ranks/config.txt"

--Load Configuration variables
dofile(configpath)

--Function to set privs
function set_privs(name, rank)

	--Load Playerdata file for player [name]
	dofile(filespath.."/"..name..'.txt')
	--Set privstring
	local privstring = Ranks[rank]["privs"]
	print(privstring)
	
	--Check for valid privstring
	if privstring ~= {} then
	
		--Set privs and print successful
		minetest.set_player_privs(name, minetest.string_to_privs(privstring))
		print("Giving priveleges ".. dump(minetest.string_to_privs(privstring)).." to "..name)
		return
	else
		--If privstring is not a string, print this error.
		print("Error setting priveleges: "..rank.."'s priv definitions are invalid!!!")
		return false;
	end

end

--When any player joins the server:
minetest.register_on_joinplayer(function(player)
	name = player:get_player_name()
	
	--Check for their playerdata file.
	local f = io.open(filespath..'/'..name..'.txt');
	
		--If it exists, then
		if (f) ~= nil then 
			f:close();
				
				--Load playerdata file for new player
				dofile(filespath.."/"..name..'.txt')
					
					--Check if it already has a rank set
					if rank == "" or rank == nil then
						
						--If not, write the default rank into their playerdata file and set default privs.
						local file = io.open(filespath..'/'..name..'.txt','a+')
						file:write("rank = \""..Default_Rank.."\" --[Changed at: "..Playerdata_Logstring.." by Server Main]\n")
						file:close()
						set_privs(name, Default_Rank)
					else
					
						--If so, set their privs (I do this for every player just in case of cheating.) [Overrides default priv settings]
						set_privs(name, rank)
					end
			return;
		else
			--If the playerdata file does not exist, create a new playerdata file and write the default rank into it, Give default privs to player.
			local file = io.open(filespath..'/'..name..'.txt','w')
			file:write("rank = \""..Default_Rank.."\" --[Changed at: "..Playerdata_Logstring.." by Server Main]\n")
			file:close()
			set_privs(name, Default_Rank)
			return;
		end		
end)

minetest.register_chatcommand('setrank',{
	description = 'Change a player\'s Rank.',
    privs = {se_admin=true},
	params = "<playername> <amount>| name of recepeient",
	func = function(name, param)
	local pname, rankname = string.match(param, "([^ ]+) (.+)")
	if pname == nil or pname == "" or rankname == nil or rankname == "" then
		minetest.chat_send_player(name, "Please enter a name and rank!")
	else
		local f = io.open(filespath..'/'..pname..'.txt');
			--If player file exists, then
			if (f) ~= nil then 
				f:close();
				--Load playerdata file for player
				dofile(filespath.."/"..pname..'.txt')
				print(tostring(_G[rankname]))
				if Ranks[rankname] == nil then
					minetest.chat_send_player(name, "Error: That rank does not exist!")
				return false;
				else
					--If not, write the rank into their playerdata file and set default privs.
					local file = io.open(filespath..'/'..name..'.txt','a+')
					file:write("rank = \""..rankname.."\" --[Changed at: "..Playerdata_Logstring.." by "..name.."]\n")
					file:close()
					set_privs(name, rankname)
					minetest.chat_send_player(name, "Rank "..rankname.." granted to "..pname.."!")
					return
				end
			else
			minetest.chat_send_player(name, "Error: that player does not exist!")
			return false;
			end
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
		local f = io.open(filespath..'/'..pname..'.txt');
			--If player file exists, then
			if (f) ~= nil then 
				f:close();
				--Load playerdata file for player
				local rankname = nil
				dofile(filespath.."/"..pname..'.txt')
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
				--If not, write the rank into their playerdata file and set default privs.
					local file = io.open(filespath..'/'..name..'.txt','a+')
					file:write("rank = \""..rankname.."\" --[Changed at: "..Playerdata_Logstring.." by "..name.."]\n")
					file:close()
					set_privs(name, rankname)
					minetest.chat_send_all("[ServerExtended]: "..pname.." promoted to "..rankname.." from "..lastrank..".")
					return
				end
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
		local f = io.open(filespath..'/'..pname..'.txt');
			--If player file exists, then
			if (f) ~= nil then 
				f:close();
				--Load playerdata file for player
				local rankname = nil
				dofile(filespath.."/"..pname..'.txt')
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
				--If not, write the rank into their playerdata file and set default privs.
					local file = io.open(filespath..'/'..name..'.txt','a+')
					file:write("rank = \""..rankname.."\" --[Changed at: "..Playerdata_Logstring.." by "..name.."]\n")
					file:close()
					set_privs(name, rankname)
					minetest.chat_send_all("[ServerExtended]: "..pname.." demoted to "..rankname.." from "..lastrank..".")
					return
				end
			end
		end
	end
})