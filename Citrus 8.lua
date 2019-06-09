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

--Beta
Citrus.Beta = {};
local Beta = Citrus.Beta;
setmetatable(Beta, {
	__index = function(self, ind)
		if Citrus[ind] then
			rawset(Beta, ind, setmetatable({},{
				__index = function(self, ind2) 
					return Citrus[ind][ind2] 
				end, 
				__metatable = getmetatable(Citrus[ind]);
			}));
		end
		return Beta[ind];
	end;
})

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
setmetatable(Table, {__index = {
	bySubstring = function(comparative, ind, val)
		local subject, subject2 = (type(ind) == 'string' and ind or type(val) == 'string' and val):lower(),(type(ind) == 'string' and type(val) == 'string' and val):lower()
		return subject and subject:find(comparative:lower(), 1, true) and true or subject2 and subject2:find(comparative:lower(), 1, true) and true or false
	end;
	byCapitals = function(comparative, ind, val)
		local subject = type(ind) == 'string' and ind or type(val) == 'string' and val
		if subject then
			local strin = ''
			for cap in subject:gmatch('%u') do
				strin = strin..cap
			end
			strin = strin..(subject:match('%d+$') or '')
			if strin:lower() == comparative:lower() then
				return true
			end
		end
		return false
	end;
}});

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
	for index, val in next, Table do

		if (type(index) ~= 'string' and index == contains) or (val == contains) then
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

function Table:find(Table, value, returnNumber, ...) --...searchAlgorithms (function(Table, index, value))
	local found = {};

	for i,v in next, Table do
		if v == value then
			table.insert(found, {i, v})
		end

		for i,v in next, {...} do
			if type(v) == 'string' then
				v = self:getCompareAlgorithm(v)
			end

			if v and v(Table, i, v) then
				table.insert(found, {i, v})
			end
		end

	end

	return returnNumber and found[returnNumber] or found;
end;

function Table:search(Table, value, skipSaved, returnNumber, subStringSearch, capSearch, ...)
	if not getmetatable(Table) then
		setmetatable(Table,{})
	end

	local meta = getmetatable(Table)

	if not meta['𝓒table.search'] then
		meta['𝓒table.search'] = {};
	end
	local saved = meta['𝓒table.search'];

	if not skipSaved and saved[value] then
		return saved[value];
	end;

	local found = self.find(Table, value, nil, subStringSearch and 'bySubString', capSearch and 'byCapitals', ...);

	saved[value] = returnNumber and found[returnNumber] or found;

	return saved[value];
end;

function Table:storeCompareAlgorithm(name, Function)
	rawset(getmetatable(self).index, name, Function);
end

function Table:getCompareAlgorithm(name)
	return rawget(getmetatable(self).index, name);
end


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
	local op = Misc.operation;

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
			return warn("Index ".. v.." doesn't exist") and false;
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
Citrus.location = {};
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

function Effects:storeEffect(effectName, Function)
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

function Effects:effectOnEvent(Object, eventName, effectName, ...)
	local args = {...};
	Object[eventName]:connect(function(possibleObject)
		if typeof(possibleObject) == 'Instance' then 
			Object = possibleObject;
		end
		
		self:effect(Object, effectName, unpack(args));
	end)
end;

--Objects
Citrus.object = {};
Objects = Citrus.object;
setmetatable(Objects,{__index = {Objects = {}, Classes = {}}});

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
				Props:setProperties(se.Instance, propertyTable, ...)
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
Citrus.property = {
	RobloxAPI = setmetatable({},{__index = function(self, index) local gelf, ret = getmetatable(self) gelf.__index = {} for i,v in next, {
			ShirtGraphic = setmetatable({'Graphic'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LocalizationTable = setmetatable({'DevelopmentLanguage', 'SourceLocaleId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginGuiService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginMouse = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Mouse(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterGui = setmetatable({'ProcessUserInput', 'ResetPlayerGuiOnSpawn', 'ScreenOrientation', 'ShowDevelopmentGui'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePlayerGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Accoutrement = setmetatable({'AttachmentForward', 'AttachmentPoint', 'AttachmentPos', 'AttachmentRight', 'AttachmentUp'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AdService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DebuggerManager = setmetatable({'DebuggingEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CharacterAppearance = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiMain = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ScreenGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VectorForce = setmetatable({'ApplyAtCenterOfMass', 'Force', 'RelativeTo'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SelectionLasso = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase3d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HumanoidController = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Controller(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MeshContentProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CacheableContentProvider(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Handles = setmetatable({'Faces', 'Style'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandlesBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataClasses = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RemoteEvent = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ValueBase = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Hole = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Feature(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Smoke = setmetatable({'Color', 'Enabled', 'Opacity', 'RiseVelocity', 'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			KeyframeSequenceProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CSGDictionaryService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FlyweightService(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			UIScale = setmetatable({'Scale'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIComponent(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TimerService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CFrameValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); InputObject = setmetatable({'Delta', 'KeyCode', 'Position', 'UserInputState', 'UserInputType'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ImageLabel = setmetatable({'Image', 'ImageColor3', 'ImageRectOffset', 'ImageRectSize', 'ImageTransparency', 'IsLoaded', 'ScaleType', 'SliceCenter', 'TileSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiLabel(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			NotificationService = setmetatable({'IsLuaChatEnabled', 'IsLuaGamesPageEnabled', 'IsLuaHomePageEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIListLayout = setmetatable({'Padding'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIGridStyleLayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Torque = setmetatable({'RelativeTo', 'Torque'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HandleAdornment = setmetatable({'AlwaysOnTop', 'CFrame', 'SizeRelativeOffset', 'ZIndex'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PointLight = setmetatable({'Range'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Light(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TweenBase = setmetatable({'PlaybackState'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DoubleConstrainedValue = setmetatable({'ConstrainedValue', 'MaxValue', 'MinValue', 'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RocketPropulsion = setmetatable({'CartoonFactor', 'MaxSpeed', 'MaxThrust', 'MaxTorque', 'TargetOffset', 'TargetRadius', 'ThrustD', 'ThrustP', 'TurnD', 'TurnP'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CoreGui = setmetatable({'Version'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePlayerGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataEvents = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReplicatedFirst = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpotLight = setmetatable({'Angle', 'Face', 'Range'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Light(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ButtonBindingWidget = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NegateOperation = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PartOperation(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ChorusSoundEffect = setmetatable({'Depth', 'Mix', 'Rate'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Tool = setmetatable({'CanBeDropped', 'Enabled', 'Grip', 'GripForward', 'GripPos', 'GripRight', 'GripUp', 'ManualActivationOnly', 'RequiresHandle', 'ToolTip'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BackpackItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Texture = setmetatable({'StudsPerTileU', 'StudsPerTileV'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Decal(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PhysicsSettings = setmetatable({'AllowSleep', 'AreAnchorsShown', 'AreAssembliesShown', 'AreAwakePartsHighlighted', 'AreBodyTypesShown', 'AreContactIslandsShown', 'AreContactPointsShown', 'AreJointCoordinatesShown', 'AreMechanismsShown', 'AreModelCoordsShown', 'AreOwnersShown', 'ArePartCoordsShown', 'AreRegionsShown', 'AreUnalignedPartsShown', 'AreWorldCoordsShown', 'DisableCSGv2', 'IsReceiveAgeShown', 'IsTreeShown', 'PhysicsAnalyzerEnabled', 'PhysicsEnvironmentalThrottle', 'ShowDecompositionGeometry', 'ThrottleAdjustTime', 'UseCSGv2'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Script = setmetatable({'Source'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BaseScript(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Terrain = setmetatable({'IsSmooth', 'MaxExtents', 'WaterColor', 'WaterReflectance', 'WaterTransparency', 'WaterWaveSize', 'WaterWaveSpeed'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
			OrderedDataStore = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GlobalDataStore(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LineHandleAdornment = setmetatable({'Length', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RenderingTest = setmetatable({'CFrame', 'ComparisonDiffThreshold', 'ComparisonMethod', 'ComparisonPsnrThreshold', 'Description', 'FieldOfView', 'Orientation', 'Position', 'QualityLevel', 'ShouldSkip', 'Ticket'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			PVAdornment = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase3d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TextBox = setmetatable({'ClearTextOnFocus', 'Font', 'FontSize', 'LineHeight', 'ManualFocusRelease', 'MultiLine', 'OverlayNativeInput', 'PlaceholderColor3', 'PlaceholderText', 'ShowNativeInput', 'Text', 'TextBounds', 'TextColor', 'TextColor3', 'TextFits', 'TextScaled', 'TextSize', 'TextStrokeColor3', 'TextStrokeTransparency', 'TextTransparency', 'TextTruncate', 'TextWrap', 'TextWrapped', 'TextXAlignment', 'TextYAlignment'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); KeyframeSequence = setmetatable({'Loop', 'Priority'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FunctionalTest = setmetatable({'Description'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ServerScriptService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BillboardGui = setmetatable({'Active', 'AlwaysOnTop', 'ClipsDescendants', 'ExtentsOffset', 'ExtentsOffsetWorldSpace', 'LightInfluence', 'MaxDistance', 'Size', 'SizeOffset', 'StudsOffset', 'StudsOffsetWorldSpace'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LayerCollector(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Feature = setmetatable({'FaceId', 'InOut', 'LeftRight', 'TopBottom'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MarketplaceService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Team = setmetatable({'AutoAssignable', 'AutoColorCharacters', 'Score', 'TeamColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FlangeSoundEffect = setmetatable({'Depth', 'Mix', 'Rate'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MouseService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiButton = setmetatable({'AutoButtonColor', 'Modal', 'Selected', 'Style'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIGridStyleLayout = setmetatable({'AbsoluteContentSize', 'FillDirection', 'HorizontalAlignment', 'SortOrder', 'VerticalAlignment'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UILayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); JointsService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkPeer = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UITextSizeConstraint = setmetatable({'MaxTextSize', 'MinTextSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AdvancedDragger = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadata = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PointsService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
			GuiBase = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyGyro = setmetatable({'CFrame', 'D', 'MaxTorque', 'P'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Path = setmetatable({'Status'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiLabel = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpecialMesh = setmetatable({'MeshType'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FileMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); InstancePacketCache = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Folder = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			FileMesh = setmetatable({'MeshId', 'TextureId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.DataModelMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Shirt = setmetatable({'ShirtTemplate'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Clothing(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SlidingBallConstraint = setmetatable({'ActuatorType', 'CurrentPosition', 'LimitsEnabled', 'LowerLimit', 'MotorMaxAcceleration', 'MotorMaxForce', 'Restitution', 'ServoMaxForce', 'Size', 'Speed', 'TargetPosition', 'UpperLimit', 'Velocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Animator = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GlobalDataStore = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SolidModelContentProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CacheableContentProvider(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SkateboardPlatform = setmetatable({'Steer', 'StickyWheels', 'Throttle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DebuggerWatch = setmetatable({'Expression'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DataModelMesh = setmetatable({'Offset', 'Scale', 'VertexColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SkateboardController = setmetatable({'Steer', 'Throttle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Controller(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TextLabel = setmetatable({'Font', 'FontSize', 'LineHeight', 'LocalizedText', 'Text', 'TextBounds', 'TextColor', 'TextColor3', 'TextFits', 'TextScaled', 'TextSize', 'TextStrokeColor3', 'TextStrokeTransparency', 'TextTransparency', 'TextTruncate', 'TextWrap', 'TextWrapped', 'TextXAlignment', 'TextYAlignment'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiLabel(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Mouse = setmetatable({'Hit', 'Icon', 'Origin', 'TargetSurface', 'UnitRay', 'ViewSizeX', 'ViewSizeY', 'X', 'Y'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Constraint = setmetatable({'Color', 'Enabled', 'Visible'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BindableFunction = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataCallbacks = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ImageHandleAdornment = setmetatable({'Image', 'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Clothing = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Lighting = setmetatable({'Ambient', 'Brightness', 'ClockTime', 'ColorShift', 'ColorShift', 'FogColor', 'FogEnd', 'FogStart', 'GeographicLatitude', 'GlobalShadows', 'OutdoorAmbient', 'Outlines', 'ShadowColor', 'TimeOfDay'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RenderSettings = setmetatable({'AutoFRMLevel', 'EagerBulkExecution', 'EditQualityLevel', 'EnableFRM', 'ExportMergeByMaterial', 'FrameRateManager', 'GraphicsMode', 'MeshCacheSize', 'QualityLevel', 'ReloadAssets', 'RenderCSGTrianglesDebug', 'ShowBoundingBoxes'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ObjectValue = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			CharacterMesh = setmetatable({'BaseTextureId', 'BodyPart', 'MeshId', 'OverlayTextureId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuidRegistryService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GameSettings = setmetatable({'AdditionalCoreIncludeDirs', 'BubbleChatLifetime', 'BubbleChatMaxBubbles', 'ChatHistory', 'ChatScrollLength', 'CollisionSoundEnabled', 'CollisionSoundVolume', 'HardwareMouse', 'MaxCollisionSounds', 'OverrideStarterScript', 'ReportAbuseChatHistory', 'SoftwareSound', 'VideoCaptureEnabled', 'VideoQuality'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TotalCountTimeIntervalItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StatsItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataEnum = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ReflectionMetadataItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			HandlesBase = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PartAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FaceInstance = setmetatable({'Face'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Toolbar = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyColors = setmetatable({'HeadColor', 'HeadColor3', 'LeftArmColor', 'LeftArmColor3', 'LeftLegColor', 'LeftLegColor3', 'RightArmColor', 'RightArmColor3', 'RightLegColor', 'RightLegColor3', 'TorsoColor', 'TorsoColor3'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FriendService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ColorCorrectionEffect = setmetatable({'Brightness', 'Contrast', 'Saturation', 'TintColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PostEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CookiesService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RopeConstraint = setmetatable({'CurrentDistance', 'Length', 'Restitution', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PVInstance = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SelectionBox = setmetatable({'LineThickness', 'SurfaceColor', 'SurfaceColor3', 'SurfaceTransparency'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VehicleSeat = setmetatable({'AreHingesDetected', 'Disabled', 'HeadsUpDisplay', 'MaxSpeed', 'Steer', 'SteerFloat', 'Throttle', 'ThrottleFloat', 'Torque', 'TurnSpeed'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DebugSettings = setmetatable({'DataModel', 'ErrorReporting', 'GfxCard', 'InstanceCount', 'IsFmodProfilingEnabled', 'IsScriptStackTracingEnabled', 'JobCount', 'LuaRamLimit', 'OsIs64Bit', 'OsPlatform', 'OsPlatformId', 'OsVer', 'PlayerCount', 'ReportSoundWarnings', 'RobloxProductName', 'RobloxVersion', 'SIMD', 'SystemProductName', 'TickCountPreciseOverride', 'VideoMemory'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ServerStorage = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); IntValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FloorWire = setmetatable({'CycleOffset', 'StudsBetweenTextures', 'Texture', 'TextureSize', 'Velocity', 'WireRadius'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase3d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiRoot = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Controller = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Motor = setmetatable({'CurrentAngle', 'DesiredAngle', 'MaxVelocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Glue = setmetatable({'F0', 'F1', 'F2', 'F3'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIGridLayout = setmetatable({'CellPadding', 'CellSize', 'FillDirectionMaxCells', 'StartCorner'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIGridStyleLayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			LayerCollector = setmetatable({'Enabled', 'ResetOnSpawn', 'ZIndexBehavior'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase2d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GlobalSettings = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GenericSettings(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Geometry = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ManualWeld = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ManualSurfaceJointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SoundGroup = setmetatable({'Volume'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiObject = setmetatable({'Active', 'AnchorPoint', 'BackgroundColor', 'BackgroundColor3', 'BackgroundTransparency', 'BorderColor', 'BorderColor3', 'BorderSizePixel', 'ClipsDescendants', 'Draggable', 'LayoutOrder', 'Position', 'Rotation', 'Selectable', 'Size', 'SizeConstraint', 'Transparency', 'Visible', 'ZIndex'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase2d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DebuggerBreakpoint = setmetatable({'Condition', 'IsEnabled', 'Line'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SunRaysEffect = setmetatable({'Intensity', 'Spread'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PostEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			CorePackages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Status = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Model(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Pose = setmetatable({'CFrame', 'EasingDirection', 'EasingStyle', 'MaskWeight', 'Weight'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PlayerMouse = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Mouse(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AnimationTrack = setmetatable({'IsPlaying', 'Length', 'Looped', 'Priority', 'Speed', 'TimePosition', 'WeightCurrent', 'WeightTarget'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AnalyticsService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LogService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AlignPosition = setmetatable({'ApplyAtCenterOfMass', 'MaxForce', 'MaxVelocity', 'ReactionForceEnabled', 'Responsiveness', 'RigidityEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); InsertService = setmetatable({'AllowInsertFreeModels'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HingeConstraint = setmetatable({'ActuatorType', 'AngularSpeed', 'AngularVelocity', 'CurrentAngle', 'LimitsEnabled', 'LowerAngle', 'MotorMaxAcceleration', 'MotorMaxTorque', 'Radius', 'Restitution', 'ServoMaxTorque', 'TargetAngle', 'UpperAngle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Message = setmetatable({'Text'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Player = setmetatable({'AccountAge', 'AppearanceDidLoad', 'AutoJumpEnabled', 'CameraMaxZoomDistance', 'CameraMinZoomDistance', 'CameraMode', 'CanLoadCharacterAppearance', 'CharacterAppearance', 'CharacterAppearanceId', 'ChatMode', 'DataComplexity', 'DataComplexityLimit', 'DataReady', 'DevCameraOcclusionMode', 'DevComputerCameraMode', 'DevComputerMovementMode', 'DevEnableMouseLock', 'DevTouchCameraMode', 'DevTouchMovementMode', 'DisplayName', 'FollowUserId', 'Guest', 'HealthDisplayDistance', 'LocaleId', 'MaximumSimulationRadius', 'MembershipType', 'NameDisplayDistance', 'Neutral', 'OsPlatform', 'SimulationRadius', 'TeamColor', 'Teleported', 'TeleportedIn', 'UserId', 'VRDevice'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ContentProvider = setmetatable({'BaseUrl', 'RequestQueueSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BoxHandleAdornment = setmetatable({'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScrollingFrame = setmetatable({'AbsoluteWindowSize', 'BottomImage', 'CanvasPosition', 'CanvasSize', 'ElasticBehavior', 'HorizontalScrollBarInset', 'MidImage', 'ScrollBarImageColor3', 'ScrollBarImageTransparency', 'ScrollBarThickness', 'ScrollingDirection', 'ScrollingEnabled', 'TopImage', 'VerticalScrollBarInset', 'VerticalScrollBarPosition'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ManualSurfaceJointInstance = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Humanoid = setmetatable({'AutoJumpEnabled', 'AutoRotate', 'AutomaticScalingEnabled', 'CameraOffset', 'DisplayDistanceType', 'FloorMaterial', 'Health', 'HealthDisplayDistance', 'HealthDisplayType', 'HipHeight', 'Jump', 'JumpPower', 'MaxHealth', 'MaxSlopeAngle', 'MoveDirection', 'NameDisplayDistance', 'NameOcclusion', 'PlatformStand', 'RigType', 'Sit', 'TargetPoint', 'WalkSpeed', 'WalkToPoint'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MeshPart = setmetatable({'MeshId', 'TextureID'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CylinderHandleAdornment = setmetatable({'Height', 'Radius'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
			PhysicsPacketCache = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RunningAverageItemDouble = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StatsItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BloomEffect = setmetatable({'Intensity', 'Size', 'Threshold'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PostEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Attachment = setmetatable({'Axis', 'CFrame', 'Orientation', 'Position', 'Rotation', 'SecondaryAxis', 'Visible', 'WorldAxis', 'WorldCFrame', 'WorldOrientation', 'WorldPosition', 'WorldRotation', 'WorldSecondaryAxis'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Light = setmetatable({'Brightness', 'Color', 'Enabled', 'Shadows'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RobloxReplicatedStorage = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyMover = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AssetService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); WedgePart = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FormFactorPart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScriptService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ImageButton = setmetatable({'HoverImage', 'Image', 'ImageColor3', 'ImageRectOffset', 'ImageRectSize', 'ImageTransparency', 'IsLoaded', 'PressedImage', 'ScaleType', 'SliceCenter', 'TileSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiButton(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HapticService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiBase2d = setmetatable({'AbsolutePosition', 'AbsoluteRotation', 'AbsoluteSize', 'AutoLocalize', 'Localize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DialogChoice = setmetatable({'GoodbyeChoiceActive', 'GoodbyeDialog', 'ResponseDialog', 'UserDialog'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NumberValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); JointInstance = setmetatable({'C0', 'C1'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CylindricalConstraint = setmetatable({'AngularActuatorType', 'AngularLimitsEnabled', 'AngularRestitution', 'AngularSpeed', 'AngularVelocity', 'CurrentAngle', 'InclinationAngle', 'LowerAngle', 'MotorMaxAngularAcceleration', 'MotorMaxTorque', 'RotationAxisVisible', 'ServoMaxTorque', 'TargetAngle', 'UpperAngle', 'WorldRotationAxis'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SlidingBallConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); WeldConstraint = setmetatable({'Enabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CollectionService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Visit = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Configuration = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			VirtualUser = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VirtualInputManager = setmetatable({'AdditionalLuaState'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Accessory = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Accoutrement(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
			SelectionPointLasso = setmetatable({'Point'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SelectionLasso(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Skin = setmetatable({'SkinColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.CharacterAppearance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			GamePassService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Vector3Value = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StringValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIBase = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); IntConstrainedValue = setmetatable({'ConstrainedValue', 'MaxValue', 'MinValue', 'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataMember = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ReflectionMetadataItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AnalysticsSettings = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GenericSettings(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HopperBin = setmetatable({'Active', 'BinType'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BackpackItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RuntimeScriptService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HttpService = setmetatable({'HttpEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BrickColorValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FlyweightService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RodConstraint = setmetatable({'CurrentDistance', 'Length', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); MotorFeature = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Feature(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); EqualizerSoundEffect = setmetatable({'HighGain', 'LowGain', 'MidGain'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Model = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BinaryStringValue = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VRService = setmetatable({'GuiInputUserCFrame', 'VRDeviceName', 'VREnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Snap = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyAngularVelocity = setmetatable({'AngularVelocity', 'MaxTorque', 'P'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); VelocityMotor = setmetatable({'CurrentAngle', 'DesiredAngle', 'MaxVelocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UserInputService = setmetatable({'AccelerometerEnabled', 'BottomBarSize', 'GamepadEnabled', 'GazeSelectionEnabled', 'GyroscopeEnabled', 'KeyboardEnabled', 'LegacyInputEventsEnabled', 'ModalEnabled', 'MouseBehavior', 'MouseDeltaSensitivity', 'MouseEnabled', 'MouseIconEnabled', 'NavBarSize', 'OnScreenKeyboardAnimationDuration', 'OnScreenKeyboardPosition', 'OnScreenKeyboardSize', 'OnScreenKeyboardVisible', 'OverrideMouseIconBehavior', 'StatusBarSize', 'TouchEnabled', 'UserHeadCFrame', 'VREnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			SurfaceSelection = setmetatable({'TargetSurface'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PartAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UserGameSettings = setmetatable({'AllTutorialsDisabled', 'CameraMode', 'CameraYInverted', 'ChatVisible', 'ComputerCameraMovementMode', 'ComputerMovementMode', 'ControlMode', 'Fullscreen', 'GamepadCameraSensitivity', 'HasEverUsedVR', 'IsUsingCameraYInverted', 'IsUsingGamepadCameraSensitivity', 'MasterVolume', 'MicroProfilerWebServerEnabled', 'MicroProfilerWebServerIP', 'MicroProfilerWebServerPort', 'MouseSensitivity', 'MouseSensitivityFirstPerson', 'MouseSensitivityThirdPerson', 'OnScreenProfilerEnabled', 'OnboardingsCompleted', 'PerformanceStatsVisible', 'RotationType', 'SavedQualityLevel', 'TouchCameraMovementMode', 'TouchMovementMode', 'UsedCoreGuiIsVisibleToggle', 'UsedCustomGuiIsVisibleToggle', 'UsedHideHudShortcut', 'VREnabled', 'VRRotationIntensity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Part = setmetatable({'Shape'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FormFactorPart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FriendPages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Pages(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterPack = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StandardPages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Pages(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SoundService = setmetatable({'AmbientReverb', 'DistanceFactor', 'DopplerScale', 'RespectFilteringEnabled', 'RolloffScale'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UITableLayout = setmetatable({'FillEmptySpaceColumns', 'FillEmptySpaceRows', 'MajorAxis', 'Padding'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIGridStyleLayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); KeyboardService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DataStorePages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Pages(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DynamicRotate = setmetatable({'BaseAngle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UISizeConstraint = setmetatable({'MaxSize', 'MinSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ArcHandles = setmetatable({'Axes'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandlesBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LoginService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Players = setmetatable({'BubbleChat', 'CharacterAutoLoads', 'ClassicChat', 'MaxPlayers', 'MaxPlayersInternal', 'NumPlayers', 'PreferredPlayers', 'PreferredPlayersInternal'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIAspectRatioConstraint = setmetatable({'AspectRatio', 'AspectType', 'DominantAxis'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIConstraint = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIComponent(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BaseScript = setmetatable({'Disabled', 'LinkedSource'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LuaSourceContainer(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIComponent = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			ClusterPacketCache = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			VehicleController = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Controller(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RayValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RotateP = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.DynamicRotate(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Camera = setmetatable({'CFrame', 'CameraType', 'CoordinateFrame', 'FieldOfView', 'Focus', 'HeadLocked', 'HeadScale', 'NearPlaneZ', 'ViewportSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TweenService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FlagStandService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyForce = setmetatable({'Force'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIPageLayout = setmetatable({'Animated', 'Circular', 'EasingDirection', 'EasingStyle', 'GamepadInputEnabled', 'Padding', 'ScrollWheelInputEnabled', 'TouchInputEnabled', 'TweenTime'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIGridStyleLayout(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PartOperationAsset = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ModuleScript = setmetatable({'LinkedSource', 'Source'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LuaSourceContainer(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			Motor6D = setmetatable({'Transform'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Motor(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TouchInputService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UIPadding = setmetatable({'PaddingBottom', 'PaddingLeft', 'PaddingRight', 'PaddingTop'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIComponent(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BasePart = setmetatable({'Anchored', 'BackParamA', 'BackParamB', 'BackSurface', 'BackSurfaceInput', 'BottomParamA', 'BottomParamB', 'BottomSurface', 'BottomSurfaceInput', 'BrickColor', 'CFrame', 'CanCollide', 'CenterOfMass', 'CollisionGroupId', 'Color', 'CustomPhysicalProperties', 'Elasticity', 'Friction', 'FrontParamA', 'FrontParamB', 'FrontSurface', 'FrontSurfaceInput', 'LeftParamA', 'LeftParamB', 'LeftSurface', 'LeftSurfaceInput', 'LocalTransparencyModifier', 'Locked', 'Material', 'Orientation', 'Position', 'ReceiveAge', 'Reflectance', 'ResizeIncrement', 'ResizeableFaces', 'RightParamA', 'RightParamB', 'RightSurface', 'RightSurfaceInput', 'RotVelocity', 'Rotation', 'Size', 'SpecificGravity', 'TopParamA', 'TopParamB', 'TopSurface', 'TopSurfaceInput', 'Transparency', 'Velocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Explosion = setmetatable({'BlastPressure', 'BlastRadius', 'DestroyJointRadiusPercent', 'ExplosionType', 'Position', 'Visible'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TextFilterResult = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TestService = setmetatable({'AutoRuns', 'Description', 'ErrorCount', 'ExecuteWithStudioRun', 'Is30FpsThrottleEnabled', 'IsPhysicsEnvironmentalThrottled', 'IsSleepAllowed', 'NumberOfPlayers', 'SimulateSecondsLag', 'TestCount', 'Timeout', 'WarnCount'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PartAdornment = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase3d(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TerrainRegion = setmetatable({'IsSmooth', 'SizeInCells'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DataStoreService = setmetatable({'AutomaticRetry', 'LegacyNamingScheme'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TeleportService = setmetatable({'CustomizedTeleportUI'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ClientReplicator = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.NetworkReplicator(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TextButton = setmetatable({'Font', 'FontSize', 'LineHeight', 'LocalizedText', 'Text', 'TextBounds', 'TextColor', 'TextColor3', 'TextFits', 'TextScaled', 'TextSize', 'TextStrokeColor3', 'TextStrokeTransparency', 'TextTransparency', 'TextTruncate', 'TextWrap', 'TextWrapped', 'TextXAlignment', 'TextYAlignment'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiButton(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Teams = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Sound = setmetatable({'EmitterSize', 'IsLoaded', 'IsPaused', 'IsPlaying', 'Looped', 'MaxDistance', 'MinDistance', 'Pitch', 'PlayOnRemove', 'PlaybackLoudness', 'PlaybackSpeed', 'Playing', 'RollOffMode', 'SoundId', 'TimeLength', 'TimePosition', 'Volume'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			TaskScheduler = setmetatable({'SchedulerDutyCycle', 'SchedulerRate', 'ThreadPoolConfig', 'ThreadPoolSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			RunningAverageTimeIntervalItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StatsItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RunningAverageItemInt = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StatsItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StatsItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Stats = setmetatable({'ContactsCount', 'DataReceiveKbps', 'DataSendKbps', 'HeartbeatTimeMs', 'InstanceCount', 'MovingPrimitivesCount', 'PhysicsReceiveKbps', 'PhysicsSendKbps', 'PhysicsStepTimeMs', 'PrimitivesCount'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterCharacterScripts = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.StarterPlayerScripts(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScriptContext = setmetatable({'ScriptsDisabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpawnLocation = setmetatable({'AllowTeamChangeOnTouch', 'Duration', 'Enabled', 'Neutral', 'TeamColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyPosition = setmetatable({'D', 'MaxForce', 'P', 'Position'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterPlayerScripts = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterPlayer = setmetatable({'AllowCustomAnimations', 'AutoJumpEnabled', 'CameraMaxZoomDistance', 'CameraMinZoomDistance', 'CameraMode', 'DevCameraOcclusionMode', 'DevComputerCameraMovementMode', 'DevComputerMovementMode', 'DevTouchCameraMovementMode', 'DevTouchMovementMode', 'EnableMouseLockOption', 'HealthDisplayDistance', 'LoadCharacterAppearance', 'NameDisplayDistance'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScreenGui = setmetatable({'DisplayOrder', 'IgnoreGuiInset', 'OnTopOfCoreBlur'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LayerCollector(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); StarterGear = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataYieldFunctions = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpawnerService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Sparkles = setmetatable({'Color', 'Enabled', 'SparkleColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Dialog = setmetatable({'BehaviorType', 'ConversationDistance', 'GoodbyeChoiceActive', 'GoodbyeDialog', 'InUse', 'InitialPrompt', 'Purpose', 'Tone', 'TriggerDistance', 'TriggerOffset'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ThirdPartyUserService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CacheableContentProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ForceField = setmetatable({'Visible'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TremoloSoundEffect = setmetatable({'Depth', 'Duty', 'Frequency'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReverbSoundEffect = setmetatable({'DecayTime', 'Density', 'Diffusion', 'DryLevel', 'WetLevel'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ControllerService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PitchShiftSoundEffect = setmetatable({'Octave'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); EchoSoundEffect = setmetatable({'Delay', 'DryLevel', 'Feedback', 'WetLevel'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DistortionSoundEffect = setmetatable({'Level'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			Dragger = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Animation = setmetatable({'AnimationId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SoundEffect = setmetatable({'Enabled', 'Priority'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PathfindingService = setmetatable({'EmptyCutoff'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PostEffect = setmetatable({'Enabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Color3Value = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GenericSettings = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ServiceProvider(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ManualGlue = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ManualSurfaceJointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Platform = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DataModel = setmetatable({'CreatorId', 'CreatorType', 'GameId', 'GearGenreSetting', 'Genre', 'IsSFFlagsLoaded', 'JobId', 'PlaceId', 'PlaceVersion', 'VIPServerId', 'VIPServerOwnerId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ServiceProvider(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ServiceProvider = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Seat = setmetatable({'Disabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LineForce = setmetatable({'ApplyAtCenterOfMass', 'InverseSquareLaw', 'Magnitude', 'MaxForce', 'ReactionForceEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ScriptDebugger = setmetatable({'CurrentLine', 'IsDebugging', 'IsPaused'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RunService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReplicatedStorage = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PlayerGui = setmetatable({'CurrentScreenOrientation', 'ScreenOrientation'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePlayerGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RemoteFunction = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataProperties = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataEnumItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ReflectionMetadataItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Debris = setmetatable({'MaxItems'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataClass = setmetatable({'ExplorerImageIndex', 'ExplorerOrder', 'Insertable', 'PreferredParent', 'PreferredParents'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ReflectionMetadataItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			ReflectionMetadataItem = setmetatable({'Browsable', 'ClassCategory', 'Constraint', 'Deprecated', 'EditingDisabled', 'IsBackend', 'ScriptContext', 'UIMaximum', 'UIMinimum', 'UINumTicks'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GoogleAnalyticsConfiguration = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataFunctions = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkClient = setmetatable({'Ticket'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.NetworkPeer(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ParticleEmitter = setmetatable({'Acceleration', 'Color', 'Drag', 'EmissionDirection', 'Enabled', 'Lifetime', 'LightEmission', 'LightInfluence', 'LockedToPart', 'Rate', 'RotSpeed', 'Rotation', 'Size', 'Speed', 'SpreadAngle', 'Texture', 'Transparency', 'VelocityInheritance', 'VelocitySpread', 'ZOffset'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			Flag = setmetatable({'TeamColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Tool(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NonReplicatedCSGDictionaryService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FlyweightService(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ReflectionMetadataEnums = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BlurEffect = setmetatable({'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PostEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); HttpRbxApiService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SphereHandleAdornment = setmetatable({'Radius'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UserSettings = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GenericSettings(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginManager = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Button = setmetatable({'ClickableWhenViewportHidden', 'Enabled', 'Icon'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginAction = setmetatable({'ActionId', 'StatusTip', 'Text'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkServer = setmetatable({'Port'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.NetworkPeer(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Backpack = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Plugin = setmetatable({'CollisionEnabled', 'GridSize'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PhysicsService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkMarker = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CustomEventReceiver = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PlayerScripts = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BasePlayerGui = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ParabolaAdornment = setmetatable({'A', 'B', 'C', 'Range', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BadgeService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BevelMesh = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.DataModelMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Trail = setmetatable({'Color', 'Enabled', 'FaceCamera', 'Lifetime', 'LightEmission', 'LightInfluence', 'MaxLength', 'MinLength', 'Texture', 'TextureLength', 'TextureMode', 'Transparency', 'WidthScale'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Sky = setmetatable({'CelestialBodiesShown', 'MoonAngularSize', 'MoonTextureId', 'SkyboxBk', 'SkyboxDn', 'SkyboxFt', 'SkyboxLf', 'SkyboxRt', 'SkyboxUp', 'StarCount', 'SunAngularSize', 'SunTextureId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UnionOperation = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PartOperation(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); DockWidgetPluginGui = setmetatable({'HostWidgetWasRestored'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PluginGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiService = setmetatable({'AutoSelectGuiEnabled', 'CoreGuiNavigationEnabled', 'GuiNavigationEnabled', 'IsModalDialog', 'IsWindows', 'MenuIsOpen'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BallSocketConstraint = setmetatable({'LimitsEnabled', 'Radius', 'Restitution', 'TwistLimitsEnabled', 'TwistLowerAngle', 'TwistUpperAngle', 'UpperAngle'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkSettings = setmetatable({'ArePhysicsRejectionsReported', 'ClientPhysicsSendRate', 'DataGCRate', 'DataMtuAdjust', 'DataSendPriority', 'DataSendRate', 'ExtraMemoryUsed', 'FreeMemoryMBytes', 'IncommingReplicationLag', 'IsQueueErrorComputed', 'NetworkOwnerRate', 'PhysicsMtuAdjust', 'PhysicsSendPriority', 'PhysicsSendRate', 'PreferredClientPort', 'PrintBits', 'PrintEvents', 'PrintFilters', 'PrintInstances', 'PrintPhysicsErrors', 'PrintProperties', 'PrintSplitMessage', 'PrintStreamInstanceQuota', 'PrintTouches', 'ReceiveRate', 'RenderStreamedRegions', 'ShowActiveAnimationAsset', 'TouchSendRate', 'TrackDataTypes', 'TrackPhysicsDetails', 'UseInstancePacketCache', 'UsePhysicsPacketCache'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Translator = setmetatable({'LocaleId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); UILayout = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.UIComponent(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PackageLink = setmetatable({'PackageId', 'VersionId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			AnimationController = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GroupService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); AlignOrientation = setmetatable({'MaxAngularVelocity', 'MaxTorque', 'PrimaryAxisOnly', 'ReactionTorqueEnabled', 'Responsiveness', 'RigidityEnabled'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BlockMesh = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BevelMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Chat = setmetatable({'LoadDefaultChat'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SurfaceGui = setmetatable({'Active', 'AlwaysOnTop', 'CanvasSize', 'ClipsDescendants', 'Face', 'LightInfluence', 'ToolPunchThroughDistance', 'ZOffset'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LayerCollector(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Selection = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Workspace = setmetatable({'AllowThirdPartySales', 'DistributedGameTime', 'FallenPartsDestroyHeight', 'FilteringEnabled', 'Gravity', 'StreamingEnabled', 'TemporaryLegacyPhysicsSolverOverride'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Model(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Pants = setmetatable({'PantsTemplate'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Clothing(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SelectionSphere = setmetatable({'SurfaceColor', 'SurfaceColor3', 'SurfaceTransparency'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PVAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GamepadService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TrussPart = setmetatable({'Style'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ServerReplicator = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.NetworkReplicator(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CompressorSoundEffect = setmetatable({'Attack', 'GainMakeup', 'Ratio', 'Release', 'Threshold'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SoundEffect(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); FlagStand = setmetatable({'TeamColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Part(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PartOperation = setmetatable({'TriangleCount', 'UsePartColor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Hat = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Accoutrement(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BindableEvent = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SelectionPartLasso = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SelectionLasso(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			FormFactorPart = setmetatable({'FormFactor'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PrismaticConstraint = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.SlidingBallConstraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CornerWedgePart = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BasePart(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); TouchTransmitter = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); InventoryPages = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Pages(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Hint = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Message(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SpringConstraint = setmetatable({'Coils', 'CurrentLength', 'Damping', 'FreeLength', 'LimitsEnabled', 'MaxForce', 'MaxLength', 'MinLength', 'Radius', 'Stiffness', 'Thickness'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Constraint(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Fire = setmetatable({'Color', 'Enabled', 'Heat', 'SecondaryColor', 'Size'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); NetworkReplicator = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyThrust = setmetatable({'Force', 'Location'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Tween = setmetatable({'TweenInfo'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.TweenBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LuaWebService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LocalScript = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Script(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LuaSourceContainer = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LuaSettings = setmetatable({'AreScriptStartsReported', 'DefaultWaitTime', 'GcFrequency', 'GcLimit', 'GcPause', 'GcStepMul', 'WaitingThreadsBudget'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CoreScript = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BaseScript(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CylinderMesh = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BevelMesh(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ConeHandleAdornment = setmetatable({'Height', 'Radius'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.HandleAdornment(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); LocalizationService = setmetatable({'ForcePlayModeGameLocaleId', 'ForcePlayModeRobloxLocaleId', 'IsTextScraperRunning', 'RobloxForcePlayModeGameLocaleId', 'RobloxForcePlayModeRobloxLocaleId', 'RobloxLocaleId', 'SystemLocaleId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); CustomEvent = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Weld = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); QWidgetPluginGui = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.PluginGui(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BoolValue = setmetatable({'Value'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.ValueBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); 
			TextService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Pages = setmetatable({'IsFinished'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Beam = setmetatable({'Color', 'CurveSize0', 'CurveSize1', 'Enabled', 'FaceCamera', 'LightEmission', 'LightInfluence', 'Segments', 'Texture', 'TextureLength', 'TextureMode', 'TextureSpeed', 'Transparency', 'Width0', 'Width1', 'ZOffset'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiItem = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ChangeHistoryService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ClickDetector = setmetatable({'CursorIcon', 'MaxActivationDistance'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); PluginGui = setmetatable({'Title'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.LayerCollector(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Instance = setmetatable({'Archivable', 'ClassName', 'DataCost', 'Name', 'RobloxLocked'},{__call = function(me) return me end}); Hopper = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BackpackItem = setmetatable({'TextureId'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiItem(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Frame = setmetatable({'Style'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiObject(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); SurfaceLight = setmetatable({'Angle', 'Face', 'Range'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Light(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Decal = setmetatable({'Color3', 'LocalTransparencyModifier', 'Shiny', 'Specular', 'Texture', 'Transparency'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.FaceInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); RotateV = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.DynamicRotate(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); ContextActionService = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); GuiBase3d = setmetatable({'Color', 'Color3', 'Transparency', 'Visible'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.GuiBase(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Rotate = setmetatable({},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.JointInstance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); BodyVelocity = setmetatable({'MaxForce', 'P', 'Velocity'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.BodyMover(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end}); Keyframe = setmetatable({'Time'},{AllProps = {},__call = function(me, all) local meta = getmetatable(me) local p = meta.AllProps if all then if not next(p) then for i,v in next, self.Instance(true) do table.insert(p,v) end for i,v in next, me do table.insert(p,v) end end return p end return me end});
		} do gelf.__index[i] = v if i == index then ret = v end end return ret end});
};
Props = Citrus.property;
setmetatable(Props,{__index = {Default = {}, Custom = {}}})

function Props:storeDefaultProperties(className, propertyTable, overlapIndex)
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

function Props:setToDefaultProperties(Object, specificIndex, includeCustom)
	self:setProperties(Object, self:getDefaultPropeties(Object.ClassName, specificIndex), false, includeCustom, false);
end;

function Props:newCustomProperty(name, Function, ...) --... Classes that have the property
	local gelf = getmetatable(self).__index.Custom;

	rawset(gelf, name, setmetatable({Function = Function, Classes = {...},
		canUse = function(self, Object)
			local c = self.Classes;
			if #c == 0 or c[1] == 'all' then
				return true;
			else
				for i,v in next, c do
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

function Props:isACustomProperty(customProperty)
	return getmetatable(self).__index.Custom[customProperty] and true or false;
end;

function Props:sortRobloxAPI(sortFunction)
	table.sort(self.RobloxAPI, sortFunction);
end;

function Props:searchRobloxAPI(...)
	return Table.search(self.RobloxAPI, ...);
end;

function Props:hasProperty(Object, property)
	local has = pcall(function() return Object.Instance[property] or false end)
	return has, has and Object[property] or nil;
end;

function Props:getProperties(Object, allProperties)
	local propertyTable = {};

	for i,v in next, self.RobloxAPI[Object.ClassName](allProperties) do
		propertyTable[i] = v;
	end;

	return propertyTable;
end;

function Props:setProperties(Object, propertyTable, useVanilla, includeShortcuts, includeCustom, includeDefault)
	if includeDefault then
		self:setToDefaultProperties(Object, type(includeDefault) == 'number' and includeDefault or nil, includeCustom);
	end

	if useVanilla then
		for i,v in next, propertyTable do
			Object[i] = v;
		end

	else		
		for i,v in next, propertyTable do
			if includeShortcuts then 
				i = Props:searchRobloxAPI(Object.ClassName, i) or i
			end

			if includeCustom and self:isACustomProperty(i) then
				self:setToCustomProperty(Object, i, type(v) == 'table' and unpack(v) or v)
			elseif self:hasProperty(Object, i) then
				Object[i] = v;
			end;

		end;
	end
end;

--Theming
Citrus.theme = {};
Theming = Citrus.theme;
setmetatable(Theming, {__index = {Themes = {}, SyncFunctions = {}}});

function Theming:getTheme(name, index)
	local gelf = getmetatable(self)._index.Themes[name];

	return gelf and (index and gelf[index] or gelf) or nil;
end;

function Theming:setTheme(name, valueTable, syncFunction, autoSync, objectTable)
	local gelf = getmetatable(self)._index.Themes;

	if not gelf[name] then
		rawset(gelf, name, {
			values = {};
			objects = {};
			autoSync = false;
			syncFunction = function(Object, property, value)
				Object[property] = value;
			end;
		});
	end

	local theme = gelf[name]

	theme.values = valueTable or theme.values;
	theme.autoSync = autoSync or theme.autoSync;
	theme.syncFunction = self:getSyncFunction(syncFunction) or syncFunction or theme.syncFunction;

	self:insertObjects(objectTable);
end;

function Theming:insertObjectToTheme(name, index, Object, Property)
	local theme = self:getTheme(name) or error('Not existing theme');

	if theme then
		if not theme.objects.Object then
			rawset(theme.objects, Object, {});
		end

		rawset(theme.objects.Object, Property, index or 1);
	end
end;

function Theming:insertObjectsToTheme(name, objectTable)
	for object, v in next, objectTable do
		for property, index in next, v do
			self:insertObjectToTheme(name, index, object, property)

		end
	end
end;

function Theming:sync(name, syncFunction)
	local theme = self:getTheme(name) or error('Not existing theme');

	if theme then
		local values = theme.values;

		for object, v in next, theme.objects do
			for property, index in v do
				(self:getSyncFunction(syncFunction) or theme.syncFunction)(object, property, values[index] or next(values));
			end
		end
	end
end;

function Theming:setSyncFunction(name, Function)
	rawset(getmetatable(self).__index.SyncFunctions, name, Function)
end;

function Theming:getSyncFunction(name)
	return name and getmetatable(self).__index.SyncFunctions[name] or nil;
end;

--Motion
Citrus.motion = {};
Motion = Citrus.motion;
setmetatable(Motion,{__index = {Lerps = { 
	['Color3'] = Color3.new().Lerp;
	['Vector2'] = Vector2.new().Lerp;
	['UDim2'] = UDim2.new().Lerp;
	['CFrame'] = CFrame.new().Lerp;
	['Vector3'] = Vector3.new().Lerp;
	['UDim'] = function(a, b, c)
		local function x(y)
			return a[y] + c * (b[y] - a[y])
		end
		return UDim.new(x'Scale',x'Offset')
	end;
	number = function(a,b,c)
		return a + c * (b - a)
	end;
}, Easings = {}}});

function Motion:storeEasing(directionName, easingName, Function)
	local gelf = getmetatable(self).__index.Easings;

	if not gelf[easingName] then
		gelf[easingName] = {};
	end

	gelf[easingName][directionName] = Function;
end;

function Motion:getEasing(directionName, easingName)
	local gelf = getmetatable(self).__index.Easings;

	if not gelf[easingName] then
		return warn("Easing " .. easingName.. " doesn't exist") and false;
	end

	return gelf[easingName][directionName];
end;

function Motion:setLerp(typeName, Function)
	local gelf = getmetatable(self).__index.Lerps;

	rawset(gelf, typeName, Function);
end;

function Motion:newLerpFromBezier(x1, y1, x2, y2)--function from RoStrap
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

function Motion:createTween(Object, propertyTable, duration, directionName, easingName, ...)
	local tween = game:GetService('TweenService'):Create(Object, TweenInfo.new(
			duration or 1, 
			easingName and Enum.EasingStyle[easingName] or Enum.EasingStyle[1], 
			directionName and Enum.EasingDirection[directionName] or Enum.EasingDirection[1],
			...
		));

	return tween;
end;

--function Motion:customTweenObject(Object, propertyTable, duration, easingName, directionName, ...)

--end;

function Motion:lerp(beginingValue, endValue, alpha, directionName, easingName)
    local lerp = getmetatable(self).__index.Lerps[type(beginingValue)] or warn(type(beginingValue) .. " lerping doesn't exist") and false;
    local easing = self:getEasing(directionName, easingName);

    return lerp and lerp(beginingValue, endValue, easing and easing(alpha, 0, 1, 1) or alpha) or false;
end;


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