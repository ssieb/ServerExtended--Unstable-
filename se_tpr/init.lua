dofile(minetest.get_modpath(minetest.get_current_modname()).."/config.txt")

--Reset after configured delay.

local function reset_request(param)
	name = param[1]
        receiver = param[2]
	if not tpr_slist[name][receiver] then
		return
	end
     	minetest.chat_send_player(name, "Your teleport request to " ..receiver.. " has expired.")
	tpr_slist[name][receiver] = nil
	tpr_rlist[receiver] = nil
	tpr_dlist[receiver] = nil
end

--Teleport Request System

local function tpr_send(name, param)

	--Register variables

    	local sender = name
    	local receiver = param

	--Check for empty parameter

    	if receiver == "" then
            minetest.chat_send_player(sender, "Usage: /tpr <Player name>")
            return
     	end

	--If parameter is valid, Send teleport message and set the tables.

    	if minetest.env:get_player_by_name(receiver) then
		if tpr_slist[sender] == nil then
			tpr_slist[sender] = {}
		end
        	if tpr_slist[sender][receiver] then
      		minetest.chat_send_player(sender, "You already have a pending request to ".. receiver)
			return
		end
		if tpr_rlist[receiver] then
      		minetest.chat_send_player(sender, receiver .." already has a pending request, try later.")
			return
		end
        	tpr_slist[sender][receiver] = true
		tpr_rlist[receiver] = sender
		tpr_dlist[receiver] = "from"

		minetest.chat_send_player(receiver, sender .." is requesting to teleport to you. /tpy to accept.")
		minetest.chat_send_player(sender, "Teleport request sent! It will time out in ".. Timeout_Delay .." seconds.")
		--Teleport timeout delay
		minetest.after(Timeout_Delay, reset_request, {sender, receiver})
	else
		minetest.chat_send_player(sender, receiver ..' is not available.')
	end
end

local function tphr_send(name, param)

	--Register variables

    	local sender = name
    	local receiver = param

	--Check for empty parameter

    	if receiver == "" then
            minetest.chat_send_player(sender, "Usage: /tphr <Player name>")
            return
     	end

	--If parameter is valid, Send teleport message and set the tables.

    	if minetest.env:get_player_by_name(receiver) then
		if tpr_slist[sender] == nil then
			tpr_slist[sender] = {}
		end
        	if tpr_slist[sender][receiver] then
      		minetest.chat_send_player(sender, "You already have a pending request to ".. receiver ..".")
			return
		end
		if tpr_rlist[receiver] then
      		minetest.chat_send_player(sender, receiver .." already has a pending request, try later.")
			return
		end
        	tpr_slist[sender][receiver] = true
		tpr_rlist[receiver] = sender
		tpr_dlist[receiver] = "to"
	
		minetest.chat_send_player(receiver, sender .." is requesting that you teleport to them. /tpy to accept.")
		minetest.chat_send_player(sender, "Teleport request sent! It will time out in ".. Timeout_Delay .." seconds.")
		--Teleport timeout delay
		minetest.after(Timeout_Delay, reset_request, {sender, receiver})
	else
		minetest.chat_send_player(sender, receiver ..' is not available.')
	end
end

local function tpr_deny(name)
	local sender = tpr_rlist[name]
	if not sender then
		return
	end
	tpr_slist[sender][name] = nil
	tpr_rlist[name] = nil
	tpr_dlist[name] = nil
	minetest.chat_send_player(sender, "Teleport request to ".. name .."was denied.")
end

--Teleport Accept Systems

local function tpr_accept(name)

	local sender = tpr_rlist[name]
	
	if not sender then
		minetest.chat_send_player(name, "You don't have any teleport requests.")
		return
	end

	local target, mover
	if tpr_dlist[name] == "from" then
		minetest.chat_send_player(sender, "Teleporting you to ".. name ..".")
		minetest.chat_send_player(name, sender.." is teleporting to you.")
		mover = minetest.env:get_player_by_name(sender)
		target = minetest.env:get_player_by_name(name)
	else
		minetest.chat_send_player(sender, name .." is teleporting to you.")
		minetest.chat_send_player(name, "You are teleporting to " ..sender.. ".")
		mover = minetest.env:get_player_by_name(name)
		target = minetest.env:get_player_by_name(sender)
	end

	--Code here copied from Celeron-55's /teleport command. Thanks Celeron!

	local function find_free_position_near(pos)
		local tries = {
			{x=1,y=0,z=0},
			{x=-1,y=0,z=0},
			{x=0,y=0,z=1},
			{x=0,y=0,z=-1},
		}
		for _, d in ipairs(tries) do
			local p = {x = pos.x+d.x, y = pos.y+d.y, z = pos.z+d.z}
			local n = minetest.env:get_node(p)
			if not minetest.registered_nodes[n.name].walkable then
				return p, true
			end
		end
		return pos, false
	end

	--Get names from variables and set position. Then actually teleport the player.

	local p = nil
	p = target:getpos()
	p = find_free_position_near(p)
	mover:setpos(p)
	mover:setpos(p)
	mover:setpos(p)
	mover:setpos(p)
	mover:setpos(p)

	-- Set name values to nil to prevent re-teleporting on the same request.

	tpr_slist[sender][name] = nil
	tpr_rlist[name] = nil
	tpr_dlist[name] = nil
	return
end


--Initalize Table.

--Senders - contains arrays of requests indexed by sender
tpr_slist = {}
--Receivers - contains the sender's name
tpr_rlist = {}
--Directions ("to" or "from") indexed by receiver
tpr_dlist = {}

--Initalize Commands.

minetest.register_privilege("se_tpr", "Permission to request teleport to other players.")
minetest.register_privilege("se_tphr", "Permission to request other players to teleport to you.")

minetest.register_chatcommand("tpr", {
    description = "Request teleport to another player",
    params = "<playername> | leave playername empty to see help message",
    privs = {se_tpr=true},
    func = tpr_send

})

minetest.register_chatcommand("tphr", {
    description = "Request another player to teleport to you",
    params = "<playername> | leave playername empty to see help message",
    privs = {se_tphr=true},
    func = tphr_send

})

minetest.register_chatcommand("tpy", {
    description = "Accept teleport requests from another player",
	privs = {se_tpr=true},
    func = tpr_accept
})

minetest.register_chatcommand("tpn", {
    description = "Deny teleport requests from another player",
    privs = {se_tpr=true},
    func = tpr_deny
})

