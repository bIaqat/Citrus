Instance = setmetatable({
		newCustomClass = function(name,funct)
			local self = Citrus.Instance
			local pt = Citrus.Misc.Table
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
				
		new = function(class,...)
			local self = Citrus.Instance
			local pt = Citrus.Misc.Table
			local args,storage,new,parent,properties = {...},getmetatable(self).Classes
			if typeof(args[1]) == 'Instance' or self.isObject(args[1]) then
				parent = self.getInstanceOf(args[1])
				table.remove(args,1)
			end
			if type(args[#args]) == 'table' then
				properties = args[#args]
				table.remove(args,#args)
			end
			new = pt.find(storage,class) and pt.find(storage,class)(unpack(args)) or Instance.new(class)
			new.Parent = parent
			Citrus.Properties.setProperties(new,Citrus.Settings.getDefault(class) or {})
			Citrus.Properties.setProperties(new,properties or {})
			return new
		end;
		newInstance = function(class,parent,props)
			local new = Instance.new(class)
			props = props or type(parent) == 'table' and parent
			parent = type(parent) == 'table' and nil or parent
			Citrus.Properties.setProperties(new,Citrus.Settings.getDefault(class) or {})
			return Citrus.Properties.setProperties(Instance.new(class,parent),props or {})
		end;
		newObject = function(class,...)
			local ins = Citrus.Instance
			local pt = Citrus.Misc.Table
			local args,parent,object,properties = {...}
			if typeof(ins.getInstanceOf(args[1])) == 'Instance' then
				parent = ins.getInstanceOf(args[1])
				table.remove(args,1)
			end
			if type(args[#args]) == 'table' then
				if #args == 1 then
					object = args[#args]
					table.remove(args,#args)
				else
					properties = args[#args]
					table.remove(args,#args)
					object = args
				end
			end
			local new = {Instance.new(class)}
			setmetatable(new,{
					Object = object or {};
					Properties = { Index = {}, NewIndex = {} };
					__index = function(self,ind)
						local obj = getmetatable(self).Object
						local prop = getmetatable(self).Properties
						if pt.contains(prop.Index,ind) then
							return pt.find(prop.Index,ind)()
						elseif pt.contains(obj,ind) then
							return pt.find(obj,ind)
						elseif Citrus.Properties.hasProperty(self[1],ind) then
							return self[1][Citrus.Properties[ind]]
						end
					end;
					__newindex = function(self,ind,new)
						local obj = getmetatable(self).Object
						local prop = getmetatable(self).Properties
						if pt.contains(prop.Index,ind) then
							pt.find(prop.Index,ind)(new)
						elseif pt.contains(obj,ind) then
							rawset(obj,ind,new)
						elseif Citrus.Properties.hasProperty(self[1],ind) then
							self[1][Citrus.Properties[ind]] = new
						end
					end;
				})
			function new:Index(name,what)
				local prop = getmetatable(self).Properties
				rawset(prop.Index,name,what)
			end
			function new:NewIndex(name,what)
				local prop = getmetatable(self).Properties
				rawset(prop.NewIndex,name,what)
			end
			function new:Clone(parent)
				local clone = Citrus.Misc.Table.clone(self)
				clone[1] = self[1]:Clone()
				clone[1].Parent = parent
				getmetatable(ins).Objects[clone] = clone[1]
				return clone
			end
			getmetatable(ins).Objects[new] = new[1]
			return new
		end;
		getInstanceOf = function(who)
			local self = getmetatable(Citrus.Instance).Objects
			return Citrus.Misc.Table.find(self,who) or typeof(who) == 'Instance' and who
		end;
		getObjectOf = function(who)
			local self = getmetatable(Citrus.Instance).Objects
			return Citrus.Misc.Table.indexOf(self,who) or typeof(who) == 'Instance' and who
		end;
		isObject = function(who)
			return Citrus.Instance.getObjectOf(who) and true or false
		end;
		getAncestors = function(who)
			local misc = Citrus.Misc
			who = Citrus.Instance.getInstaceOf(who)
			local chain = {game,unpack(misc.Functions.stringFilterOut(who:GetFullName(),'%.',nil,'game',true))}
			chain = misc.Table.reverse(chain)
			table.remove(chain,1)
			return misc.Table.reverse(chain)
		end;
	},{
		Classes = {};
		Objects = {};
	}
)