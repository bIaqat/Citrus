Instance = setmetatable({
	newCustomClass = function(name,funct)
		local self = Citrus.Instance
		local pt = Citrus.Table
		getmetatable(self).Classes[name] = setmetatable({funct,Objects = {}},{
				__call = function(self,...)
					return self[1](...)
				end;
				__index = function(self,ind)
					return pt.contains(self.Objects,ind)
				end;
			})
	end;
	isA = function(is,a)
		local self = Citrus.Instance
		if self.isAClass(is) then
			is = Instance.new(is)
			return is:IsA(a)
		end
		return false
	end;
	isAClass = function(is)
		if pcall(function() return Instance.new(is) end) then
			return true
		else
			return false
		end
	end;
	newPure = function(class,...)
		local args = {...}
		if type(args[#args]) ~= 'table' then
			table.insert(args,{})
		end
		table.insert(args[#args],true)
		return Citrus.Instance.new(class,unpack(args))
	end;
	new = function(class,...)
		local self = Citrus.Instance
		local pt = Citrus.Table
		local args,storage,new,parent,properties = {...},getmetatable(self).Classes
		if typeof(args[1]) == 'Instance' or self.isAnObject(args[1]) then
			parent = self.getInstanceOf(args[1])
			table.remove(args,1)
		end
		if type(args[#args]) == 'table' then
			properties = args[#args]
			table.remove(args,#args)
		end
		new = pt.find(storage,class) and pt.find(storage,class)(unpack(args)) or Instance.new(class)
		new.Parent = parent
		local a = next(properties or {})
		if type(a) ~= 'number' then
			Citrus.Properties.setPropertiesToDefault(new)
		else
			table.remove(properties,a)
		end		
		Citrus.Properties.setProperties(new,properties or {})
		return new
	end;
	newInstance = function(class,parent,props)
		local new = Instance.new(class)
		local parent = Citrus.Instance.getInstanceOf(parent)
		props = props or type(parent) == 'table' and parent
		parent = type(parent) ~= 'table' and parent or nil
		local a = next(props or {})
		return Citrus.Properties.setProperties(Instance.new(class,parent),props or {})
	end;
	newObject = function(...)
		local function insert(who)
			rawset(getmetatable(Citrus.Instance).Objects,who.Instance,who)
		end
		local args,obj,class,parent,props = {...},{}
		for i,v in next,args do
			class = type(v) == 'string' and Citrus.Instance.isAClass(v) and v or class
			parent = typeof(v) == 'Instance' and v or parent
			props = type(v) == 'table' and Citrus.Table.length(obj) > 0 and v or props
			obj = type(v) == 'table' and Citrus.Table.length(obj) == 0 and v or obj
		end
		local ins = Citrus.Instance.newInstance(class,parent,props)
		local new = {Instance = ins,Object = obj}
		local newmeta = {
			Properties = {Index = {}, NewIndex = {}};
			__index = function(self,ind)
				local pro = getmetatable(self).Properties
				if Citrus.Table.contains(pro.Index,ind) then
					local ret = Citrus.Table.find(pro.Index,ind)
					return type(ret) ~= 'function' and ret or ret(self)
				elseif Citrus.Table.contains(self.Object,ind) or not Citrus.Properties.hasProperty(self.Instance,ind) then
					return Citrus.Table.find(self.Object,ind)
				elseif Citrus.Properties.hasProperty(self.Instance,ind) then
					return self.Instance[Citrus.Properties[ind]]
				end
			end;
			__newindex = function(self,ind,new)
				local pro = getmetatable(self).Properties
				if Citrus.Table.contains(pro.NewIndex,ind) then
					Citrus.Table.find(pro.NewIndex,ind)(self,new)
				elseif Citrus.Table.contains(self.Object,ind) or not Citrus.Properties.hasProperty(self.Instance,ind) then
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
			local clone = Citrus.Table.clone(self)
			clone.Instance = ins
			insert(clone)
			return clone
		end;
		setmetatable(new,newmeta)
		insert(new)
		return new
	end;
	getInstanceOf = function(who)
		local self = getmetatable(Citrus.Instance).Objects
		return Citrus.Table.indexOf(self,who) or who
	end;
	getObjectOf = function(who)
		local self = getmetatable(Citrus.Instance).Objects
		return Citrus.Table.find(self,who) or nil
	end;
	isAnObject = function(who)
		return Citrus.Instance.getObjectOf(who) and true or false
	end;
	getAncestors = function(who)
		local anc = {game}
		who = Citrus.Instance.getInstanceOf(who)
		local chain = Citrus.Misc.stringFilterOut(who:GetFullName(),'%.','game',nil,true)
		local ind = game
		for i,v in next,chain do
			ind = ind[v]
			table.insert(anc,ind)
		end
		return Citrus.Table.pack(Citrus.Table.reverse(anc),2)
	end;
},{
	Classes = {};
	Objects = {};
}
);