Effects = {};
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

function Effects:effectOnEvent(Object, eventName, effectName, ...)
	local args = {...};
	Object[eventName]:connect(function(possibleObject)
		if typeof(possibleObject) == 'Instance' then 
			Object = possibleObject;
		end
		self:effect(Object, effectName, unpack(args));
	end)
end;
