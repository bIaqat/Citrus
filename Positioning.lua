Positioning = {
	new = function(...)
		local args = {...}
		if #args == 4 or (typeof(args[1]) == 'UDim' or typeof(args[2]) == 'UDim')  then
			return UDim2.new(unpack(args))
		else
			local a,b  = args[1], args[3] == nil and args[1] or args[2]
			return Spice.Misc.switch(UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)):Filter('s','o','b','so','os')(args[3] or args[2] or 1)
		end
	end;
	fromUDim = function(a,b)
		return Spice.Misc.switch(UDim.new(a,b), UDim.new(a,a))(b and 1 or 2)
	end;
	fromVector2 = function(a,b)
		return Spice.Misc.switch(Vector2.new(a,b), Vector2.new(a,a))(b and 1 or 2)
	end;
	fromPosition = function(a,b)
		local x,y
		local pos = Spice.Misc.switch(UDim.new(0,0),UDim.new(.5,0),UDim.new(1,0),UDim2.new(.5,0)):Filter('top','mid','bottom','center')
		y = pos(a) or (pos(b) and b~='mid' and b~='center')
		pos:Filter('left','mid','right','center')
		x = pos(b) or (pos(a) and a~='mid' and a~='center')
		return UDim2.new(x or UDim.new(0,0),y or UDim.new(0,0))
	end;
	fromOffset = function(a,b)
		return UDim2.new(0,a,0,b)
	end;
	fromScale = function(a,b)
		return UDim2.new(a,0,b,0)
	end;			
};