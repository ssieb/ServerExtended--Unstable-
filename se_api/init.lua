filepath = minetest.get_worldpath()
se = {}

function save_player_data()
	local file = io.open(filepath .. "/playerdata.txt", "w")
	file:write(minetest.serialize(playerdata))
	file:close()
end

function load_player_data()
	local file = io.open(filepath .. "/playerdata.txt", "r")
	if file then
		local table = minetest.deserialize(file:read("*all"))
		if type(table) == "table" then
			return table
			
		end
	end
	return {}
end
