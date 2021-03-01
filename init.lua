local playerlist = {
	huds = {}
}

function playerlist.iterator()
	return ipairs(minetest.get_connected_players())
end

function playerlist.count()
	return #minetest.get_connected_players()
end

controls.register_on_press(function(user, key)
	if key == "sneak" then
		local user_name = user:get_player_name()
		local huds = {user:hud_add({
			hud_elem_type = "image",
			position = {x = 0.5, y = 0},
			offset = {x = 0, y = 20},
			text = "playerlist_background.png",
			alignment = {x = 0, y = 1},
			scale = {x = 400, y = playerlist.count() * 18 + 8},
			number = 0xFFFFFF,
		})}
		for i, player, color, text in playerlist.iterator() do
			local name = player:get_player_name()
			local ping = math.max(1, math.ceil(4 - minetest.get_player_information(name).avg_rtt * 50))			
			table.insert(huds, user:hud_add({
				hud_elem_type = "text",
				position = {x = 0.5, y = 0},
				offset = {x = 0, y = 23 + (i - 1) * 18},
				text = text or name,
				alignment = {x = 0, y = 1},
				scale = {x = 100, y = 100},
				number = color or 0xFFFFFF,
			}))
			table.insert(huds, user:hud_add({
				hud_elem_type = "image",
				position = {x = 0.5, y = 0},
				offset = {x = -195, y = 20 + (i - 1) * 18},
				text = "server_ping_" .. ping .. ".png",
				alignment = {x = 1, y = 1},
				scale = {x = 1.5, y = 1.5},
				number = 0xFFFFFF,
			}))
		end
		playerlist.huds[user_name] = huds
	end
end)

controls.register_on_release(function(user, key)
	if key == "sneak" and user then
		for _, id in pairs(playerlist.huds[user:get_player_name()]) do
			user:hud_remove(id)
		end
	end
end)
 
