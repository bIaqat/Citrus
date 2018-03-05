Settings = setmetatable({
		getDefault = function(classname)
			return classname and getmetatable(Citrus.Settings).Default[classname] or getmetatable(Citrus.Settings).Default
		end;
		setDefault = function(classname,properties)
			getmetatable(Citrus.Settings).Default[classname] = properties;
		end;
		newList = function(name)
			getmetatable(Citrus.Settings).Settings[name] = {};
		end;
		getList = function(name)
			local settings = getmetatable(Citrus.Settings).Settings
			return not name and settings.MAIN or settings[name]
		end;
		new = function(list,name,object,index,defaultval,...)
			local list = Citrus.Settings.getList(list)
			local setting = setmetatable({[object] = index, Default = defaultval;
				Set = function(self,newval)
					self.Value = newval
				end;
				toDefault = function(self)
					self:Set(self.Default or self.Value)
				end;
			},	{
					Storage = {...};
					Value = object[index];
					__index = function(self,a)
						if a == 'Value' then
							return getmetatable(self).Value
						elseif a == 'Storage' then
							return getmetatable(self).Storage
						end
					end;
					__newindex = function(self,a,new)
						if a == 'Value' then
							object[index] = new
							rawset(getmetatable(self),a,new)
						elseif a == 'Storage' then
							rawset(getmetatable(self),a,new)
						end
					end;
				}
			)
			if type(object[index]) == 'boolean' then
				function setting:Toggle()
					if setting.Value then
						setting:Set(false)
					else
						setting:Set(true)
					end
				end
			end
			object.GetPropertyChangedSignal(index):connect(function()
					setting:Set(object[index])
			end)	
			return list
		end;
		getSetting = function(name,list)
			if list then return Citrus.Misc.Table.find(list,name) end
			for i,v in next, getmetatable(Citrus.Settings).Settings do
				for n, ret in next, v do
					if n == name then 
						return ret
					end
				end
			end
		end;
		setSetting = function(name,newval,list)
			Citrus.Settings.get(name,list):Set(newval)
		end;
		Sync = function(self)
			for _,list in next, getmetatable(self).Settings do
				for name, setting in next, list do
					setting:Set(setting.Value)
				end
			end
		end;
		},{
		Default = {};
		Settings = {
			MAIN = {};
		};
	}
)