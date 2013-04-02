local configpath = minetest.get_modpath(minetest.get_current_modname()) .. "/config.txt"
playerdata = load_player_data()
dofile(configpath)

minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()
		if not playerdata[pname]['balance'] then
			playerdata[pname]['balance'] = StartingBalance
			save_player_data()
		end
end)


minetest.register_chatcommand('bal',{
	description = 'Check your balance.',
	privs = {se_economy=true},
	params = "",
	func = function(name, param)
	playerdata = load_player_data()
	if param == "" or param == nil then
		local balance = playerdata[name]['balance']
		minetest.chat_send_player(name, "Your Balance: "..balance..' '..Primary_currency_name..".")
		return
	elseif playerdata[param] then
		local balance = playerdata[param]['balance']
		minetest.chat_send_player(name, param.."'s Balance: "..balance..' '..Primary_currency_name..".")
	else
		minetest.chat_send_player(name, param.." Has not joined this server or does not exist.")
	end

end
})

minetest.register_chatcommand('pay',{
	description = 'Check your balance.',
    privs = {se_economy=true},
	params = "<playername> <amount>| name of recepeient",
	func = function(name, param)
	local pname, amount = string.match(param, "([^ ]+) (.+)")
	playerdata = load_player_data()
	if pname == "" or pname == nil or type(amount) ~= "number" then
		minetest.chat_send_player(name, "Please specify who you want to pay!")
		return
	else
		if playerdata[pname] then 
			local p1balance = playerdata[name]['balance']
			local p2balance = playerdata[name]['balance']
			if tostring(p1balance) >= amount then
				print(tostring(balance))
				print(amount)
				playerdata[name]['balance'] = p1balance - amount
				playerdata[pname]['balance'] = balance + amount
				save_player_data()
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


minetest.register_privilege("se_economy", "Permission to use economy commands and system.")


minetest.register_node("se_economy:showcase", {
	description = "Showcase",
	tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
	is_ground_content = true,
	groups = {crumbly=3},
	drop = 'se_economy:showcase',
	on_place = function(itemstack, placer, pointed_thing)
		minetest.env:add_item({x=pointed_thing.under.x, y=pointed_thing.under.y+1, z=pointed_thing.under.z}, "se_economy:showcase")
		minetest.env:add_node(pointed_thing.under, "se_economy:showcase")
	end
})