--[[
                                                                                         
  ,ad8888ba,   88  888888888888  88888888ba   88        88   ad88888ba       ad88888ba   
 d8"'    `"8b  88       88       88      "8b  88        88  d8"     "8b     d8"     "8b  
d8'            88       88       88      ,8P  88        88  Y8,             Y8a     a8P  
88             88       88       88aaaaaa8P'  88        88  `Y8aaaaa,        "Y8aaa8P"   
88             88       88       88""""88'    88        88    `"""""8b,      ,d8"""8b,   
Y8,            88       88       88    `8b    88        88          `8b     d8"     "8b  
 Y8a.    .a8P  88       88       88     `8b   Y8a.    .a8P  Y8a     a8P     Y8a     a8P  
  `"Y8888Y"'   88       88       88      `8b   `"Y8888Y"'    "Y88888P"       "Y88888P"   
                                                                                         
--]]
--unpacked version
local Citrus = {};

--Misc
Citrus.misc = {};
local Misc = Citrus.misc;

function Misc.round(Number, byDecimal)
	local dec = math.pow(10,byDecimal or 0);

	return math.ceil(Number * dec - .5) / dec;
end;

function Misc.destroyIn(Object, howManySeconds)
	game:GetService'Debris':AddItem(Object,howManySeconds);
end;

function Misc.getAssetId(assetId)
	local asset = game:GetService'InsertService':LoadAsset(tonumber(assetId)):GetChildren()[1];
	local className = asset.ClassName

	assetId = asset[className == 'ShirtGraphic' and 'Graphic' or className == 'Shirt' and 'ShirtTemplate' or className == 'Pants' and 'PantsTemplate' or className == 'Decal' and 'Texture'];
	
	return assetId:sub(assetId:find'='+1);
end;

function Misc.getTextSize(String, textSize, font, absoluteSize)
	return game:GetService'TextService':GetTextSize(String or '', textSize or 12, font or Enum.Fonts.SourceSans, absoluteSize or Vector2.new(0,0));
end;

function Misc.getTextSizeFromObject(Object, testObjectProperties)
	local textLabel = Object;

	if testObjectProperties then
		for property, value in next, testObjectProperties do
			textLabel[property] = value;
		end
	end

	return game:GetService'TextService':GetTextSize(Object.Text, Object.FontSize, Object.Font, Object.AbsoluteSize);
end;

function Misc.operation(a,b,op)
	return op == '+' and a + b or
	op == '-' and a - b or
	(op == '*' or op == 'x') and a * b or
	op == '/' and a / b or
	op == '%' and a % b or
	(op == 'pow' or op == '^') and a ^ b or
	(op == 'rt' or op == '^/') and a ^ (1/b);
end;


--Table
Citrus.table = {};
local Table = Citrus.table;

function Table.mergeTo(TableFrom, TableTo)
	for index, key in next, TableFrom do

		if type(index) == 'string' then
			rawset(TableTo,index,key);
		else
			table.insert(TableTo,key);
		end

	end

	return TableTo;
end;

function Table:clone(Table)
	local clone = {};
	local clonef = self.clone

	for index, key in next, Table do

		if type(index) == 'table' then
			index = clonef(self,index);
		elseif typeof(index) == 'Instance' then
			index = index:Clone();
		end

		if type(key) == 'table' then
			key = clonef(self,key);
		elseif typeof(key) == 'Instance' then
			key = key:Clone();
		end

		rawset(clone,index,key);
	end

	local metatable = getmetatable(Table);

	if metatable then
		setmetatable(clone,clonef(self,metatable));
	end

	return clone;
end;

function Table.contains(Table, contains)
	for index, key in next, Table do

		if (type(i) ~= 'string' and i == contains) or (v == contains) then
			return true;
		end

	end

	return false;
end;

function Table.length(Table)
	local count = 0

	for _,_ in next, Table do
		count = count + 1;
	end

	return count;
end;

function Table.firstIndexOf(Table, value)
	for index, key in next, Table do
		if key == value then
			return key;
		end
	end

	return nil;
end;

function Table.indexesOf(Table, value, returnNumber)
	local indexes = {};

	for index, key in next, Table do
		if key == value then
			table.insert(indexes);
		end
	end

	return returnNumber and indexes[returnNumber] or indexes;
end;

function Table.find(Table, value, returnNumber, ...) --...searchAlgorithms (function(Table, index, value))

end;

function Table.search(Table, value, returnNumber, ...)

end;


--Color
Citrus.color = {};
Color = Citrus.color;

function Color.toRGB(Color, returnTable)
	local tab = {Color.r * 255, Color.g*255, Color.b*255};
	return returnTable and tab or unpack(tab);
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
	return returnTable and tab or unpack(tab);
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
		if replaceOldColors then colors = {} end
		for i,v in next, {...} do
			table.insert(colors,v)
		end
	end
	return colors[value % #colors + 1]
end;

function Color.getColorInfo(Color)

end;

function Color:getMonochromatic(Color)

end;

function Color:getTriadic(Color)

end;

function Color:getShades(Color)

end;

function Color:getTints(Color)

end;

function Color:getComplementary(Color)

end;

function Color:getAnalogous(Color)

end;

function Color:storeColor(name, Color, index) 
	local gelf = getmetatable(self).__index

end;

function Color:getColor(name, index)
	local gelf = getmetatable(self).__index

end;

function Color:removeColor(name, index)
	local gelf = getmetatable(self).__index

end;


--Location
Citus.location = {};
UD = Citrus.location;

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
		return UDim2.new(a,b,c,d)
	end
	b = not c and a or b
	c = c or b or 1
	local names = {s = 1, o = 2, b = 3, so = 4, ['os'] = 5}
	--{UDim2.new(a,0,b,0),UDim2.new(0,a,0,b),UDim2.new(a,b,a,b),UDim2.new(a,0,0,b),UDim2.new(0,a,b,0)}
	c = type(c) == 'string' and names[c]
	return UDim2.new(c == 1 or c == 3 and a or 0, c == 3 and b or c == 2 or c == 5 and a or 0, c == 3 and a or c == 1 or c == 5 and b or 0, c == 2 or c == 3 or c == 4 and b or 0);
end;

function noob(a, b, c, d)
	if a and b and c and d then
		return UDim2.new(a,b,c,d)
	end
	b = not c and a or b
	c = c or b or 1
	local names = {s = 1, o = 2, b = 3, so = 4, ['os'] = 5}
	c = type(c) == 'string' and names[c]
	return UDim2.new(c == 1 or c == 3 and a or 0, c == 3 and b or c == 2 or c == 5 and a or 0, c == 3 and a or c == 1 or c == 5 and b or 0, c == 2 or c == 3 or c == 4 and b or 0);
end;

function UD.newUDim2FromOffset(x, y)
	return UDim2.new(0,x,0,y);
end;

function UD.newUDim2FromScale(x,y)
	return UDim2.new(x,0,y,0);
end;

--Effects
Citrus.effect = {};
Effects = Citrus.effect;

function Effects.new(name, Function)
	
end;

function Effects.getEffect(name)

end;

function Effects.effect(Object, name, ...)

end;

function Effects.effectChildrenOf(Object, effectName, ...)

end;

function Effects.effectDescendantsOf(Object, effectName, ...)

end;

function Effects.effectOnChildAdded(Object, effectName, ...)

end;

function Effects.effectOnDescendantAdded(Object, effectName, ...)

end;

function Effects.effectOnEvent(Object, eventName, effectName, ...)

end;


--

--[[
Citrus.misc = {}; half pointless stuff
Citrus.sound = {}; cute audio manipulation
Citrus.color = {}; cute color manipulation
Citrus.effect = {}; YUM 
Citrus.image = {}; cute imagery manipulation
Citrus.motion = {}; TWEEN SERVICE :D
Citrus.object = {}; Custom Objects are bae tbh
Citrus.location = {}; eh half pointless ig but useful
Citrus.property = {}; Stable ingredient for Citrus at this point
Citrus.table = {}; TABLE MANIPULATION IS HOT (table.search)
]]




































--														𝓒𝔦𝓽𝔯𝓾ş 𝐯➑  - ｂｙ ｒｏｕｇｅ.