Spice.Theming = setmetatable({
	isActive = function(themeName)
		for i,v in next, getmetatable(Spice.Theming).Active do
			if v.ThemeName == themeName then
				return true, v
			end
		end
		return false
	end;
	newTheme = function(name,...)
		getmetatable(Spice.Theming).Themes[name] = setmetatable({
			...
		},{...})
	end;
	setTheme = function(name, ...)
		local vals = getmetatable(Spice.Theming).Themes[name]
		for i,v in next, {...} do
			if v then
				vals[i] = v
			end
		end
		local check, active = Spice.Theming.isActive(name)
		if check then
			for object,v in next, active.Objects do
				for property, index in next, v do
					pcall(function()
						if active.lerp then
							Spice.Tweening.new(object,property,vals[index],type(active.lerp) == 'table' and unpack(active.lerp) or active.lerp)
						else
							object[property] = vals[index]
						end
					end)
				end
			end
		end
	end;
	themeToDefault = function(name)
		Spice.Theming.setTheme(name, unpack(getmetatable(getmetatable(Spice.Theming).Themes[name])))
	end;
	getTheme = function(name)
		return getmetatable(Spice.Theming).Themes[name]
	end;
	new = function(name, themeName, ...)
		local act = setmetatable({
			Objects = {};
			ThemeName = themeName;
			lerp = false;
			Name = name;
			toTheme = function(self,to)
				Spice.Theming.set(self.Name, to)
			end;
			Insert = function(self, ...)
				Spice.Theming.insertObject(self.Name, ...)
			end;
			Set = function(self, ...)
				Spice.Theming.setTheme(self.ThemeName, ...)
			end;
			Sync = function(self)
				Spice.Theming.sync(self.Name)
			end;
			toDefault = function(self)
				Spice.Theming.themeToDefault(self.ThemeName)
			end;
			setLerpStyle = function(self,tim,...)
				if not tim then
					self.lerp = false
				elseif ... then
					self.lerp = {tim,...}
				else
					self.lerp = tim
				end
			end;
		},{
			Theme = {};
			__index = function(self,ind)
				if ind == 'Theme' then
					return getmetatable(self).Theme
				end
			end;
			__newindex = function(self,ind,new)
				if ind == 'Theme' then
					self.ThemeName = new
					getmetatable(self).Theme = Spice.Theming.getTheme(new)
				end
			end;
		})
		act.Theme = themeName
		if ... then
			Spice.Theming.setTheme(themeName,...)
		end
		getmetatable(Spice.Theming).Active[name] = act
		return act
	end;
	set = function(name, to)
		getmetatable(Spice.Theming).Active[name].Theme = to
	end;
	insertObject = function(name,obj,prop,ind)
		prop = Spice.Properties[prop]
		local active = getmetatable(Spice.Theming).Active[name]
		local link = getmetatable(Spice.Theming).ObjectLinks
		if link[obj] then
			link[obj][obj][prop] = nil
		else
			link[obj] = active.Objects
		end
		if not active.Objects[obj] then active.Objects[obj] = {} end
		active.Objects[obj][prop] = ind or 1
		obj[prop] = active.Theme[ind or 1]
	end;
	sync = function(name)
		local active = getmetatable(Spice.Theming).Active[name]
		for object,v in next, active.Objects do
			for property, index in next, v do
				pcall(function()
					if active.lerp then
						Spice.Tweening.new(object,property,active.Theme[index],type(active.lerp) == 'table' and unpack(active.lerp) or active.lerp)
					else
						object[property] = active.Theme[index]
					end
				end)
			end
		end
	end;
},{
	Active = {};
	Themes = {};
	ObjectLinks = {};
})
