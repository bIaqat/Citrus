UD = {};

function UD.newUDim(scale, offset)
	return UDim.new(scale, offset or scale);
end;

function UD.newVector2(x, y)
	return Vector2.new(x, y or x);
end;

function UD.fromPosition(yName, xName, xOffset, yOffset)
	local names = {top = 0, left = 0, center = .5, mid = .5, bottom = 1, right = 1}
	
	return UDim2.new(names[xName or yName == 'center' and yName or 'top'], xOffset or  0, names[yName or 'top'], yOffset or 0);
end;

function UD.newUDim2(a, b, c, d)
	if a and b and c and d then
		return UDim2.new(a,b,c,d);
	end
	--{UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)}	
	local names = {s = 1, o = 2, b = 3, so = 4, ['os'] = 5};

	b = not c and a or b;
	c = c or b or 1;
	c = type(c) == 'string' and names[c] or c;
	
	return UDim2.new(c == 1 or c == 3 and a or 0, c == 3 and b or c == 2 or c == 5 and a or 0, c == 3 and a or c == 1 or c == 5 and b or 0, c == 2 or c == 3 or c == 4 and b or 0);
end;

function UD.newUDim2FromOffset(x, y)
	return UDim2.new(0,x,0,y);
end;

function UD.newUDim2FromScale(x,y)
	return UDim2.new(x,0,y,0);