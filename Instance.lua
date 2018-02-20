Instance = setmetatable({
		newCustomClass = function(name,funct)
			local self = Pineapple.Instance
			local pt = Pineapple.Misc.Table
			getmetatable(self).Classes[name] = setmetatable({funct,Objects = {}},{
					__call = function(self,...)
						return self[1](...)
					end;
					__index = function(self,ind)
						return pt.contains(self.Objects,ind)
					end;
				})
		end;
		IsA = function(is,a)
			if pcall(function() return Instance.new(is):IsA(a) end) then
				return true
			else 
				return false
			end
		end;
		new = function(class,...)
			local self = Pineapple.Instance
			local pt = Pineapple.Misc.Table
			local args,storage,new,parent,properties = {...},getmetatable(self).Classes
			if typeof(args[1]) == 'Instance' or self.isObject(args[1]) then
				parent = self.getInstanceOf(args[1])
				table.remove(args,1)
			end
			if type(args[#args]) == 'table' then
				properties = args[#args]
				table.remove(args,#args)
			end
			new = pt.contains(storage,class)==true and pt.find(storage,class)(unpack(args)) or Instance.new(class)
			new.Parent = parent
			Pineapple.Properties.setProperties(new,properties or {})
			return new
		end;
		newInstance = function(class,parent,props}
			props = props or type(parent) == 'table' and parent
			parent = type(parent) == 'table' and nil or parent
			return Pineapple.Properties.setProperties(Instance.new(class,parent),props or {})
		end;
		newObject = function(class,...)
			local in = Pineapple.Instance
			local pt = Pineapple.Misc.Table
			local args,parent,object,properties = {...}
			if typeof(in.getInstanceOf(args[1])) == 'Instance' then
				parent = in.getInstanceOf(args[1])
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
						elseif Pineapple.Properties.hasProperty(self[1],ind) then
							return self[1][Pineapple.Properties[ind]]
						end
					end;
					__newindex = function(self,ind,new)
						local obj = getmetatable(self).Object
						local prop = getmetatable(self).Properties
						if pt.contains(prop.Index,ind) then
							pt.find(prop.Index,ind)(new)
						elseif pt.contains(obj,ind) then
							rawset(obj,ind,new)
						elseif Pineapple.Properties.hasProperty(self[1],ind) then
							self[1][Pineapple.Properties[ind]] = new
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
				local clone = Pineapple.Misc.Table.clone(self)
				clone[1] = self[1]:Clone()
				clone[1].Parent = parent
				getmetatable(in).Objects[clone] = clone[1]
				return clone
			end
			getmetatable(in).Objects[new] = new[1]
			return new
		end;
		getInstanceOf = function(who)
			local self = getmetatable(Pineapple.Instance).Objects
			return Pineapple.Misc.Table.find(self,who) or typeof(who) == 'Instance' and who
		end;
		getObjectOf = function(who)
			local self = getmetatable(Pineapple.Instance).Objects
			return Pineapple.Misc.Table.IndexOf(self,who) or typeof(who) == 'Instance' and who
		end;
		getAncestors = function(who)
			local misc = Pineapple.Misc
			who = Pineapple.Instance.getInstaceOf(who)
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
			
			
		
