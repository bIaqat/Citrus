getPlayers = function(speaker, ...) --Useful for Admin Scripts
	local players = {};
	local listOfNames = setmetatable({},{
		__index = function(self, index)
			for name,_ in next, self do
				if index:lower():sub(1,#name) == name then
					return true
				end
			end
		end
	});
	for _, name in next, {...} do
		listOfNames[name:lower()] = true;
	end
	for _, player in next, game:GetService'Players':GetPlayers() do
		local p = (listOfNames['all'] or (listOfNames['others'] and player ~= speaker) or (listOfNames['me'] and player == speaker)  or listOfNames[player.Name]) and player or nil
		players[p.Name] = p
		if not (listOfNames['all'] or listOfNames['others']) and #players >= #listOfNames then
			break;
		end
	end
	return setmetatable(players, {
		__call = function(self, doThis) 
			for _,plr in next, self do 
				doThis(plr);
			end 
		end;
		__tostring = function(self)
			local str = ""
			for name,_ in next, self do
				str = str..name..(next(self,name) and ", " or '');
			end
			return "𝓒playerTable: " .. str;
		end
	});
end

local plrs = getPlayers(game.Players.LocalPlayer,'all')

print(plrs)

for _,v in next, plrs do
	print(v,", ")
end

plrs(function(plr)
	print(plr.Name,"has the gay")
end)
