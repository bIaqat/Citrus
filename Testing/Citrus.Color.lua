
Color = {};
setmetatable(Color, {__index = {}});

function Color.toRGB(Color, returnTable)
	local tab = {Color.r * 255, Color.g*255, Color.b*255};

	return unpack(returnTable and {tab} or tab);
end;

function Color.setRGB(Color, newR, newG, newB)
	return Color3.new(newR and newR/255 or Color.r, newG and newG/255 or Color.g, newB and newB/255 or Color.b);
end;

function Color.editRGB(Color, operation, editR, editG, editB)
	local op = Spice.Misc.operation;

	return Color3.new(op(Color.r*255,editR,operation), op(Color.r*255,editG,operation), op(Color.r*255,editB,operation));
end;

function Color.fromHSV(h, s, v)
	return Color3.fromHSV(h / 360, s / 100, v / 100);
end;

function Color.toHSV(Color, returnTable)
	local h,s,v = Color3.toHSV(Color);
	local tab = {h * 360, s * 100, v * 100};

	return unpack(returnTable and {tab} or tab);
end;

function Color.setHSV(Color, newH, newS, newV)
	local h,s,v = Color3.toHSV(Color);

	return Color3.fromHSV(newH and newH / 360 or h, newS and newS/100 or s, newV and newV/100 or v);
end;

function Color.editHSV(Color, operation, editH, editS, editV)

end;

function Color.fromHex(hex)
	local hex = hex:sub(1,1) == '#' and hex:sub(2) or hex;

	local r,g,b =
		#hex >= 6 and tonumber(hex:sub(1,2),16) or #hex >= 3 and tonumber(hex:sub(1,1):rep(2),16),
		#hex >= 6 and tonumber(hex:sub(3,4),16) or #hex >= 3 and tonumber(hex:sub(2,2):rep(2),16),
		#hex >= 6 and tonumber(hex:sub(5,6),16) or #hex >= 3 and tonumber(hex:sub(3,3):rep(2),16)
	
	return Color3.fromRGB(r,g,b)
end;

function Color.toHex(Color, includeHash)
	return (includeHash and '#' or '') .. string.format('%02X',Color.r*255)..string.format('%02X',Color.g*255)..string.format('%02X',Color.b*255);
end;

function Color.fromString(String, replaceOldColors, ...)
	local value = 0

	for i = 1,#String do

		local byteString = String:sub(i,i):byte()
		local inverse_i = #String - i + 1

		inverse_i = #String == 1 and inverse_i - 1 or inverse_i
		byteString = inverse_i % 4 >= 2 and -byteString or byteString
		value = value + byteString

	end

	local colors = {Color3.new(0.992157, 0.160784, 0.262745), Color3.new(0.00392157, 0.635294, 1), Color3.new(0.00784314, 0.721569, 0.341176), Color3.new(0.419608, 0.196078, 0.486275), Color3.new(0.854902, 0.521569, 0.254902), Color3.new(0.960784, 0.803922, 0.188235), Color3.new(0.909804, 0.729412, 0.784314), Color3.new(0.843137, 0.772549, 0.603922)}
	if ... then

		if replaceOldColors then 
			colors = {} 
		end

		for i,v in next, {...} do
			table.insert(colors,v)
		end

	end
	return colors[value % #colors + 1]
end;

function Color:getColorInfo(Color) -- idea from Citrusv2 Beta

end;

function Color:storeColor(colorName, Color, ...) 
	local index = getmetatable(self).__index;

	for i,v in next, {...} do
		if not index[v] then
			rawset(index, v, {})
		end
		index = index[v];
	end

	rawset(index, colorName, Color);
end;

function Color:getColor(colorName, ...)
	local index = getmetatable(self).__index;

	for i,v in next, {...} do
		if not index[v] then
			return warn("Index doesn't exist") and false;
		end
		index = index[v];
	end

	local color = index[colorName];
	return typeof(color) == 'Color3' and color;
end;

function Color:removeColor(colorName, ...)
	local index = getmetatable(self).__index;

	for i,v in next, {...} do
		if not index[v] then
			return warn("Index doesn't exist") and false;
		end
		index = index[v];
	end

	rawset(index, colorName, nil);
end;