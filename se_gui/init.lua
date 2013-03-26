local path = minetest.get_modpath(minetest.get_current_modname())
--Set path variables.
local mainconfig = minetest.get_modpath(minetest.get_current_modname()) .. "/config.txt"

--Load Configuration variables
dofile(mainconfig)

playerdata = load_player_data()
se = {}

function se.show_profile(player, mode, sender)
playerdata = load_player_data()
if not playerdata[player]['status'] then
print("test")
playerdata[player]['status'] = "Default Status"
playerdata[player]['location'] = "Default Location"
playerdata[player]['about_me'] = "New Player"
save_player_data()
playerdata = load_player_data()
end
local profile = ""
	local pdata = minetest.env:get_player_by_name(player)
	if not info then info = "" end
	if mode == "Edit" then
		profile = "size[15,10]"..
			"label[0,0;"..player.."'s Profile:]"..
			"image_button[0,0.6;3,3;serverextended_avatar_av1.png;Avatar; ]"..
			"button[13,0;2,2;Save;Save]"..
			"label[0,4;Location:]"..
			"field[0.3,5.1;3,0;location;;"..playerdata[player]['location'].."]"..
			"label[0,5;Status:]"..
			"field[0.3,6.1;3,0;status;;"..playerdata[player]['status'].."]"..
			"label[0,6;Join date:]"..
			"label[0,6.3;"..playerdata[player]['join_date'].."]"..
			"label[3,2.3;About Me:]"..
			"field[3.2,1.7;8,4;aboutme;;"..playerdata[player]['about_me'].."]"..
			"field[223.2,1.7;8,4;name;;"..player.."]"

	else
		profile = "size[15,10]"..
			"label[0,0;"..player.."'s Profile:]"..
			"image_button[0,0.6;3,3;serverextended_avatar_av1.png;Avatar; ]"..
			"button[3,9;2,2;Messaging;Messaging]"..
			"button[5,9;2,2;Friends;Friends]"..
			"button[7,9;2,2;Server;Server]"..
			"button[9,9;2,2;Go_Home;Go Home]"..
			"button[11,9;2,2;Warp;Warp]"..
			"button[13,9;2,2;Settings;Settings]"..
			"label[0,4;Location:]"..
			"label[0,4.3;"..playerdata[player]['location'].."]"..
			"label[0,5;Status:]"..
			"label[0,5.3;"..playerdata[player]['status'].."]"..
			"label[0,6;Join date:]"..
			"label[0,6.3;"..playerdata[player]['join_date'].."]"..
			"label[3,0;Info Bar: "..info.."]"..
			"label[3,0.5;About Me:]"..
			"label[3,0.8;"..playerdata[player]['about_me'].."]"..
			"field[223.2,1.7;8,4;name;;"..player.."]"


	end
	if Ranks == true then
			profile = profile.."label[0,7;Rank:]".."label[0,7.3;"..playerdata[player]['rank'].."]"
	end
		minetest.show_formspec(sender, "profile", profile)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname == "profile" then
				local target = nil
				if fields.name ~= player:get_player_name() then
					target = fields.name
					name = player:get_player_name()
				else
					target = player:get_player_name()
					name = player:get_player_name()
				end
				if fields.Settings == "Settings" then
					se.show_profile(name, "Edit", target)
				end
				if fields.Save == "Save" then
					playerdata[name]['location'] = tostring(fields.location)
					playerdata[name]['status'] = tostring(fields.status)
					playerdata[name]['about_me'] = tostring(fields.aboutme)
					save_player_data()
					playerdata = load_player_data()
					local info = "Settings saved!"
					se.show_profile(name, "default", target)
				end
				if fields.Warp == "Warp" then
					show_warps(name)
				end
		end
end)

minetest.register_chatcommand('profile',{
	description = 'Show your profile',
    params = "<playername> | Playername of profile you are accessing.",
	privs = {},
	func = function(name, param)
		playerdata = load_player_data()
		if param == nil or param == "" or not playerdata[param] then
			local player = name
			se.show_profile(player, "default", name)
		else
			local player = param
			se.show_profile(player, "default", name)
		end
	end
})