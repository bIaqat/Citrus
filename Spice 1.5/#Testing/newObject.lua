newObject = function(...)
	local args,obj,class,parent,props = {...},{}
	for i,v in next,args do
		class = type(v) == 'string' and Spice.Instance.isAClass(v) and v or class
		parent = typeof(v) == 'Instance' and v or parent
		props = type(v) == 'table' and Spice.Table.length(obj) > 0 and v or props
		obj = type(v) == 'table' and Spice.Table.length(obj) == 0 and v or obj
	end
	local ins = Spice.Instance.newInstance(class,parent)
	local new = newproxy(true)
	getmetatable(new).__index = {setmetatable = function(self, tab) for i,v in next, getmetatable(self) do getmetatable(self)[i] = nil end for i,v in next, tab do getmetatable(self)[i] = v end end}
	local newmeta = {
		Instance = ins, Object = obj, Index = {}, NewIndex = {};
		__index = function(proxy,ind)
			local self = getmetatable(proxy)
			if ind == 'Instance' or ind == 'Object' then return self[ind] end
			if Spice.Table.contains(self.Index,ind) then
				local ret = Spice.Table.find(self.Index,ind)
				return type(ret) ~= 'function' and ret or ret(proxy)
			elseif Spice.Table.contains(self.Object,ind) or not Spice.Properties.hasProperty(self.Instance,ind) then
				return Spice.Table.find(self.Object,ind)
			elseif Spice.Properties.hasProperty(self.Instance,ind) then
				return self.Instance[Spice.Properties[ind]]
			end
		end;	
		__newindex = function(proxy,ind,new)
			local self = getmetatable(proxy)
			if Spice.Table.contains(self.NewIndex,ind) then
				Spice.Table.find(self.NewIndex,ind)(self,new)
			elseif Spice.Table.contains(self.Object,ind) or not Spice.Properties.hasProperty(self.Instance,ind) or type(new) == 'function' then
				rawset(self.Object,ind,new)
			elseif Spice.Properties.hasProperty(self.Instance,ind) then
				self.Instance[Spice.Properties[ind]] = new
			end
		end;
		__call = function(self,prop)
			local self = getmetatable(self)
			Spice.Properties.setProperties(self.Instance,prop)
		end;	
		__namecall = function(self, ...)
			local args = {...}
			local name = args[#args]
			table.remove(args,#args)
			local self = getmetatable(self)
			local default = {
				Index = function(name,what)
					rawset(getmetatable(self).Properties.Index,name,what)
				end;
				NewIndex = function(name,what)
					if type(what) == 'function' then
						rawset(getmetatable(self).Properties.NewIndex,name,what)
					end
				end;
				Clone = function(parent,prop)
					return Spice.Instance.cloneObject(self,parent,prop)
				end;
			}
			if default[name] then return default[name](unpack(args)) end
			if self.Instance[name] and type(self.Instance[name]) == 'function' then
				return self.Instance[name](self.Instance,unpack(args))
			end
		end
	}
	new:setmetatable(newmeta)
	rawset(getmetatable(Spice.Instance).Objects,new.Instance,new)
	Spice.Properties.setProperties(new,props or {})
	return new
end