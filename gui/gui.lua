local path = minetest.get_modpath(minetest.get_current_modname())
--Set path variables.
local filespath = minetest.get_modpath(minetest.get_current_modname()) .. "/playerdata"
local configpath = minetest.get_modpath(minetest.get_current_modname()) .. "/ranks/config.txt"

--Load Configuration variables
dofile(configpath)
se = {}

if Show_On_Start == true then
	minetest.register_on_joinplayer(function(player)
	se.show_profile()
	print(tostring(player))
	end)
end

function se.show_profile(player)
local pdata = minetest.env:get_player_by_name(player)
		local profile = "size[15,10]"..
			"label[0,0;"..name.."'s Profile:]"..
			"image_button[0,0.6;3,3;serverextended_avatar_av1.png;Avatar; ]"..
			"button[3,0;2,2;Messaging;Messaging]"..
			"button[5,0;2,2;Friends;Friends]"..
			"button[7,0;2,2;Server;Server]"..
			"button[9,0;2,2;Go_Home;Go Home]"..
			"button[11,0;2,2;Warp;Warp]"..
			"button[13,0;2,2;Settings;Settings]"..
			"button[13,0;2,2;Settings;Settings]"..
			"label[0,4;Location:]"..
			"label[0,4.3;LOCATION]"..
			"label[0,5;Join date:]"..
			"label[0,5.3;"..os.date("%d.%m.%Y").."]"..
			"label[0,6;Status:]"..
			"label[0,6.3;Working on ServerExtended]"..
			"label[0,7;Current Position:]"..
			"label[0,7.3;"..dump(pdata:getpos())..":]"..
			"label[3,1.3;About Me:]"..
			"label[3,1.7;WEARHIWERAKEWKKKKKKKKKKKKKKKKKAWWWWWWWWWWWWWWWWW]"

		minetest.show_formspec(player, "profile", profile)
end

minetest.register_chatcommand('profile',{
	description = 'Show your profile',
	privs = {},
	func = se.show_profile
})