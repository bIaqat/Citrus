Objects = setmetatable({
	getAncestors = function(Object)
		local directory = {game};
		local ind = game
		for name in Object:GetFullName():gsub('%.','\0'):gmatch('%Z+') do
			local temp = ind[name]
			if not name == 'game' and game:GetService(name) or temp:IsAncestorOf(Object) then
				ind = temp
				table.insert(directory,ind)
			end
		end
		return directory
	end;
	Classes = setmetatable({},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				new = function(ClassName, onCreated)
					self[ClassName] = setmetatable({onCreated = onCreated, Objects = {}},{
						__call = function(self,...)
							local me = self.onCreated(...)
							table.insert(self.Objects,me)
							return me
						end
					});
				end;
				isA = function(Object, ClassName)
					return Object:IsA(ClassName) or self.ClassName.Objects[Object] or false
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end		
	});
	Customs = setmetatable({},{
		__index = function(self,index)
			local gelf, ret = getmetatable(self)
			gelf.__index = {}
			for i,v in next, {
				getCustomFromInstance = function(Object)
					return self[Object] or typeof(Object) == 'userdata' and Object or false
				end;
				isCustom = function(Object)
					return self[Object] and true or false
				end;
				new = function(ClassName, Parent, Props, CustomProps)
					local instance = type(ClassName) ~= 'string' and ClassName or Instance.new(ClassName)
					instance.Parent = Parent
					local object = newproxy(true)
					getmetatable(object).__index = {setmetatable = function(self, tab) for i,v in next, getmetatable(self) do getmetatable(self)[i] = nil end for i,v in next, tab do getmetatable(self)[i] = v end end}
					local objectMeta
					objectMeta = {
						Instance = instance, Object = CustomProps or {}, Index = {}, NewIndex = {};
						__index = function(proxy,ind)
							local objmeta = getmetatable(proxy)
							if ind == 'Instance' or ind == 'Object' then return objmeta[ind] end
							if objmeta.Index[ind] then
								local ret = objmeta.Index[ind]
								return type(ret) ~= 'function' and ret or ret(proxy)
							elseif objmeta.Object[ind] or not pcall(function() return objmeta.Instance[ind] or false end) then
								return objmeta.Object[ind]
							elseif objmeta.Instance[ind] then
								return objmeta.Instance[ind]
							end
						end;	
						__newindex = function(proxy,ind,new)
							local objmeta = getmetatable(proxy)
							if objmeta.NewIndex[ind] then
								objmeta.NewIndex[ind](objmeta,new)
							elseif objmeta.Object[ind] or not pcall(function() return objmeta.Instance[ind] or false end) or type(new) == 'function' then
								rawset(objmeta.Object,ind,new)
							elseif pcall(function() return objmeta.Instance[ind] or false end) then
								objmeta.Instance[ind] = new
							end
						end;	
						__call = function(objmeta,prop)
							local objmeta = getmetatable(objmeta)
							Spice.Properties.setProperties(objmeta.Instance,prop)
						end;
						__namecall = function(proxy, ...)
							local args = {...}
							local name = args[#args]
							if type(name) ~= 'string' then return getmetatable(proxy).__call(proxy,...) end
							table.remove(args,#args)
							local objmeta = getmetatable(proxy)
							local default = {
								Index = function(name,what)
									rawset(objmeta.Index,name,what)
								end;
								NewIndex = function(name,what)
									if type(what) == 'function' then
										rawset(objmeta.NewIndex,name,what)
									end
								end;
								Clone = function(parent,prop)
									local clone = newproxy(true)
									getmetatable(clone).__index = {setmetatable = function(self, tab) for i,v in next, getmetatable(self) do getmetatable(self)[i] = nil end for i,v in next, tab do getmetatable(self)[i] = v end end}
									local clonemeta = Spice.Table.clone(objmeta)
									clonemeta.Instance.Parent = parent
									clone:setmetatable(clonemeta)
									for i,v in next, prop or {} do
										if pcall(function() return clone[i] end) then
											clone[i] = v
											prop[i] = nil
										end
									end
									if prop then Spice.Properties.setProperties(clonemeta.Instance,prop) end
									return clone
								end;
							}
							if default[name] then return default[name](unpack(args)) end
							if objmeta.Instance[name] and type(objmeta.Instance[name]) == 'function' then
								return objmeta.Instance[name](objmeta.Instance,unpack(args))
							end
						end;
						__tostring = function(self)
							return 'Custom'..self.Instance.ClassName
						end;
					}
					object:setmetatable(objectMeta)
					rawset(self,instance,object)
					object(Props)
					return object					
				end;
			} do
				gelf.__index[i] = v
				if i == index then ret = v end
			end
			return ret
		end		
	});
},{
	__index = function(self,index)	
		local gelf,ret = getmetatable(self)
		gelf.__index = {}
		for i,v in next, {
			new = function(ClassName, Parent, ...) --faster
				local args, instance, props = {...}
				instance = self.Classes[ClassName] and self.Classes[ClassName](unpack(args)) or Instance.new(ClassName)
				instance.Parent = type(Parent) == 'table' and Parent.Instance or Parent
				if type(args[#args]) == 'table' then
					props = args[#args]
					args[#args] = nil
				end
				if props then
				Spice.Properties.setProperties(instance, props) end
				return instance
			end;
			newInstance = function(ClassName, Parent, Props)
				local instance = Instance.new(ClassName, Parent)
				for i,v in next, Props or {} do
					if not pcall(function() return instance[i] and true or false end) then
						Spice.Properties.setProperties(instance,Props)
					else
						instance[i] = v
						Props[i] = nil
					end
				end
				return instance
			end;
			newDefault = function(ClassName, Parent, ...)
				local args, instance, props = {...}
				instance = self.Classes[ClassName] and self.Classes[ClassName](unpack(args)) or Instance.new(ClassName)
				instance.Parent = type(Parent) == 'table' and Parent.Instance or Parent
				if type(args[#args]) == 'table' then
					props = args[#args]
					args[#args] = nil
				end	
				Spice.Properties.Default.toDefaultProperties(instance)	
				if props then		
				Spice.Properties.setProperties(instance, props) end
				return instance					
			end;
			clone = function(Object, Parent, Props)
				local clone = Object:Clone()
				clone.Parent = Parent
				if Props then
				Spice.Properties.setProperties(Object,Props) end
				return clone
			end;
		} do
			gelf.__index[i] = v
			if i == index then ret = v end
		end
		return ret
	end		
});
