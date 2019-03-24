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

function Color.toRGB(Color)

end;

function Color.setRGB(Color, newR, newG, newB)

end;

function Color.editRGB(Color, operation, editR, editG, editB)

end;

function Color.fromHSV(h, s, v)

end;

function Color.toHSV(Color)

end;

function Color.setHSV(Color, newH, newS, newV)

end;

function Color.editHSV(Color, operation, editH, editS, editV)

end;

function Color.fromHex(hex)

end;

function Color.fromString(String)

end;

function Color.getInverse(Color)

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

function Color.storeColor(name, Color, index)

end;

function Color.getColor(name, index)

end;

function Color.removeColor(name, index)

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

function UD.fromPosition(yName, xName)

end;

function UD.newUDim2(...)

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