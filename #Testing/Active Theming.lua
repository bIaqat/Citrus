Theming = setmetatable({
	isActive = function(themeName)
		for i,v in next, getmetatable(Spice.Theming).Active do
			if v.ThemeName == themeName then
				return true, v
			end
		end
		return false
	end;
	newTheme = function(name,...)
		getmetatable(Spice.Theming).Themes[name] = {
			...
		}
	end;
	setTheme = function(name, ...)
		local vals = getmetatable(Spice.Theming).Themes[name]
		for i,v in next, {...} do
			if v then
				vals[i] = v
			end
		end
		local _, active = Spice.Theming.isActive(name) or nil
		if active then
			for object,v in next, active.Objects do
				for property, index in next, v do
					pcall(function()
						object[property] = vals[index]
					end)
				end
			end
		end
	end;
	getTheme = function(name)
		return getmetatable(Spice.Theming).Themes[name]
	end;
	new = function(name, themeName, ...)
		local act = setmetatable({
			Objects = {};
			ThemeName = themeName;
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
	end;
	set = function(name, to)
		getmetatable(Spice.Theming).Active[name].Theme = to
	end;
	insertObject = function(name,obj,prop,ind)
		prop = Spice.Properties[prop]
		local active = getmetatable(Spice.Theming).Active[name]
		if not active.Objects[obj] then active.Objects[obj] = {} end
		active.Objects[obj][prop] = ind or 1
		obj[prop] = active.Theme[ind or 1]
	end;
	sync = function(name)
		local active = getmetatable(Spice.Theming).Active[name]
		for object,v in next, active.Objects do
			for property, index in next, v do
				pcall(function()
					object[property] = active.Theme[index]
				end)
			end
		end
	end;
},{
	Active = {};
	Themes = {};
})
