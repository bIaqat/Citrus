
Theming = {};
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
			for property, index do
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