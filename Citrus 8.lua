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
end;

--Effects
Citrus.effect = {};
Effects = Citrus.effect;
setmetatable(Effects, {__index = {}});

function Effects:new(effectName, Function)
	local gelf = getmetatable(self).__index;
	rawset(gelf, effectName, Function);
end;

function Effects:getEffect(effectName)
	return getmetatable(self).__index[effectName] or false;
end;

function Effects:effect(Object, effectName, ...)
	local effect = getmetatable(self).__index[effectName] or false;
	return effect and effect(Object,...);
end;

function Effects:effectChildrenOf(Object, effectName, ...)
	for _, child in next, Object:GetChildren() do
		self:effect(child, effectName, ...);
	end
end;

function Effects:effectDescendantsOf(Object, effectName, ...)
	for _, desc in next, Object:GetDescendants() do
		self:effect(desc, effectName, ...);
	end
end;

function Effects:effectOnChildAdded(Object, effectName, ...)
	Object.onChildAdded:connect(function(child)
		self:effect(child, effectName, ...);
	)
end;

function Effects:effectOnDescendantAdded(Object, effectName, ...)
	Object.effectOnDescendantAdded:connect(function(desc)
		self:effect(desc, effectName, ...);
	)
end;

function Effects:effectOnEvent(Object, eventName, effectName, ...)
	Object.
end;

--Objects
Citrus.object = {};
Objects = Citrus.object;
setmetatable(Objects,{__index = {Objects = {}, Classes = {}})

function Objects.getAncestors(Object)
	local ancestors = {};
	local last = Object;

	repeat
		last = last.Parent
		ancestors.insert(last)
	until last == game;

	return ancestors;
end;

function Objects.newInstance(className, parent, propertyTable)

end;

function Objects.clone(Object, parent, propertyTable)
	local clone = Object:clone();
	clone.Parent = parent;

	for i,v in next, propertyTable or {} do
		clone[i] = v;
	end

	return clone;
end;

function Objects:newClass(className, functionOnCreated)
	local gelf = getmetatable(self).__index.Classes;

	local class = setmetatable({Objects = {}, functionOnCreated}, {
		__call = function(se, ...)
			local object = se[1](...)
			table.insert(se.Objects, object)
			return object;
		end
	});

	return class;
end;

function Objects:isA(Object, className)
	local gelf = getmetatable(self).__index.Classes[className]

	return Object:isA(className) or gelf and gelf
end;

function Objects:newCustomObject(className, parent, propertyTable, customPropertyTable, useVanilla, ...)
	local gelf = getmetatable(self).__index.Objects;

	local object = {
		Properties = customPropertyTable;
		['Instance'] = Instance.new(className, parent);
		
		newIndex = function(self, index, Function)
			rawset(getmetatable(self).customIndex.newIndex, index, Function);
		end;

		index = function(self, index, Function)
			rawset(getmetatable(self).customIndex.index, index, Function);
		end;

		clone = function(self, parent, propertyTable)
			local newObject = Table.clone(self);
			newObject.Instance.Parent = parent;
			newObject(propertyTable);
		end;
	}

	local objectMeta = {
		customIndex = {index = {}, newIndex = {}};
		__index = function(se, index)
			local ge = getmetatable(se);
			local indexes = ge.customIndex.index
			local instanceIndex = pcall(function() return se.Instance[index] or false end)

			if indexes[index] then
				return indexes[index](se);
			elseif se.Properties[index] or not instanceIndex then
				return se.Properties[index];
			else
				return instanceIndex or nil;
			end;
		end;
		__newindex = function(se, index, newIndex)
			local ge = getmetatable(se);
			local indexes = ge.customIndex.index
			local instanceIndex = pcall(function() return se.Instance[index] or false end)

			if indexes[index] then
				indexes[index](se, newIndex);
			elseif se.Properties[index] or not instanceIndex then
				rawset(se.Properties, index, newIndex);
			elseif instanceIndex then
				se.Instance[index] = newIndex;
			end;
		end;
		__call = function(se, propertyTable, useVanilla, ...)
			if useVanilla then
				for i,v in next, propertyTable do
					se[i] = v;
				end
			else
				Props:setProperties(se.Instance, popertyTable, ...)
			end
		end;
	}
	rawset(gelf, object.Instance, object);
	return setmetatable(object, objectMeta)(propertyTable, useVanilla, ...);
end;

function Objects:isACustomObject(Object)
	return self:getCustomObjectFromInstance(Object) and true or false;
end;

function Objects:getCustomObjectFromInstance(Object)
	return rawget(getmetatable(self).__index.Objects, Object);
end;

function Objects:newObject(className, parent, onCreatedArgs, propertyTable, useVanilla, ...)
	local gelf = getmetatable(self).__index.Classes;
	local instance = gelf[className] and gelf[className](unpack(onCreatedArgs)) or Instance.new(className, parent);
	
	if useVanilla then
		for i,v in next, propertyTable do
			instance[i] = v;
		end
	else
		Props:setProperties(instance, propertyTable, ...)
	end

	return instance;
end;

function Objects:newObjectFromDefault(className, parent, onCreatedArgs, propertyTable)
	return self:newObject(className, parent, onCreatedArgs, propertyTable, false, true, true, true)
end;

function Objects:newVanillaObject(className, parent, propertyTable)
	local instance = Instance.new(className, parent)

	for i,v in next, propertyTable or {} do
		instance[i] = v;
	end

	return instance;
end;
--Properties
Citrus.property = {};
Props = Citrs.property;
setmetatable(Props,{__index = {Default = {}, Custom = {}}})

function Props:newDefaultProperties(className, propertyTable, overlapIndex)
	local gelf = getmetatable(self).__index.Default;

	if not gelf[className] then
		gelf[className] = {};
	end

	rawset(gelf[className], overlapIndex, propertyTable)
end;

function Props:getDefaultPropeties(className, specificIndex)
	local gelf = getmetatable(self).__index.Default;

	if specificIndex then
		return rawget(gelf[className], specificIndex)
	else
		local props = {};

		for i, v in next, gelf[className] do
			props[i] = v;
		end
	end
end;

function Props:setToDefaultProperties(Object, specificIndex, ...)
	self:setProperties(Object, self:getDefaultPropeties(Object.ClassName, specificIndex), ...);
end;

function Props:newCustomProperty(name, Function, ...) --... Classes that have the property
	local gelf = getmetatable(self).__index.Custom;

	rawset(gelf, name, setmetatable({Function = Function, Classes = {...},
		canUse = function(self, Object)
			local c = self.Classes;
			if #c == 0 or c[1] == 'all' then
				return true;
			else
				for i,v in next, Classes do
					if Object:IsA(v) then
						return true;
					end
				end
			end
			return false;
		end;

	},{
		__call = function(self, Object, ...)
			return self.canUse(Object) and self.Function(Object,...);
		end;
	}));
end;

function Props:setToCustomProperty(Object, customProperty, ...)
	return getmetatable(self).__index.Custom[customProperty](Object, ...);
end;

function Props:sortRobloxAPI(sortFunction)

end;

function Props:searchRobloxAPI(value)

end;

function Props:hasProperty(Object, property)
	local has = pcall(function() return Object.Instance[property] or false end)
	return has, has and Object[property] or nil;
end;

function Props:getProperties(Object, classSpecific)
	
end;

function Props:setProperties(Object, propertyTable, useVanilla, includeShortcuts, includeCustom, includeDefault)

end;

--Theming
Citrus.themes = {};
Theming = Citrus.themes;

function Theming:getTheme(name, index)

end;

function Theming:setTheme(name, valueTable)

end;

function Theming:insertObjectToTheme(Object, property, name, index)

end;

function Theming:insertObjects(objectTable)

end;

function Theming:sync(name, ...)

end;

function Theming:setSyncFunction(name, Function)

end;

--Motion
Citrus.motion = {};
Motion = Citrus.motion;

function Motion:newEasing(name, directionTable)

end;

function Motion:newDirection(name, easingName, Function)

end;

function Motion:getEasing(name)

end;

function Motion:getDirection(name, easingName)

end;

function Motion:newLerp(typeName, Function)

end;

function Motion:lerpFromBezier(x1, y1, x2, y2)--function from RoStrap
	if not (x1 and y1 and x2 and y2) then error("Need 4 numbers to construct a Bezier curve") end
	if not (0 <= x1 and x1 <= 1 and 0 <= x2 and x2 <= 1) then error("The x values must be within range [0, 1]") end
	if x1 == y1 and x2 == y2 then
		return function(x) return x end
	end
	local e, f = 3*x1, 3*x2
	local g, h, i = 1 - f + e, f - 2*e, 3*(1 - f + e)
	local j, k = 2*h, 3*y1
	local l, m = 1 - 3*y2 + k, 3*y2 - 2*k
	local SampleValues = {}
	for a = 0, 10 do
		local z = a*0.1
		SampleValues[a] = ((g*z + h)*z + e)*z -- CalcBezier
	end
	return function(t, b, c, d)
		t = (c or 1)*t / (d or 1) + (b or 0)
		if t == 0 or t == 1 then -- Make sure the endpoints are correct
			return t
		end
		local CurrentSample = 9
		for a = 1, CurrentSample do
			if SampleValues[a] > t then
				CurrentSample = a - 1
				break
			end
		end
		local IntervalStart = CurrentSample*0.1
		local GuessForT = IntervalStart + 0.1*(t - SampleValues[CurrentSample]) / (SampleValues[CurrentSample + 1] - SampleValues[CurrentSample])
		local InitialSlope = (i*GuessForT + j)*GuessForT + e
		if InitialSlope >= 0.001 then
			for NewtonRaphsonIterate = 1, 4 do
				local CurrentSlope = (i*GuessForT + j)*GuessForT + e
				if CurrentSlope == 0 then break end
				GuessForT = GuessForT - (((g*GuessForT + h)*GuessForT + e)*GuessForT - t) / CurrentSlope
			end
		elseif InitialSlope ~= 0 then
			local IntervalStep = IntervalStart + 0.1

			for BinarySubdivide = 1, 10 do
				GuessForT = IntervalStart + 0.5*(IntervalStep - IntervalStart)
				local BezierCalculation = ((g*GuessForT + h)*GuessForT + e)*GuessForT - t

				if BezierCalculation > 0 then
					IntervalStep = GuessForT
				else
					IntervalStart = GuessForT
					BezierCalculation = -BezierCalculation
				end

				if BezierCalculation <= 0.0000001 then break end
			end
		end
		return ((l*GuessForT + m)*GuessForT + k)*GuessForT
	end
end;

function Motion:tweenServiceTweenObject(Object, propertyTable, duration, easing, direction, ...)

end;

function Motion:citrusTweenObject(Object, propertyTable, duration, easing, direction, ...)

end;

function Motion:lerp(beginingValue, endValue, alpha, easing, direction)

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