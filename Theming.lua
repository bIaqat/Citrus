Theming = setmetatable({
	new = function(name,...)
		local theme = {
			AutoSync = true;
			Name = name;
			Values = setmetatable({...},{
				__call = function(self,index,typ)
					local vals = typ and {} or self
					if typ then
						for i,v in next, self do
							if type(v) == typ then
								table.insert(vals,v)
							end
						end
					end
					return vals[index or 1], vals
				end;
			});
			Objects = {};
			Set = function(self,...)
				Spice.Theming.setTheme(self,...)
			end;
			Insert = function(self,...)
				Spice.Theming.insertObjectToTheme(self,...)
			end;
			Sync = function(self,...)
				Spice.Theming.sync(self,...)
			end;
		}
		getmetatable(Spice.Theming).Themes[name] = theme
		return theme
	end;
	getTheme = function(name,index,typ)
		local theme = type(name) == 'table' and name or type(name) == 'string' and getmetatable(Spice.Theming).Themes[name]
		return index and theme.Values(index,typ) or theme
	end;
	setTheme = function(name,...)
		local theme = type(name) == 'table' and name or Spice.Theming.getTheme(name)
		local args = {...}
		if #args == 2 and type(args[2]) == 'number' then
			theme.Values[args[2]] = args[1]
		else
			theme.Values = setmetatable({...},getmetatable(theme.Values))
		end
		local run = theme.AutoSync and theme:Sync()
	end;
	insertObjectToTheme = function(name,obj,prop,ind)
		local theme = type(name) == 'table' and name or Spice.Theming.getTheme(name)
		local value = theme.Values(ind,type(obj[prop]))
		if not Spice.Instance.isAnObject(obj) then
			prop = Spice.Properties[prop]
		end
		if not theme.Objects[obj] then
			theme.Objects[obj] = {}
		end
		theme.Objects[obj][prop] = ind or 1
		obj[prop] = theme.AutoSync and value or obj[prop]
	end;
	sync = function(name,lerp,tim,...)
		if not name then
			for i,v in next, getmetatable(Spice.Theming).Themes do
				Spice.Theming.sync(v)
			end
		else
			name = type(name) == 'table' and name or Spice.Theming.getTheme(name)
			for obj,v in next, name.Objects do
				for prop,ind in next, v do
					local value = name.Values(ind,type(obj[prop]))
					if not lerp then
						obj[prop] = value
					else
						Spice.Misc.tweenService(obj,prop,value,tim or 1,...)
					end
				end
			end
		end
	end
},{
	Themes = {};
});
