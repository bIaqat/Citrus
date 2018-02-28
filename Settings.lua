Settings = setmetatable({
		getDefault = function(classname)
			return classname and getmetatable(Pineapple.Settings).Default[classname] or getmetatable(Pineapple.Settings).Default
		end;
		setDefault = function(classname,properties)
			getmetatable(Pineapple.Settings).Default[classname] = properties;
		end;
		newList = function(name)
			getmetatable(Pineapple.Settings).Settings[name] = {};
		end;
		getList = function(name)
			return getmetatable(Pineapple.Settings).Settings[name] or {}
		end;
		new = function(list,name,object,index,defaultval)
			local list = Pineapple.Settings.getList(list)
			list[name] = {[object] = index, Value = defaultval or object[index], Default = defaultval;
				Set = function(self,newval)
					self.Value = newval
					local i,v = next(self)
					i[v] = newval
				end;
				toDefault = function(self)
					self:Set(self.Default)
				end;
			}
			return list
		end;
		},{
		Default = {};
		Settings = {};
	}
)
  
