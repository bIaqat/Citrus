Effects = setmetatable({
	Effects = {}
	},{
	__index = function(self,index)
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {	
			new = function(Name, Function)
				self.Effects[Name] = Function;
			end;
			get = function(Name)
				return self.Effects[Name]
			end;
			affect = function(Object, Name, ...) --... Function Args
				return (type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
			end;
			affectChildren = function(Object, Name, ...)
				for _,Object in next, Object:GetChildren() do
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
				end
			end;
			affectDescendants = function(Object, Name, ...)
				for _,Object in next, Object:GetDescendants() do
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
				end
			end;
			affectOnChildAdded = function(Object, Name, ...)
				local args = {...}
				return Object.ChildAdded:connect(function(Object)
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
				end)
			end;
			affectOnDescendantAdded = function(Object, Name,...)
				local args = {...}
				return Object.DescendantAdded:connect(function(Object)
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
				end)
			end;
			affectAncestors = function(Object,Name,...)
				for _,Object in next, Spice.Instance.getAncestors(Object) do
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
				end
			end;
			massAffect = function(...)
				return self.affectChildren(...),
				self.affectOnChildAdded(...)
			end;
			affectOnEvent = function(Object, EventName, Name, ...)
				local args = {...}
				return Object[EventName]:connect(function(arg)
					if typeof(arg) == 'Instance' then Object = arg else
						table.insert(args,1,arg)
					end
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
				end)
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end
});
