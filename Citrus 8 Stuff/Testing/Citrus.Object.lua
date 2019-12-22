Objects = {};
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

			return se;
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