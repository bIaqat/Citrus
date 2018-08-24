Positioning = {
	new = function(...)
		local args = {...}
		if #args == 4 or (typeof(args[1]) == 'UDim' or typeof(args[2]) == 'UDim')  then
			return UDim2.new(unpack(args))
		else
			local a,b  = args[1], args[3] == nil and args[1] or args[2]
			local val = args[3] or args[2] or 1
			local alt, main = {s = 1,o = 2,b = 3,so = 4,['os'] = 5},{UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)}
			return alt[val] and main[alt[val]] or main[val]
		end
	end;
	fromUDim = function(a,b)
		return b and UDim.new(a,b) or UDim.new(a,a)
	end;
	fromVector2 = function(a,b)
		return b and Vector2.new(a,b) or Vector2.new(a,a)
	end;
	fromPosition = function(a,b)
		a,b = a:lower(), b:lower()
		local x,y = (a == 'left' or a == 'right') and a or (b == 'left' or b == 'right') and b or nil,( a == 'top' or a == 'bottom') and a or (b == 'top' or b == 'bottom') and b or nil
		local alt, main = {top = 1, mid = 2, bottom = 3, center = 4}, {UDim.new(0,0),UDim.new(.5,0),UDim.new(1,0),UDim.new(.5,0)}
		local vy = main[alt[y]] or (b ~= x and (alt[b] and main[alt[b]] or main[b]))
		alt = {left = 1, mid = 2, right = 3, center = 4}
		local vx = main[alt[x]] or (a ~= y and (alt[a] and main[alt[a]] or main[a]))
		return UDim2.new(vx or UDim.new(0,0),vy or UDim.new(0,0))
	end;
	fromOffset = function(a,b)
		return UDim2.new(0,a,0,b)
	end;
	fromScale = function(a,b)
		return UDim2.new(a,0,b,0)
	end;			
};
