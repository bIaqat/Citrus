Theming = setmetatable({
	Themes = {}
	},{
	Objects = {};
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			new = function(name,...)
				local theme = {
					SyncFunction = function(self, obj, prop, val)
						obj[prop] = val
					end;
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
					Set = function(theme,...)
						local args = {...}
						if #args == 2 and type(args[2]) == 'number' then
							theme.Values[args[2]] = args[1]
						else
							theme.Values = setmetatable({...},getmetatable(theme.Values))
						end
						local run = theme.AutoSync and theme:Sync()
					end;
					Insert = function(theme,obj,prop,ind)
						local objs = getmetatable(self)
						if objs[obj] then
							self.Themes[objs[obj]].Objects[obj][prop] = nil
						end
						local value = theme.Values(ind,type(obj[prop]))
						if not theme.Objects[obj] then
							theme.Objects[obj] = {}
						end
						theme.Objects[obj][prop] = ind or 1
						obj[prop] = theme.AutoSync and value or obj[prop]
						objs[obj] = name;
					end;
					Sync = function(name,lerp,tim,...)
						for obj,v in next, name.Objects do
							for prop,ind in next, v do
								local value = name.Values(ind,type(obj[prop]))
								if not lerp then
									name:SyncFunction(obj, prop, value)
								else
									game:GetService('TweenService'):Create(obj,TweenInfo.new(tim or 1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,...),{[prop] = value}):Play()
								end
							end
						end						
					end;
					setSync = function(me, func)
						me.SyncFunction = func
					end;
				}
				self.Themes[name] = theme
				return theme
			end;
			getTheme = function(name,index,typ)
				local theme = type(name) == 'table' and name or type(name) == 'string' and self.Themes[name]
				return index and theme.Values(index,typ) or theme
			end;
			setTheme = function(name,...)
				local theme = type(name) == 'table' and name or self.getTheme(name)
				theme:Set(...);
			end;
			insertObject = function(name,...)
				local theme = type(name) == 'table' and name or self.getTheme(name)
				theme:Insert(...)
			end;
			sync = function(name,...)
				if not name then
					for i,v in next, self.Themes do
						self.sync(v)
					end
				else
					name = type(name) == 'table' and name or self.getTheme(name)
					name:Sync(...)
				end
			end;
			setSyncFunction = function(theme, func)
				theme = type(theme) == 'table' and theme or self.getTheme(theme)
				theme:setSync(func)
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
