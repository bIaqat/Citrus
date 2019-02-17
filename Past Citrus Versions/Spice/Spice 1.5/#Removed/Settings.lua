Settings = setmetatable({
	newList = function(name)
		getmetatable(Spice.Settings).Settings[name] = {};
	end;
	getList = function(name)
		local settings = getmetatable(Spice.Settings).Settings
		return not name and settings.MAIN or settings[name]
	end;
	new = function(list,name,object,index,defaultval,...)
		local list = Spice.Settings.getList(list)
		local setting = setmetatable({[object] = index, Default = defaultval;
			Set = function(self,newval)
				self.Value = newval
			end;
			toDefault = function(self)
				self:Set(self.Default or self.Value)
			end;
		},	{
				Storage = {...};
				Value = defaultval or object[index];
				__tostring = function(self)
					return ''..getmetatable(self).Value
				end;
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
		object:GetPropertyChangedSignal(index):connect(function()
			setting:Set(object[index])
		end)	
		list[name] = setting
		return setting
	end;
	getSetting = function(name,list)
		if list then return Spice.Table.find(Spice.Settings.getList(list),name) end
		for i,v in next, getmetatable(Spice.Settings).Settings.MAIN do
			if i == name then
				return v
			end
		end
	end;
	setSetting = function(name,newval,list)
		Spice.Settings.getSetting(name,list and list or nil):Set(newval)
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
});
