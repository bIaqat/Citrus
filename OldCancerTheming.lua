Theming = setmetatable({ --almost 100% positive this is 100% BROKEN
		new = function(name,...)
			local args, filter, funct, vals = {}
			local vals = {...}
			if type(vals[1]) == 'table' then
				filter = vals[1]
				table.remove(vals,1)
			end
			for i,v in next,vals do
				if type(v) == 'function' then
					funct = v
					for x = i+1,#vals do
						table.insert(args,vals[x])
						table.remove(vals,x)
					end
					table.remove(vals,i)
					break
				end
			end
			local newTheme
			newTheme = setmetatable({
					Sync = function(self,...)
						Spice.Theming.syncTheme(name,...)
					end;
					Set = function(self,...)
						Spice.Theming.setTheme(name,...)
					end;
					Call = function(self,...)
						Spice.Theming.callTheme(name,...)
					end;
					Insert = function(self,...)
						Spice.Theming.insertObjects(name,...)
					end;
					Values = vals or {};
					Funct = setmetatable({funct or nil,unpack(args)},{
								__call = function(self,...)
									coroutine.wrap(function(...)
										for i,v in pairs(newTheme.Objects)do
											if ... then
												self[1](v,...)
											else
												self[1](v,unpack(Spice.Misc.Table.pack(self,2)))
											end
										end
									end)(...)
								end});
					Filter = filter or {};
					Objects = {};
			},{
					__call = function(self,obj,filv)
						local hasClass
						local checks
						local used = {}
						--first checks to make sure its eligible to be used
						for i,v in pairs(self.Filter)do
							if Spice.Instance.isAClass(v) or Spice.Instance.isAClass(i) then
								if obj:IsA(v) or obj:IsA(i) then
									checks = true
								end
								hasClass = true
							end	
							if Spice.Instance.isAClass(i) and type(v) ~= 'boolean' then
								for _,val in pairs(filv or self.Values)do
									if Spice.Properties.hasProperty(obj,v) and type(val) == type(obj[Spice.Properties[v]]) and not Spice.Misc.Table.find(used,v) then
										obj[Spice.Properties[v]] = val
									end
									table.insert(used,val)
								end
							end
						end
						if not hasClass or checks then
							for _,prop in next,self.Filter do
								for _,val in next,filv or self.Values do
									if Spice.Properties.hasProperty(obj,prop) and type(val) == type(obj[Spice.Properties[prop]]) and not Spice.Misc.Table.find(used,val) then
										obj[Spice.Properties[prop]] = val
										table.insert(used,val)
									end
								end
							end
						end
						if Spice.Misc.Table.length(self.Filter) == 0 then
							for _,val in next,filv or self.Values do
								for prop,_ in next,Spice.Properties.getProperties(obj)do
									if Spice.Properties.hasProperty(obj,prop) and typeof(obj[prop]) == typeof(val) then
										pcall(function()
											obj[prop] = val
										end)
									end
								end
							end
						end
					end;
				}
			)	
			getmetatable(Spice.Theming).Themes[name] = newTheme
			return newTheme
		end;
		getTheme = function(name)
			return Spice.Misc.Table.find(getmetatable(Spice.Theming).Themes,name)
		end;
		insertObjects = function(name,...)
			local theme = Spice.Theming.getTheme(name)
			for ins,ob in next,{...} or {} do
				if Spice.Instance.isAClass(ins) then
					theme.Objects[ins] = ob
					theme(ins,ob)
				else
					table.insert(theme.Objects,ob)
					theme(ob)
				end
			end
			Spice.Theming.syncTheme(name)
		end;
		syncTheme = function(name)
			local theme = Spice.Theming.getTheme(name)
			pcall(function() theme:Call() end)
			for ins,ob in next,theme.Objects or {} do
				if Spice.Instance.isAClass(ins) then
					theme.Objects[ins] = ob
					theme(ins,ob)
				else
					theme(ob)
				end
			end
		end;
		callTheme = function(name,...)
			return Spice.Theming.getTheme(name).Funct(...)
		end;
		setTheme = function(name,...)
			local used = {}
			local theme = Spice.Theming.getTheme(name)
			local vals = theme.Values
			for index,val in next, vals do
				for _,new in next,{...} do
					if typeof(val) == typeof(new) and not Spice.Misc.Table.find(used,new) then
						vals[index] = new
						table.insert(used,new)
					end
				end
			end
			theme:Sync()
		end;
	},{
		Themes = {};
	}
)	
