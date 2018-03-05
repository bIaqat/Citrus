Positioning = {
	new = function(...)
		local args = {...}
		if #args == 4 then
			return UDim2.new(unpack(args))
		else
			local a,b  = args[1], args[3] == nil and args[1] or args[2]
			return Citrus.Misc.Functions.switch(UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)):Filter('s','o','b','so','os')(args[3] or args[2] or 1)
		end
	end;
	toUDim = function(a,b)
		return Citrus.Misc.Functions.switch(UDim.new(a,b), UDim.new(a,a))(b and 1 or 2)
	end;
	toVector2 = function(a,b)
		return Citrus.Misc.Functions.switch(Vector2.new(a,b), Vector2.new(a,a))(b and 1 or 2)
	end;
	fromPosition = function(a,b)
		local x,y
		local pos = Citrus.Misc.Functions.switch(UDim.new(0,0),UDim.new(.5,0),UDim.new(1,0),UDim2.new(.5,0)):Filter('top','mid','bottom','center')
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
	tweenObject = function(object,typ,...)
		local interupt,udim,udim2,time,style,direction,after = true
		for i,v in pairs({...})do
			if typeof(v) == 'UDim2' then
				udim2 = udim and v or nil
				udim = udim and udim or v
			elseif type(v) == 'function' then
				after = v
			elseif type(v) == 'boolean' then
				interupt = v
			elseif type(v) == 'number' then
				time = v
			elseif type(v) == 'string' then
				style = style and style or v
				direction = style and nil or v
			end
		end
		if udim2 then
			object:TweenSizeAndPosition(udim2,udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		elseif typ:find'p' then
			object:TweenPosition(udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		else
			object:TweenSize(udim,direction or 'Out',style or 'Quad',time or .3,interupt,after)
		end
	end;
					
}