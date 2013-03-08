local filespath = minetest.get_modpath(minetest.get_current_modname()) .. "/playerdata"
local configpath = minetest.get_modpath(minetest.get_current_modname()) .. "/economy/config.txt"

dofile(configpath)
minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()
	dofile(filespath..'/'..pname..'.txt')
		if balance == nil or balance == "" then
			local file = io.open(filespath..'/'..pname..'.txt','a+')
			file:write("balance = "..StartingBalance.." --[Changed at: "..Playerdata_Logstring.."]\n")
			file:close()
		end
	dofile(filespath..'/'..pname..'.txt')
end)

if UseItems == true then
	minetest.register_craftitem("serverextended:goldcoin", {
		description = "Gold coin",
		inventory_image = "serverextended_goldcoin.png",
		wield_image = "serverextended_blank.png",
	})
	minetest.register_craftitem("serverextended:ironcoin", {
		description = "Iron coin",
		inventory_image = "serverextended_ironcoin.png",
		wield_image = "serverextended_blank.png",

	})
	minetest.register_craftitem("serverextended:bronzecoin", {
		description = "Bronze coin",
		inventory_image = "serverextended_bronzecoin.png",
		wield_image = "serverextended_blank.png",

	})
end
minetest.register_chatcommand('bal',{
	description = 'Check your balance.',
	privs = {se_economy=true},
	params = "",
	func = function(name, param)
	if param == "" or param == nil then
		dofile(filespath..'/'..name..'.txt')
		minetest.chat_send_player(name, "Your Balance: "..balance..' '..Primary_currency_name..".")
		return
	else
	local f = io.open(filespath..'/'..param..'.txt');
		if (f) then 
			f:close(); 
			dofile(filespath..'/'..param..'.txt')
			minetest.chat_send_player(name, param.."'s Balance: "..balance..' '..Primary_currency_name..".")
		else
			minetest.chat_send_player(name, "Invalid Playername.")
		return false; 
		end
	end
end
})

minetest.register_chatcommand('pay',{
	description = 'Check your balance.',
    privs = {se_economy=true},
	params = "<playername> <amount>| name of recepeient",
	func = function(name, param)
	local pname, amount = string.match(param, "([^ ]+) (.+)")
	if pname == "" or pname == nil then
		minetest.chat_send_player(name, "Please specify who you want to pay!")
		return
	else
	local f = io.open(filespath..'/'..pname..'.txt');
		if (f) then 
			f:close();
			dofile(filespath..'/'..name..'.txt')
			if tostring(balance) >= amount then
				print(tostring(balance))
				print(amount)
				local p1balance = balance - amount
				dofile(filespath..'/'..pname..'.txt')
				local p2balance = balance + amount
				local file = io.open(filespath..'/'..pname..'.txt','a+')
				file:write("balance = "..p2balance.." --[Changed at: "..Playerdata_Logstring.." by "..name.."]\n")
				file:close()
				local file = io.open(filespath..'/'..name..'.txt','a+')
				file:write("balance = "..p1balance.." --[Changed at: "..Playerdata_Logstring.." by "..name.."]\n")
				file:close()
				minetest.chat_send_player(name, "You have given "..amount.." "..Primary_currency_name.." to "..pname..".")
				minetest.chat_send_player(pname, amount.." "..Primary_currency_name.." has been received from "..name..".")
			return;
			else
				minetest.chat_send_player(name, "You must have at least "..amount.." " ..Primary_currency_name.." to give.")
			return;
			end
		else
			minetest.chat_send_player(name, "Invalid Playername.")
		return false; 
		end
	end
end
})

minetest.register_node("serverextended:bank", {
	description = "Bank",
	tiles = {"serverextended_bank.png"},
    inventory_image = minetest.inventorycube("serverextended_bank.png"),
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				"list[current_name;main;0,0;8,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Bank")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})

minetest.register_privilege("se_economy", "Permission to use economy commands and system.")