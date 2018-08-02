Effects = setmetatable({
	Effects = {}
	},{
	__index = function(self,index)
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
				Object.onChildAdded:connect(function(Object)
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
				end)
			end;
			affectOnDescendantAdded = function(Object, Name,...)
				local args = {...}
				Object.onDescendantAdded:connect(function(Object)
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, unpack(args))
				end)
			end;
			affectAncestors = function(Object,Name,...)
				for _,Object in next, Spice.Instance.getAncestors(Object) do
					(type(Name) == 'string' and self.Effects[Name] or Name)(Object, ...)
				end
			end;
			massAffect = function(Object, Name, ...)
				self.affectChildren(...)
				self.affectOnChildAdded(...)
			end;
			affectOnEvent = function(Object, EventName, Name, ...)
				local args = {...}
				Object[EventName]:connect(function(arg)
					(type(Name) == 'string' and self.Effects[Name] or Name)(typeof(arg) == 'Instance' and arg or Object, unpack(args))
				end)
			end;
		} do
			local self = getmetatable(self)
			self.__index = {}
			self.__index[i] = v
			if i == index then
				return v
			end
		end
	end
});