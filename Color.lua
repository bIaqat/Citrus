Color = setmetatable({
	fromRGB = function(r,g,b)
		return Color3.fromRGB(r,g,b)
	end;
	toRGB = function(color)
		if not color then return nil end
		local r = Citrus.Misc.round
		return r(color.r*255),r(color.g*255),r(color.b*255)
	end;
	editRGB = function(color,...)
		local round,op = Citrus.Misc.round,Citrus.Misc.operation
		local sign,nr,ng,nb,nc
		local args = {...}
		if type(args[1]) ~= 'string' then
			sign = '+'
			nr,bg,nb = args[1],args[2],args[3]
		else
			sign = args[1]
			nr,ng,nb = args[2],args[3],args[4]
			args[1],args[2],args[3] = nr,ng,nb
		end
		local r,g,b = Citrus.Color.toRGB(color)
		nc = {r,g,b}
		if not b then
			if not g then
				g = 1
			end
			nc[g] = op(nc[g],r,sign)
		else
			for i,v in pairs(nc)do
				nc[i] = op(v,args[i],sign)
			end
		end
		return Color3.fromRGB(unpack(nc))
	end;
	setRGB = function(color,...)
		local args = {...}
		local nr,ng,nb,nc
		local r,g,b = Citrus.Color.toRGB(color)
		nc = {r,g,b}
		if #args < 3 then
			if not args[2] then
				args[2] = 1
			end
			nc[args[2]] = args[1]
		else
			for i,v in pairs(nc)do
				nc[i] = args[i]
			end
		end
		return Color3.fromRGB(unpack(nc))
	end;
	fromHSV = function(h,s,v)
		return Color3.fromHSV(h/360,s/100,v/100)
	end;
	toHSV = function(color)
		if not color then return nil end
		local r = Citrus.Misc.round
		local h,s,v = Color3.toHSV(color)
		return r(h*360),r(s*360),r(v*360)
	end;
	editHSV = function(color,...)
		local round,op = Citrus.Misc.round,Citrus.Misc.operation
		local sign,nr,ng,nb,nc
		local args = {...}
		if type(args[1]) ~= 'string' then
			sign = '+'
			nr,bg,nb = args[1],args[2],args[3]
		else
			sign = args[1]
			nr,ng,nb = args[2],args[3],args[4]
			args[1],args[2],args[3] = nr,ng,nb
		end
		local r,g,b = Citrus.Color.toHSV(color)
		nc = {r,g,b}
		if not b then
			if not g then
				g = 1
			end
			nc[g] = op(nc[g],r,sign)
		else
			for i,v in pairs(nc)do
				nc[i] = op(v,args[i],sign)
			end
		end
		return Citrus.Color.fromHSV(unpack(nc))
	end;
	setHSV = function(color,...)
		local args = {...}
		local nr,ng,nb,nc
		local r,g,b = Citrus.Color.toHSV(color)
		nc = {r,g,b}
		if #args < 3 then
			if not args[2] then
				args[2] = 1
			end
			nc[args[2]] = args[1]
		else
			for i,v in pairs(nc)do
				nc[i] = args[i]
			end
		end
		return Citrus.Color.fromHSV(unpack(nc))
	end;		
	fromHex = function(hex)
		if hex:sub(1,1) == '#' then
			hex = hex:sub(2)
		end
		local r,g,b
		if #hex >= 6 then
			r = tonumber(hex:sub(1,2),16)
			g = tonumber(hex:sub(3,4),16)
			b = tonumber(hex:sub(5,6),16)
		elseif #hex >= 3 then
			r = tonumber(hex:sub(1,1):rep(2),16)
			g = tonumber(hex:sub(2,2):rep(2),16)
			b = tonumber(hex:sub(3,3):rep(2),16)
		end
		return Color3.fromRGB(r,g,b)
	end;
	toHex = function(color,hash)
		if not color then return nil end
		local r,g,b = Citrus.Color.toRGB(color)
		r = string.format('%02X',r)
		g = string.format('%02X',g)
		b = string.format('%02X',b)
		return (not hash and '#' or '')..tostring(r)..tostring(g)..tostring(b)
	end;
	fromString = function(pName)
		local colors = {
			Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
			Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
			Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
			BrickColor.new("Bright violet").Color,
			BrickColor.new("Bright orange").Color,
			BrickColor.new("Bright yellow").Color,
			BrickColor.new("Light reddish violet").Color,
			BrickColor.new("Brick yellow").Color
		}
		local value = 0
		for index = 1, #pName do
			local cValue = string.byte(string.sub(pName, index, index))
			local reverseIndex = #pName - index + 1
			if #pName%2 == 1 then
				reverseIndex = reverseIndex - 1
			end
			if reverseIndex%4 >= 2 then
				cValue = -cValue
			end
			value = value + cValue
		end
		return colors[(value % #colors) + 1]
	end;
	getReciprocal = function(color)
		local h,s,v = Citrus.Color.toHSV(color)
		return Citrus.Color.fromHSV(h,v,s)
	end;
	getInverse = function(color)
		local h,s,v = Citrus.Color.toHSV(color)
		return Citrus.Color.fromHSV((h + 180) % 360, v, s)
	end;
	getObjectsOfColor = function(color,directory)
		local objs = {}
		for i,obj in pairs(Citrus.Instance:getInstanceOf(directory):GetDescendants())do
			for prop, val in pairs(Citrus.Properties.getProperties(obj))do
				if val == color then
					table.insert(objs,obj)
				end
			end
		end
		return objs
	end;	
	insertColor = function(name,col,...)
		local index = getmetatable(Citrus.Color).Colors
		local subs = {}
		for i,v in next,{...} or {} do
			if not index[v] then
				index[v] = {}
			end
			index = index[v]
		end
		for i,v in next, type(col) == 'table' and col or {} do
			if type(v) == 'table' then
				rawset(subs,i,v)
				if type(i) == 'number' then
					table.remove(col,i)
				else
					col[i] = nil
				end
			end
		end
		if index[name] then
			Citrus.Table.insert(index[name],col)
		else
			index[name] = type(col) == 'table' and col or {col}
		end		
		for i,v in next,subs do
			Citrus.Color.insertColor(name,v,unpack({...}),i)
		end	
	end;
	getColor = function(name,id,...)
		local index = getmetatable(Citrus.Color).Colors
		for i,v in next,{type(id) == 'string' and id or nil,...} do
			index = Citrus.Table.search(index,v)
		end
		local col = index[name]
		return col and col[type(id) == 'number' and id or next(col)]
	end;
	removeColor = function(name,...)
		local index = getmetatable(Citrus.Color).Colors
		for i,v in next,{...} or {} do
			index = index[v]
		end
		index[name] = nil
	end;
	
	new = function(...)
		local args = {...}
		if type(args[1]) == 'string' then
			if args[1]:sub(1,1) == '#' then
				return Citrus.Color.fromHex(args[1])
			else
				return Citrus.Color.getColor(...)
			end
		elseif args[4] and args[4] == true then
			return Citrus.Color.fromHSV(args[1],args[2],args[3])
		elseif #args == 3 then
			return Citrus.Color.fromRGB(args[1],args[2],args[3])
		end
	end;
},{
	Colors = {};
});
