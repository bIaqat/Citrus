newObject = function(...)
	local function insert(who)
		rawset(getmetatable(Citrus.Instance).Objects,who.Instance,who.Object)
	end
	local args,obj,class,parent,props = {...},{}
	for i,v in next,args do
		class = type(v) == 'string' and Citrus.Instance.isAClass(v) and v or class
		parent = typeof(v) == 'Instance' and v or parent
		obj = type(v) == 'table' and Citrus.Misc.Table.length(obj) == 0 and v or obj
		props = type(v) == 'table' and Citrus.Misc.Table.length(obj) > 0 and v or props
	end
	local ins = Citrus.Instance.newInstance(class,parent,props)
	local new = {Instance = ins,Object = obj}
	local newmeta = {
		Properties = {Index = {}, NewIndex = {}};
		--__index = function(self,ind)
		--	return Citrus.Misc.Table.contains(pro.Index,ind) and (type(Citrus.Misc.Table.find(pro.Index,ind)) ~= 'function' and Citrus.Misc.Table.find(pro.Index,ind) or Citrus.Misc.Table.find(pro.Index,ind)()) or Citrus.Misc.Table.contains(self.Object,ind) and Citrus.Misc.Table.find(self.Object,ind) or Citrus.Properties.hasProperty(self.Instance,ind) and self.Instance[Citrus.Properties[ind]]
		--end
		__index = function(self,ind)
			local pro = getmetatable(self).Properties
			if Citrus.Misc.Table.contains(pro.Index,ind) then
				local ret = Citrus.Misc.Table.find(pro.Index,ind)
				return type(ret) ~= 'function' and ret or ret()
			elseif Citrus.Misc.Table.contains(self.Object,ind) or not Citrus.Properties.hasProperty(self.Instance,ind) then
				return Citrus.Misc.Table.find(self.Object,ind)
			elseif Citrus.Properties.hasProperty(self.Instance,ind) then
				return self.Instance[Citrus.Properties[ind]]
			end
		end;
		__newindex = function(self,ind,new)
			local pro = getmetatable(self).Properties
			if Citrus.Misc.Table.contains(pro.NewIndex,ind,new) then
				Citrus.Misc.Table.find(pro.NewIndex,ind)(new)
			elseif Citrus.Misc.Table.contains(self.Object,ind) or not Citrus.Properties.hasProperty(self.Instance,ind) then
				rawset(self.Object,ind,new)
			elseif Citrus.Properties.hasProperty(self.Instance,ind) then
				self.Instance[Citrus.Properties[ind]] = new
			end
		end;
		__call = function(self,prop)
			Citrus.Properties.setProperties(self.Instance,prop)
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
		local clone = Citrus.Misc.Table.clone(self)
		clone.Instance = ins
		insert(clone)
		return clone
	end;
	setmetatable(new,newmeta)
	insert(new)
	return new
end