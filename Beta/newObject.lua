newObject = function(...)
	local function insert(who)
		rawset(getmetatable(Spice.Instance).Objects,who.Instance,who.Object)
	end
	local args,obj,class,parent,props = {...},{}
	for i,v in next,args do
		class = type(v) == 'string' and Spice.Instance.isAClass(v) and v or class
		parent = typeof(v) == 'Instance' and v or parent
		obj = type(v) == 'table' and Spice.Misc.Table.length(obj) == 0 and v or obj
		props = type(v) == 'table' and Spice.Misc.Table.length(obj) > 0 and v or props
	end
	local ins = Spice.Instance.newInstance(class,parent,props)
	local new = {Instance = ins,Object = obj}
	local newmeta = {
		Properties = {Index = {}, NewIndex = {}};
		--__index = function(self,ind)
		--	return Spice.Misc.Table.contains(pro.Index,ind) and (type(Spice.Misc.Table.find(pro.Index,ind)) ~= 'function' and Spice.Misc.Table.find(pro.Index,ind) or Spice.Misc.Table.find(pro.Index,ind)()) or Spice.Misc.Table.contains(self.Object,ind) and Spice.Misc.Table.find(self.Object,ind) or Spice.Properties.hasProperty(self.Instance,ind) and self.Instance[Spice.Properties[ind]]
		--end
		__index = function(self,ind)
			local pro = getmetatable(self).Properties
			if Spice.Misc.Table.contains(pro.Index,ind) then
				local ret = Spice.Misc.Table.find(pro.Index,ind)
				return type(ret) ~= 'function' and ret or ret()
			elseif Spice.Misc.Table.contains(self.Object,ind) or not Spice.Properties.hasProperty(self.Instance,ind) then
				return Spice.Misc.Table.find(self.Object,ind)
			elseif Spice.Properties.hasProperty(self.Instance,ind) then
				return self.Instance[Spice.Properties[ind]]
			end
		end;
		__newindex = function(self,ind,new)
			local pro = getmetatable(self).Properties
			if Spice.Misc.Table.contains(pro.NewIndex,ind,new) then
				Spice.Misc.Table.find(pro.NewIndex,ind)(new)
			elseif Spice.Misc.Table.contains(self.Object,ind) or not Spice.Properties.hasProperty(self.Instance,ind) then
				rawset(self.Object,ind,new)
			elseif Spice.Properties.hasProperty(self.Instance,ind) then
				self.Instance[Spice.Properties[ind]] = new
			end
		end;
		__call = function(self,prop)
			Spice.Properties.setProperties(self.Instance,prop)
		end;
	}
	function new:Index(name,what)
		rawset(getmetatable(self).Properties.Index,name,what)
	end;
	function new:NewIndex(name,what)
		if type(what) == 'function' then
			rawset(getmetatable(self).Properties.NewIndex,name,what)
		end
	end;
	function new:Clone(parent,prop)
		local ins = self.Instance:Clone()
		ins.Parent = parent
		local clone = Spice.Misc.Table.clone(self)
		clone.Instance = ins
		insert(clone)
		return clone
	end;
	setmetatable(new,newmeta)
	insert(new)
	return new
end