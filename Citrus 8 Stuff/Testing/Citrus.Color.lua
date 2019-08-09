
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
	local op = Misc.operation;

	return Color3.new(op(Color.r*255,editR,operation)/255, op(Color.g*255,editG,operation)/255, op(Color.b*255,editB,operation)/255);
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

function Color.fromHSL(h, s, l)
	l = l > 1 and 1 or l < 0 and 0 or l;
	s = s * (l < .5 and l or 1 - l);

	return Color3.fromHSV(h, 2*s/(l+s), l+s);
end;

function Color.toHSL(Color, returnTable)
	local h,s,v = Color3.toHSV(Color);
	local h2 = (2-s) * v
	local tab = {h%1, s*v / (h2 < 1 and h2 or 2 - h2), h2/2};

	return unpack(returnTable and {tab} or tab);
end;

function Color.toHex(Color, includeHash)
	return (includeHash and '#' or '') .. string.format('%02X',Color.r*255)..string.format('%02X',Color.g*255)..string.format('%02X',Color.b*255);
end;

function Color.setHSL(Color, newH, newS, newL)
	local h,s,v = Color3.toHSV(Color);
	local h2 = (2-s) * v
	local h,s,l = newH or h%1, newS or (h2 < 1 and h2 or 2 - h2), newL or h2/2;
	
	s = s * (l < .5 and l or 1 - l);
	
	return Color3.fromHSV(h, 2*s/(l+s), l+s);
end;

function Color.editHSL(Color, operation, editH, editS, editL)
	local h,s,v = Color3.toHSV(Color);
	local h2 = (2-s) * v
	local h,s,l = op(h%1,editH,operation), (h2 < 1 and h2 or 2 - h2), editL or h2/2;
	s,l = op(s,editS,operation), op(l,editL,operation);
	
	s = s * (l < .5 and l or 1 - l);
	
	return Color3.fromHSV(h, 2*s/(l+s), l+s);
end;
function Citrus.Beta.color:getMonochromatic(Color, intervals, limit)
	limit = 1 - ((limit or 0)/100)
	intervals = intervals or 5
	local h,s,l = self.toHSL(Color)
	local max, min = l + limit, l - limit
	max,min = max <= 1 and max or 1, min >= 0 and min or 0
	local afr, afl = (max - l) / intervals, (l - min) / intervals
	local l1, l2 = l, l
	local tab = {Color}
	
	for i = 1, intervals do
		l1 = l1 + afr;
		l2 = l2 - afl;
		table.insert(tab,1,self.fromHSL(h,s,l2))
		tab[i+1] = Color;
		tab[intervals + 3 + i] = self.fromHSL(h,s,l1)
	end
	return tab
end;


function Color.getShades(Color, intervals)
	intervals = intervals or 10
	local h,s,v = Color3.toHSV(Color);
	local sp, sv = (1-s) / (intervals), v / intervals;
	local tab = {Color};
	local abs = math.abs
	
	for i = 1, intervals do
		s = s + sp;
		v = v - sv;
		table.insert(tab,Color3.fromHSV(h,s <= 1 and s or 1,v >= 0 and v or 0));
	end

	return tab;
end;

function Color.getTints(Color, intervals)
	intervals = intervals or 10
	local h,s,v = Color3.toHSV(Color);
	local sp, sv = s / (intervals), (1-v) / intervals;
	local tab = {Color};
	local abs = math.abs
	
	for i = 1, intervals do
		s = s - sp;
		v = v + sv;
		table.insert(tab,Color3.fromHSV(h,s >= 0 and s or 0,v <= 1 and v or 1));
	end

	return tab;
end;

function Color.getTriadic(Color)
	local h0, s, v = Color3.toHSV(Color);
	h0 = h0 * 360;
	local abs = math.abs
	local fh = Color3.fromHSV

	return {Color, fh(abs(((h0 + 120) %360))/360,s,v), fh(abs(((h0 + 240) %360))/360,s,v)};
end;

function Color.getTetradic(Color)
	local h0, s, v = Color3.toHSV(Color);
	h0 = h0 * 360;
	local abs = math.abs
	local fh = Color3.fromHSV

	return {Color, fh(abs(((h0 + 90) %360))/360,s,v), fh(abs(((h0 + 180) %360))/360,s,v), fh(abs(((h0 + 270) %360))/360,s,v)};
end;


function Color.getComplementary(Color, split)
	local h0, s, v = Color3.toHSV(Color);
	h0 = h0 * 360;
	local abs = math.abs
	local fh = Color3.fromHSV

	return {Color, fh(abs(((h0 + (split and 150 or 180)) %360))/360,s,v), split and fh(abs((((h0 + 210) %360)))/360,s,v) or nil};
end;

function Color.getAnalogous(Color, split)
	local h0, s, v = Color3.toHSV(Color);
	h0 = h0 * 360;
	local abs = math.abs
	local fh = Color3.fromHSV

	return {Color, fh(abs(((h0 + 30) %360))/360,s,v), fh(abs(((h0 + (split and 60 or 330)) %360))/360,s,v), split and fh(abs(((h0 + 90) %360))/360,s,v) or nil};
end;

function Color.getInverse(Color)
	return Color3.new(1 - Color.r, 1 - Color.g, 1 - Color.b);
end;