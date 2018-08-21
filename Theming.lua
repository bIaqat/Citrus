Theming = setmetatable({
	Themes = {}
	},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
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
						self.setTheme(self,...)
					end;
					Insert = function(self,...)
						self.insertObject(self,...)
					end;
					Sync = function(self,...)
						self.sync(self,...)
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
				local args = {...}
				if #args == 2 and type(args[2]) == 'number' then
					theme.Values[args[2]] = args[1]
				else
					theme.Values = setmetatable({...},getmetatable(theme.Values))
				end
				local run = theme.AutoSync and theme:Sync()
			end;
			insertObject = function(name,obj,prop,ind)
				local theme = type(name) == 'table' and name or self.getTheme(name)
				local value = theme.Values(ind,type(obj[prop]))
				if not theme.Objects[obj] then
					theme.Objects[obj] = {}
				end
				theme.Objects[obj][prop] = ind or 1
				obj[prop] = theme.AutoSync and value or obj[prop]
			end;
			sync = function(name,lerp,tim,...)
				if not name then
					for i,v in next, self.Themes do
						self.sync(v)
					end
				else
					name = type(name) == 'table' and name or self.getTheme(name)
					for obj,v in next, name.Objects do
						for prop,ind in next, v do
							local value = name.Values(ind,type(obj[prop]))
							if not lerp then
								obj[prop] = value
							else
								game:GetService('TweenService'):Create(obj,TweenInfo.new(tim or 1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,...),{prop = value}):Play()
							end
						end
					end
				end
			end			
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
